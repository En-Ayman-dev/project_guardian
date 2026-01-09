import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/invoice_item_entity.dart';
import '../../manager/sales_cubit.dart';

class PosItemsTable extends StatelessWidget {
  final List<InvoiceItemEntity> items;

  const PosItemsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // الحالة الفارغة (Empty State) بتصميم أجمل ومرونة
    if (items.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'السلة فارغة',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قم بإضافة منتجات لبدء الفاتورة',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // التبديل بين تصميم الموبايل وتصميم الجدول بناءً على العرض
            if (constraints.maxWidth < 700) {
              return _buildMobileList(context);
            } else {
              return _buildDesktopTable(context);
            }
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. تصميم الموبايل (Cards View)
  // ---------------------------------------------------------------------------
  Widget _buildMobileList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي: الاسم والحذف
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                    onPressed: () => context.read<SalesCubit>().removeItem(index),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // الصف الأوسط: السعر والوحدة
              Row(
                children: [
                  _buildTag(item.unitName, Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '${item.price} \$',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1),
              ),

              // الصف السفلي: التحكم بالكمية والإجمالي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQtyControl(context, index, item.quantity),
                  Text(
                    '${item.total.toStringAsFixed(2)} \$',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 2. تصميم سطح المكتب/التابلت (Custom Table View)
  // ---------------------------------------------------------------------------
  Widget _buildDesktopTable(BuildContext context) {
    return Column(
      children: [
        // رأس الجدول
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: const [
              SizedBox(width: 30, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              Expanded(flex: 3, child: Text('المنتج', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              Expanded(flex: 1, child: Text('الوحدة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              Expanded(flex: 1, child: Text('السعر', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              Expanded(flex: 2, child: Center(child: Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)))),
              Expanded(flex: 1, child: Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              SizedBox(width: 40), // مساحة لزر الحذف
            ],
          ),
        ),
        
        // محتوى الجدول
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30, 
                      child: Text(
                        '${index + 1}', 
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12)
                      )
                    ),
                    Expanded(
                      flex: 3, 
                      child: Text(
                        item.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                    Expanded(
                      flex: 1, 
                      child: _buildTag(item.unitName, Colors.blue)
                    ),
                    Expanded(
                      flex: 1, 
                      child: Text(item.price.toStringAsFixed(2))
                    ),
                    Expanded(
                      flex: 2, 
                      child: Center(child: _buildQtyControl(context, index, item.quantity))
                    ),
                    Expanded(
                      flex: 1, 
                      child: Text(
                        item.total.toStringAsFixed(2),
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                      )
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                        onPressed: () => context.read<SalesCubit>().removeItem(index),
                        tooltip: 'حذف',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // مكونات مساعدة
  // ---------------------------------------------------------------------------

  // ودجت للتحكم بالكمية (كبسولة)
  Widget _buildQtyControl(BuildContext context, int index, int qty) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyButton(
            icon: Icons.remove,
            onTap: () => context.read<SalesCubit>().updateItemQuantity(index, qty - 1),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 30),
            alignment: Alignment.center,
            child: Text(
              '$qty',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildQtyButton(
            icon: Icons.add,
            onTap: () => context.read<SalesCubit>().updateItemQuantity(index, qty + 1),
            isAdd: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({required IconData icon, required VoidCallback onTap, bool isAdd = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon, 
          size: 18, 
          color: isAdd ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  // ودجت لعرض الوحدة (تاج صغير)
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}