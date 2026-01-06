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
    final isReturn = invoice.isReturn;

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الفاتورة #${invoice.invoiceNumber}'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Card ---
            _buildHeaderCard(themeColor),
            const SizedBox(height: 16),

            // --- Items Table ---
            const Text(
              "الأصناف",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildItemsTable(themeColor),
            const SizedBox(height: 24),

            // --- Footer / Totals ---
            _buildTotalsSection(themeColor),
            
            const SizedBox(height: 24),
            // --- Notes ---
            if (invoice.note != null && invoice.note!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ملاحظات:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(invoice.note!),
                  ],
                ),
              ),
            
             const SizedBox(height: 80), // مساحة للأزرار العائمة
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "print_btn",
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الطباعة قيد التطوير')),
               );
            },
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.print, color: Colors.white),
          ),
          const SizedBox(height: 16),
          // زر التعديل
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
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text("تعديل", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.clientName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.type == InvoiceType.sales ? 'عميل' : 'مورد',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    _getTypeName(invoice.type),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(Icons.calendar_today, "التاريخ", DateFormat('yyyy-MM-dd').format(invoice.date)),
                if (invoice.originalInvoiceNumber != null)
                   _infoItem(Icons.link, "مرجع", "#${invoice.originalInvoiceNumber}"),
                _infoItem(
                  invoice.paymentType == InvoicePaymentType.cash ? Icons.money : Icons.credit_card,
                  "الدفع",
                  invoice.paymentType == InvoicePaymentType.cash ? "نقد" : "آجل"
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3), // المنتج
          1: FlexColumnWidth(1), // الكمية
          2: FlexColumnWidth(1.5), // السعر
          3: FlexColumnWidth(1.5), // الإجمالي
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade200),
        ),
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            children: const [
              Padding(padding: EdgeInsets.all(8), child: Text('المنتج', style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8), child: Text('الكمية', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8), child: Text('السعر', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8), child: Text('المجموع', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          // Body
          ...invoice.items.map((item) {
            return TableRow(
              children: [
                Padding(padding: const EdgeInsets.all(8), child: Text(item.productName)),
                Padding(padding: const EdgeInsets.all(8), child: Text(item.quantity.toString(), textAlign: TextAlign.center)),
                Padding(padding: const EdgeInsets.all(8), child: Text(item.price.toStringAsFixed(2), textAlign: TextAlign.center)),
                Padding(padding: const EdgeInsets.all(8), child: Text(item.total.toStringAsFixed(2), textAlign: TextAlign.center)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(Color color) {
    return Column(
      children: [
        _summaryRow("المجموع الفرعي", invoice.subTotal),
        if (invoice.discount > 0)
          _summaryRow("الخصم", invoice.discount, isNegative: true),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("الصافي النهائي", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              invoice.totalAmount.toStringAsFixed(2),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("المدفوع", style: TextStyle(color: Colors.grey)),
            Text(invoice.paidAmount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(String label, double value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            "${isNegative ? '-' : ''}${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isNegative ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getColor(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales: return Colors.blue.shade700;
      case InvoiceType.salesReturn: return Colors.orange.shade700;
      case InvoiceType.purchase: return Colors.green.shade700;
      case InvoiceType.purchaseReturn: return Colors.red.shade700;
    }
  }

  String _getTypeName(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales: return 'مبيعات';
      case InvoiceType.salesReturn: return 'مرتجع مبيعات';
      case InvoiceType.purchase: return 'مشتريات';
      case InvoiceType.purchaseReturn: return 'مرتجع مشتريات';
    }
  }
}