// [phase_2] modification
// file: lib/features/sales/presentation/pages/invoice_details_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/invoice_entity.dart';
import 'pos_page.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final InvoiceEntity invoice;

  const InvoiceDetailsPage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    // تحديد اللون الأساسي بناءً على نوع الفاتورة
    final themeColor = _getColor(invoice.type);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // تمديد التصميم خلف الـ AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تفاصيل الفاتورة #${invoice.invoiceNumber}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('المشاركة قيد التطوير')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. الخلفية الملونة المنحنية (Header)
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [themeColor, themeColor.withOpacity(0.8)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. المحتوى الرئيسي
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // --- الكرت العائم الرئيسي (معلومات العميل والنوع) ---
                  _buildFloatingHeaderCard(context, themeColor),

                  const SizedBox(height: 24),

                  // --- قسم الأصناف ---
                  _buildSectionTitle(
                    "تفاصيل الأصناف",
                    Icons.shopping_bag_outlined,
                    themeColor,
                  ),
                  const SizedBox(height: 12),
                  _buildItemsTable(themeColor),

                  const SizedBox(height: 24),

                  // --- القسم المالي (المجاميع) ---
                  _buildSectionTitle(
                    "الملخص المالي",
                    Icons.monetization_on_outlined,
                    themeColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTotalsSection(context, themeColor),

                  const SizedBox(height: 24),

                  // --- الملاحظات ---
                  if (invoice.note != null && invoice.note!.isNotEmpty)
                    _buildNotesSection(invoice.note!),

                  const SizedBox(height: 100), // مساحة للأزرار العائمة
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActions(context, themeColor),
    );
  }

  // ---------------------------------------------------------------------------
  // Widgets Components
  // ---------------------------------------------------------------------------

  Widget _buildFloatingHeaderCard(BuildContext context, Color themeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي: الحالة والنوع
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description, size: 16, color: themeColor),
                    const SizedBox(width: 6),
                    Text(
                      _getTypeName(invoice.type),
                      style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd • hh:mm a').format(invoice.date),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // اسم العميل
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                radius: 24,
                child: Icon(Icons.person, color: themeColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.clientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      invoice.type == InvoiceType.sales ? 'العميل' : 'المورد',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          // معلومات إضافية (المرجع، طريقة الدفع)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniInfo(
                Icons.payment,
                "الدفع",
                invoice.paymentType == InvoicePaymentType.cash ? "نقد" : "آجل",
              ),
              if (invoice.originalInvoiceNumber != null)
                _buildMiniInfo(
                  Icons.link,
                  "مرجع",
                  "#${invoice.originalInvoiceNumber}",
                ),
              _buildMiniInfo(Icons.numbers, "رقم", "#${invoice.invoiceNumber}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table Header
            Container(
              color: themeColor.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "المنتج",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "العدد",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "السعر",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "الإجمالي",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoice.items.length,
              separatorBuilder: (ctx, index) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = invoice.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          item.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.quantity.toString().replaceAll(
                              RegExp(r"([.]*0)(?!.*\d)"),
                              "",
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.price.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.total.toStringAsFixed(2),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsSection(BuildContext context, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow("المجموع الفرعي", invoice.subTotal),
          if (invoice.discount > 0)
            _buildSummaryRow("الخصم", invoice.discount, isNegative: true),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1),
          ),

          // الإجمالي النهائي بتصميم مميز
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الصافي النهائي",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${invoice.totalAmount.toStringAsFixed(2)} \$",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: themeColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // شريط المدفوع والمتبقي
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "المدفوع",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice.paidAmount.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 30, color: Colors.grey.shade300),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "المتبقي",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice.remainingAmount.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: invoice.remainingAmount > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isNegative = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            "${isNegative ? '-' : ''}${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isNegative ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(String note) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.orange,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "ملاحظات",
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
              color: Colors.black87,
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions(BuildContext context, Color themeColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: "print_btn",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('الطباعة قيد التطوير')),
            );
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          elevation: 2,
          child: const Icon(Icons.print_outlined),
        ),
        const SizedBox(height: 12),
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
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          label: const Text(
            "تعديل الفاتورة",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 4,
        ),
      ],
    );
  }

  // Helpers
  Color _getColor(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return const Color(0xFF1A73E8);
      case InvoiceType.salesReturn:
        return const Color(0xFFF57C00);
      case InvoiceType.purchase:
        return const Color(0xFF34A853);
      case InvoiceType.purchaseReturn:
        return const Color(0xFFD32F2F);
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
