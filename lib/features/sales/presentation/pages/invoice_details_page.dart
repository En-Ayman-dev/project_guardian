import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/invoice_entity.dart';
import 'pos_page.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final InvoiceEntity invoice;

  const InvoiceDetailsPage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final themeColor = _getColor(invoice.type);

    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية أهدأ للعين
      appBar: AppBar(
        title: Text(
          'تفاصيل الفاتورة #${invoice.invoiceNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // تحسين للعرض على التابلت والشاشات العريضة
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Card ---
                  _buildHeaderCard(themeColor),
                  const SizedBox(height: 20),

                  // --- Items Section ---
                  Row(
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: themeColor),
                      const SizedBox(width: 8),
                      const Text(
                        "قائمة الأصناف",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildItemsTable(themeColor),
                  const SizedBox(height: 24),

                  // --- Footer / Totals ---
                  _buildTotalsSection(context, themeColor),

                  const SizedBox(height: 24),
                  // --- Notes ---
                  if (invoice.note != null && invoice.note!.isNotEmpty)
                    _buildNotesSection(invoice.note!),

                  const SizedBox(height: 100), // مساحة إضافية للأزرار العائمة
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: "print_btn",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الطباعة قيد التطوير')),
              );
            },
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.print, color: Colors.white),
          ),
          const SizedBox(height: 12),
          // زر التعديل بتصميم أكبر وأوضح
          FloatingActionButton.extended(
            heroTag: "edit_btn",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PosPage(invoiceToEdit: invoice),
                ),
              );
            },
            backgroundColor: themeColor,
            elevation: 4,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              "تعديل الفاتورة",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets ---

  Widget _buildHeaderCard(Color color) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // الصف العلوي: اسم العميل ونوع الفاتورة
            // FIX: تم استخدام Expanded لحل مشكلة الـ Overflow
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.clientName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          invoice.type == InvoiceType.sales ? 'عميل' : 'مورد',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    _getTypeName(invoice.type),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            // معلومات الفاتورة بتوزيع متجاوب (Wrap)
            Wrap(
              spacing: 20,
              runSpacing: 15,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _infoItem(
                  Icons.calendar_today_outlined,
                  "التاريخ",
                  DateFormat('yyyy-MM-dd').format(invoice.date),
                ),
                if (invoice.originalInvoiceNumber != null)
                  _infoItem(
                    Icons.link,
                    "مرجع",
                    "#${invoice.originalInvoiceNumber}",
                  ),
                _infoItem(
                  invoice.paymentType == InvoicePaymentType.cash
                      ? Icons.monetization_on_outlined
                      : Icons.credit_card_outlined,
                  "طريقة الدفع",
                  invoice.paymentType == InvoicePaymentType.cash
                      ? "نقد"
                      : "آجل",
                ),
                _infoItem(
                  Icons.access_time,
                  "الوقت",
                  DateFormat('hh:mm a').format(invoice.date),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(Color color) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5), // المنتج - مساحة أكبر
          1: FlexColumnWidth(0.8), // الكمية
          2: FlexColumnWidth(1.2), // السعر
          3: FlexColumnWidth(1.2), // الإجمالي
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade200),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(color: color.withOpacity(0.08)),
            children: const [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'المنتج',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'العدد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'السعر',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'الإجمالي',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          // Body
          ...invoice.items.map((item) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.quantity.toString().replaceAll(
                        RegExp(r"([.]*0)(?!.*\d)"),
                        "",
                      ), // إزالة الأصفار العشرية الزائدة
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    item.price.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    item.total.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryRow("المجموع الفرعي", invoice.subTotal),
          if (invoice.discount > 0)
            _summaryRow(
              "الخصم",
              invoice.discount,
              isNegative: true,
              icon: Icons.discount,
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 1, radius: BorderRadius.all(  Radius.circular(2))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الصافي النهائي",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  invoice.totalAmount.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: Colors.green,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "المبلغ المدفوع",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  invoice.paidAmount.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (invoice.remainingAmount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "المتبقي",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    invoice.remainingAmount.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesSection(String note) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // لون أصفر فاتح للملاحظات
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.note_alt_outlined, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                "ملاحظات الفاتورة",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double value, {
    bool isNegative = false,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Text(
            "${isNegative ? '-' : ''}${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isNegative ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    // استخدام SizedBox لضمان حجم أدنى للعنصر ليظهر بشكل جيد داخل Wrap
    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getColor(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return Colors.blue.shade700;
      case InvoiceType.salesReturn:
        return Colors.orange.shade700;
      case InvoiceType.purchase:
        return Colors.green.shade700;
      case InvoiceType.purchaseReturn:
        return Colors.red.shade700;
    }
  }

  String _getTypeName(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return 'مبيعات';
      case InvoiceType.salesReturn:
        return 'مرتجع مبيعات';
      case InvoiceType.purchase:
        return 'مشتريات';
      case InvoiceType.purchaseReturn:
        return 'مرتجع مشتريات';
    }
  }
}
