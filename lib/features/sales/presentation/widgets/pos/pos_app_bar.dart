import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../manager/sales_cubit.dart';
import 'pos_utils.dart';

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
    final color = PosUtils.getThemeColor(invoiceType);
    String title = PosUtils.getInvoiceTitle(invoiceType);
    
    if (isEdit) title = 'تعديل فاتورة #${invoiceNumber ?? "AUTO"}';
    if (isReturn) title = 'إنشاء مرتجع (جديد)';

    return AppBar(
      backgroundColor: color,
      foregroundColor: Colors.white,
      title: Text(title),
      actions: [
        if (!isEdit && !isReturn)
          PopupMenuButton<InvoiceType>(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Change Invoice Type',
            onSelected: (type) {
              context.read<SalesCubit>().changeInvoiceType(type);
              onTypeChanged();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: InvoiceType.sales,
                child: Text('فاتورة مبيعات'),
              ),
              const PopupMenuItem(
                value: InvoiceType.purchase,
                child: Text('فاتورة مشتريات'),
              ),
              const PopupMenuItem(
                value: InvoiceType.salesReturn,
                child: Text('مرتجع مبيعات'),
              ),
              const PopupMenuItem(
                value: InvoiceType.purchaseReturn,
                child: Text('مرتجع مشتريات'),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}