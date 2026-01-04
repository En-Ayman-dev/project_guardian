import 'package:flutter/material.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../manager/sales_state.dart';
import 'pos_utils.dart';

class PosFinancialFooter extends StatelessWidget {
  final SalesState state;
  final bool isEdit;
  final bool isReturn;
  final TextEditingController discountCtrl;
  final TextEditingController paidCtrl;
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
    required this.onDiscountChanged,
    required this.onPaidChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final color = PosUtils.getThemeColor(state.invoiceType);
    final isReturnType =
        state.invoiceType == InvoiceType.salesReturn ||
        state.invoiceType == InvoiceType.purchaseReturn;

    Color buttonColor = color;
    String buttonText = 'حفظ الفاتورة';
    IconData buttonIcon = Icons.save;

    if (isEdit) {
      buttonColor = Colors.orange.shade800;
      buttonText = 'تعديل الفاتورة';
      buttonIcon = Icons.edit;
    } else if (isReturn || isReturnType) {
      buttonColor = Colors.red.shade800;
      buttonText = 'حفظ المرتجع';
      buttonIcon = Icons.reply;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildSummaryRow('المجموع الفرعي', state.subTotal),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: discountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'خصم إضافي',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => onDiscountChanged(PosUtils.parseAmount(val)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: paidCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'المبلغ المدفوع',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => onPaidChanged(PosUtils.parseAmount(val)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المتبقي',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    (state.totalAmount - state.paidAmount).toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (state.totalAmount - state.paidAmount) > 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                onPressed: onSubmit,
                icon: Icon(buttonIcon),
                label: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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