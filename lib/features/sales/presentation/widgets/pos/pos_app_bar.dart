import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../manager/sales_cubit.dart';

class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final InvoiceType invoiceType;
  final bool isEdit;
  final bool isReturn;
  final String? invoiceNumber;
  final Function() onTypeChanged;

  const PosAppBar({
    super.key,
    required this.invoiceType,
    required this.isEdit,
    required this.isReturn,
    this.invoiceNumber,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد عنوان الفاتورة
    String title = _getInvoiceTitle(invoiceType);
    String subtitle = '';

    if (isEdit) {
      title = 'تعديل فاتورة';
      subtitle = '#${invoiceNumber ?? "AUTO"}';
    } else if (isReturn) {
      title = 'إنشاء مرتجع';
      subtitle = 'عملية جديدة';
    }

    return AppBar(
      elevation: 0,
      centerTitle: true,
      // خلفية متدرجة حديثة
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: _getGradient(invoiceType),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(invoiceType).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent, // لجعل التدرج يظهر
      title: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                letterSpacing: 1.0,
              ),
            ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      actions: [
        if (!isEdit && !isReturn)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
              ),
              child: PopupMenuButton<InvoiceType>(
                offset: const Offset(0, 50),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
                ),
                tooltip: 'تغيير نوع الفاتورة',
                onSelected: (type) {
                  context.read<SalesCubit>().changeInvoiceType(type);
                  onTypeChanged();
                },
                itemBuilder: (context) => [
                  _buildPopupItem(InvoiceType.sales, 'فاتورة مبيعات', Icons.point_of_sale, Colors.green),
                  _buildPopupItem(InvoiceType.purchase, 'فاتورة مشتريات', Icons.shopping_bag, Colors.blue),
                  const PopupMenuDivider(),
                  _buildPopupItem(InvoiceType.salesReturn, 'مرتجع مبيعات', Icons.assignment_return, Colors.orange),
                  _buildPopupItem(InvoiceType.purchaseReturn, 'مرتجع مشتريات', Icons.remove_shopping_cart, Colors.red),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // عنصر القائمة المنبثقة بتصميم محسن
  PopupMenuItem<InvoiceType> _buildPopupItem(
      InvoiceType type, String text, IconData icon, Color color) {
    return PopupMenuItem(
      value: type,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10); // زيادة بسيطة للارتفاع

  // ---------------------------------------------------------------------------
  // دوال مساعدة للألوان والتدرجات
  // ---------------------------------------------------------------------------

  String _getInvoiceTitle(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales: return 'فاتورة مبيعات';
      case InvoiceType.purchase: return 'فاتورة مشتريات';
      case InvoiceType.salesReturn: return 'مرتجع مبيعات';
      case InvoiceType.purchaseReturn: return 'مرتجع مشتريات';
    }
  }

  LinearGradient _getGradient(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return const LinearGradient(
          colors: [Color(0xFF00b09b), Color(0xFF96c93d)], // تدرج أخضر عصري
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case InvoiceType.purchase:
        return const LinearGradient(
          colors: [Color(0xFF1A2980), Color(0xFF26D0CE)], // تدرج أزرق ملكي
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case InvoiceType.salesReturn:
        return const LinearGradient(
          colors: [Color(0xFFf12711), Color(0xFFf5af19)], // تدرج برتقالي ناري
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case InvoiceType.purchaseReturn:
        return const LinearGradient(
          colors: [Color(0xFF833ab4), Color(0xFFfd1d1d)], // تدرج أحمر بنفسجي
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getShadowColor(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales: return const Color(0xFF00b09b);
      case InvoiceType.purchase: return const Color(0xFF1A2980);
      case InvoiceType.salesReturn: return const Color(0xFFf12711);
      case InvoiceType.purchaseReturn: return const Color(0xFF833ab4);
    }
  }
}