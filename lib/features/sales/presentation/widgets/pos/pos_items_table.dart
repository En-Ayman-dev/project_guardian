import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/invoice_item_entity.dart';
import '../../manager/sales_cubit.dart';

class PosItemsTable extends StatelessWidget {
  final List<InvoiceItemEntity> items;

  const PosItemsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد عناصر في الفاتورة',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('المنتج')),
          DataColumn(label: Text('الوحدة')),
          DataColumn(label: Text('السعر')),
          DataColumn(label: Text('الكمية')),
          DataColumn(label: Text('الإجمالي')),
          DataColumn(label: Text('حذف')),
        ],
        rows: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(Text(item.unitName)),
              DataCell(Text(item.price.toStringAsFixed(2))),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: () => context
                          .read<SalesCubit>()
                          .updateItemQuantity(index, item.quantity - 1),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: () => context
                          .read<SalesCubit>()
                          .updateItemQuantity(index, item.quantity + 1),
                    ),
                  ],
                ),
              ),
              DataCell(Text(item.total.toStringAsFixed(2))),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      context.read<SalesCubit>().removeItem(index),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}