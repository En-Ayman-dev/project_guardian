import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductListTile extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // 1. استخراج الوحدة الأساسية للعرض
    final baseUnit = product.baseUnit;
    
    // تنبيه إذا المخزون أقل من الحد الأدنى
    final isLowStock = product.stock <= product.minStockAlert;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isLowStock ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
          child: Icon(
            Icons.inventory_2, 
            color: isLowStock ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض اسم التصنيف
            Text(product.categoryName, style: Theme.of(context).textTheme.bodySmall),
            
            // 2. عرض بيانات الوحدة الأساسية (السعر والباركود)
            Text(
              'Unit: ${baseUnit.unitName} | Sell: ${baseUnit.sellPrice}', 
              style: Theme.of(context).textTheme.bodySmall
            ),
            if (baseUnit.barcode != null)
               Text('Barcode: ${baseUnit.barcode}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.stock}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isLowStock ? Colors.red : Colors.black,
                  ),
                ),
                Text('Stock', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}