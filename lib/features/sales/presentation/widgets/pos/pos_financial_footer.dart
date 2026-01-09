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
  final TextEditingController noteCtrl;
  final Function(double) onDiscountChanged;
  final Function(double) onPaidChanged;
  // إضافة دالة جديدة لتغيير النوع لضمان فصل المسؤوليات أو استدعاء Cubit
  final Function(InvoicePaymentType) onPaymentTypeChanged; 
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
    required this.onPaymentTypeChanged, // [NEW]
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = PosUtils.getThemeColor(state.invoiceType);
    final isSaved = state.lastSavedInvoice != null;
    final remaining = state.totalAmount - state.paidAmount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSaved) ...[
            // استخدام LayoutBuilder لجعل التصميم متجاوباً (حل لمشاكل الشاشات الصغيرة)
            LayoutBuilder(
              builder: (context, constraints) {
                // إذا كانت الشاشة ضيقة (موبايل)، اعرض العناصر عمودياً
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      _buildPaymentMethodSelector(context, themeColor),
                      const SizedBox(height: 16),
                      TextField(
                        controller: noteCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'أضف ملاحظات...',
                          prefixIcon: const Icon(Icons.note_alt_rounded, size: 20),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFinancialField(
                              label: 'الخصم',
                              controller: discountCtrl,
                              icon: Icons.percent_rounded,
                              onChanged: (val) => onDiscountChanged(PosUtils.parseAmount(val)),
                              enabled: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFinancialField(
                              label: 'المدفوع',
                              controller: paidCtrl,
                              icon: Icons.payments_rounded,
                              onChanged: (val) => onPaidChanged(PosUtils.parseAmount(val)),
                              enabled: state.paymentType == InvoicePaymentType.credit,
                              highlight: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } 
                // الشاشات الكبيرة (تابلت/ديسك توب) - التصميم السابق
                else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildPaymentMethodSelector(context, themeColor),
                            const SizedBox(height: 16),
                            TextField(
                              controller: noteCtrl,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'أضف ملاحظات على الفاتورة...',
                                prefixIcon: const Icon(Icons.note_alt_rounded, size: 20),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildFinancialField(
                              label: 'الخصم',
                              controller: discountCtrl,
                              icon: Icons.percent_rounded,
                              onChanged: (val) => onDiscountChanged(PosUtils.parseAmount(val)),
                              enabled: true,
                            ),
                            const SizedBox(height: 12),
                            _buildFinancialField(
                              label: 'المدفوع',
                              controller: paidCtrl,
                              icon: Icons.payments_rounded,
                              onChanged: (val) => onPaidChanged(PosUtils.parseAmount(val)),
                              enabled: state.paymentType == InvoicePaymentType.credit,
                              highlight: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1),
            ),
          ],

          if (isSaved)
            _buildPostSaveView(context, themeColor)
          else
            // جعل الفوتر السفلي متجاوباً أيضاً
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 500;
                return Flex(
                  direction: isSmall ? Axis.vertical : Axis.horizontal,
                  children: [
                    Expanded(
                      flex: isSmall ? 0 : 2,
                      child: Column(
                        crossAxisAlignment: isSmall ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الإجمالي النهائي',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                          Text(
                            state.totalAmount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: themeColor,
                              height: 1.2,
                            ),
                          ),
                          if (state.paymentType == InvoicePaymentType.credit)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: remaining > 0 ? Colors.red.shade50 : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'المتبقي: ${remaining.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: remaining > 0 ? Colors.red : Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSmall) const SizedBox(height: 16),
                    Expanded(
                      flex: isSmall ? 0 : 3,
                      child: SizedBox(
                        width: isSmall ? double.infinity : null,
                        child: ElevatedButton(
                          onPressed: onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 8,
                            shadowColor: themeColor.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_getActionIcon(), size: 28),
                              const SizedBox(width: 12),
                              Text(
                                _getActionText(),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildPaymentOption(
            type: InvoicePaymentType.cash,
            label: 'نقد',
            icon: Icons.money_rounded,
            isSelected: state.paymentType == InvoicePaymentType.cash,
            color: color,
          ),
          _buildPaymentOption(
            type: InvoicePaymentType.credit,
            label: 'آجل',
            icon: Icons.credit_card_rounded,
            isSelected: state.paymentType == InvoicePaymentType.credit,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required InvoicePaymentType type,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // [FIX] استدعاء دالة التغيير الممررة
          onPaymentTypeChanged(type);
          
          // [FIX] تحديث قيم الحقول النصية بناءً على النوع الجديد
          if (type == InvoicePaymentType.cash) {
            paidCtrl.text = state.totalAmount.toStringAsFixed(2);
            // مهم: تحديث القيمة في الـ Cubit أيضاً
            onPaidChanged(state.totalAmount);
          } else {
            paidCtrl.text = "0";
            onPaidChanged(0);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? color : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ... (باقي الودجات المساعدة كما هي: _buildFinancialField, _buildPostSaveView, etc.)
  
  Widget _buildFinancialField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Function(String) onChanged,
    bool enabled = true,
    bool highlight = false,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: highlight ? Colors.black : Colors.grey.shade700,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: enabled ? Colors.grey.shade700 : Colors.grey.shade400),
        filled: true,
        fillColor: enabled ? (highlight ? Colors.blue.shade50.withValues(alpha: 0.5) : Colors.grey.shade50) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPostSaveView(BuildContext context, Color color) {
    // ... (نفس الكود السابق مع استخدام themeColor)
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تمت العملية بنجاح!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                  Text(
                    'رقم الفاتورة: #${state.lastSavedInvoice?.invoiceNumber ?? "---"}',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
         // ... تكملة الأزرار (نفس السابق)
      ],
    );
  }
  
  // دوال النصوص والأيقونات كما هي
  String _getActionText() {
    if (isEdit) return 'تعديل الفاتورة';
    if (isReturn || state.invoiceType == InvoiceType.salesReturn || state.invoiceType == InvoiceType.purchaseReturn) {
      return 'حفظ المرتجع';
    }
    return 'إتمام العملية';
  }

  IconData _getActionIcon() {
    if (isEdit) return Icons.edit_rounded;
    if (isReturn) return Icons.assignment_return_rounded;
    return Icons.check_circle_rounded;
  }
}