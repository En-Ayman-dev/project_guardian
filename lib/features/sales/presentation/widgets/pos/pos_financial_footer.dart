import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../manager/sales_cubit.dart';
import '../../manager/sales_state.dart';
import 'pos_utils.dart';

class PosFinancialFooter extends StatelessWidget {
  final SalesState state;
  final bool isEdit;
  final bool isReturn;
  final TextEditingController discountCtrl;
  final TextEditingController paidCtrl;
  final TextEditingController noteCtrl;
  final Function(double) onDiscountChanged;
  final Function(double) onPaidChanged;
  final VoidCallback? onSubmit;

  const PosFinancialFooter({
    super.key,
    required this.state,
    required this.isEdit,
    required this.isReturn,
    required this.discountCtrl,
    required this.paidCtrl,
    required this.noteCtrl,
    required this.onDiscountChanged,
    required this.onPaidChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final color = PosUtils.getThemeColor(state.invoiceType);
    final isSaved = state.lastSavedInvoice != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Payment Type Selection
          if (!isSaved) ...[
            _buildPaymentTypeSelector(context, color),
            const SizedBox(height: 16),
          ],

          // 2. Financial Inputs & Notes (تم إعادة توزيعها)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- العمود الأيمن: الملخص + الملاحظات الكبيرة ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    _buildSummaryRow('المجموع الفرعي', state.subTotal),
                    
                    const SizedBox(height: 16), // مسافة فاصلة
                    
                    // [NEW] حقل الملاحظات الكبير
                    TextField(
                      controller: noteCtrl,
                      enabled: !isSaved,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3, // حد أقصى للارتفاع (يمكن زيادته أو جعله null)
                      minLines: 2, // ارتفاع مبدئي (سطرين)
                      decoration: InputDecoration(
                        labelText: 'ملاحظات الفاتورة',
                        alignLabelWithHint: true, // لمحاذاة النص للأعلى
                        hintText: 'اكتب تفاصيل إضافية هنا...',
                        prefixIcon: const Icon(Icons.note_alt_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 24), // مسافة بين العمودين

              // --- العمود الأيسر: الخصم والمدفوع ---
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: discountCtrl,
                      enabled: !isSaved,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'خصم إضافي',
                        prefixIcon: Icon(Icons.discount_outlined),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) =>
                          onDiscountChanged(PosUtils.parseAmount(val)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: paidCtrl,
                      enabled: !isSaved &&
                          state.paymentType == InvoicePaymentType.credit,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'المبلغ المدفوع',
                        prefixIcon: Icon(Icons.attach_money),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) =>
                          onPaidChanged(PosUtils.parseAmount(val)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          // 3. Totals & Action Buttons
          if (isSaved)
            _buildPostSaveActions(context, color)
          else
            _buildPreSaveActions(color),
        ],
      ),
    );
  }

  // --- Widgets for Payment Type Selector ---
  Widget _buildPaymentTypeSelector(BuildContext context, Color color) {
    return Row(
      children: [
        const Text(
          "طريقة الدفع: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SegmentedButton<InvoicePaymentType>(
            segments: const [
              ButtonSegment(
                value: InvoicePaymentType.cash,
                label: Text("نقد"),
                icon: Icon(Icons.money),
              ),
              ButtonSegment(
                value: InvoicePaymentType.credit,
                label: Text("آجل"),
                icon: Icon(Icons.credit_card),
              ),
            ],
            selected: {state.paymentType},
            onSelectionChanged: (Set<InvoicePaymentType> newSelection) {
              context.read<SalesCubit>().setPaymentType(newSelection.first);

              if (newSelection.first == InvoicePaymentType.cash) {
                paidCtrl.text = state.totalAmount.toStringAsFixed(2);
              } else {
                paidCtrl.text = "0";
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return color.withOpacity(0.2);
                }
                return null;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return color;
                }
                return Colors.grey[700];
              }),
            ),
          ),
        ),
      ],
    );
  }

  // --- Actions before saving ---
  Widget _buildPreSaveActions(Color color) {
    String buttonText = 'حفظ الفاتورة';
    IconData buttonIcon = Icons.save;
    Color btnColor = color;

    if (isEdit) {
      btnColor = Colors.orange.shade800;
      buttonText = 'تعديل الفاتورة';
      buttonIcon = Icons.edit;
    } else if (isReturn ||
        state.invoiceType == InvoiceType.salesReturn ||
        state.invoiceType == InvoiceType.purchaseReturn) {
      btnColor = Colors.red.shade800;
      buttonText = 'حفظ المرتجع';
      buttonIcon = Icons.reply;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTotalsColumn(color),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(150, 50),
          ),
          onPressed: onSubmit,
          icon: Icon(buttonIcon),
          label: Text(
            buttonText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // --- Actions after success saving ---
  Widget _buildPostSaveActions(BuildContext context, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                "تم حفظ الفاتورة بنجاح #${state.lastSavedInvoice?.invoiceNumber}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  discountCtrl.clear();
                  paidCtrl.clear();
                  noteCtrl.clear();
                  context.read<SalesCubit>().resetAfterSuccess();
                },
                icon: const Icon(Icons.add),
                label: const Text("فاتورة جديدة"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("جاري الطباعة...")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.print),
                label: const Text("طباعة الفاتورة"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalsColumn(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصافي النهائي',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          state.totalAmount.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              'المتبقي: ',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              (state.totalAmount - state.paidAmount).toStringAsFixed(2),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: (state.totalAmount - state.paidAmount) > 0
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}