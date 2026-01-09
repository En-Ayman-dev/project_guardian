import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../inventory/domain/entities/product_entity.dart';
import '../../../../inventory/domain/entities/product_unit_entity.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/entities/invoice_item_entity.dart';
import '../../manager/sales_cubit.dart';
import 'pos_utils.dart';

class PosProductEntry extends StatefulWidget {
  final InvoiceType invoiceType;
  final List<ProductEntity> products;

  const PosProductEntry({
    super.key,
    required this.invoiceType,
    required this.products,
  });

  @override
  State<PosProductEntry> createState() => _PosProductEntryState();
}

class _PosProductEntryState extends State<PosProductEntry> {
  final TextEditingController _qtyCtrl = TextEditingController(text: '1');
  final TextEditingController _searchCtrl = TextEditingController(); // للتحكم بمسح البحث
  ProductEntity? _tempSelectedProduct;
  ProductUnitEntity? _tempSelectedUnit;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = PosUtils.getThemeColor(widget.invoiceType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          // 1. حقل البحث عن المنتج (Autocomplete)
          final productSearchField = Autocomplete<ProductEntity>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<ProductEntity>.empty();
              }
              return widget.products.where(
                (p) =>
                    p.name.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ) ||
                    (p.barcode?.contains(textEditingValue.text) ?? false),
              );
            },
            displayStringForOption: (option) => option.name,
            onSelected: (product) {
              setState(() {
                _tempSelectedProduct = product;
                _tempSelectedUnit = product.baseUnit;
                _qtyCtrl.text = '1';
                // نحتفظ بالنص في _searchCtrl إذا أردنا
              });
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
              // ربط الكنترولر الداخلي بكنترولر خارجي إذا لزم الأمر
              // هنا نستخدم الكنترولر الموفر من Autocomplete
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج (اسم أو باركود)...',
                  prefixIcon: Icon(Icons.qr_code_scanner_rounded, color: themeColor),
                  suffixIcon: controller.text.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20), 
                          onPressed: () {
                            controller.clear();
                            setState(() {
                              _tempSelectedProduct = null;
                              _tempSelectedUnit = null;
                            });
                          }
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  child: Container(
                    width: constraints.maxWidth - (isMobile ? 0 : 32), // عرض مناسب
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.inventory_2_outlined, color: themeColor, size: 20),
                          ),
                          title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('باركود: ${option.barcode ?? "-"} | السعر: ${option.baseUnit.sellPrice}', 
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          trailing: Text('متاح: ${option.stock}', 
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );

          // 2. قائمة الوحدات (Dropdown)
          final unitDropdown = Container(
             padding: const EdgeInsets.symmetric(horizontal: 12),
             decoration: BoxDecoration(
               color: Colors.grey.shade50,
               borderRadius: BorderRadius.circular(15),
               border: Border.all(color: Colors.transparent), // يمكن تفعيله عند التركيز
             ),
             child: DropdownButtonHideUnderline(
               child: DropdownButton<ProductUnitEntity>(
                 key: ValueKey(_tempSelectedUnit),
                 value: _tempSelectedUnit,
                 isExpanded: true,
                 hint: const Text('الوحدة'),
                 icon: Icon(Icons.keyboard_arrow_down_rounded, color: themeColor),
                 items: _tempSelectedProduct?.units
                     .map(
                       (u) => DropdownMenuItem(
                         value: u,
                         child: Text(
                           '${u.unitName} (${u.sellPrice})',
                           overflow: TextOverflow.ellipsis,
                           style: const TextStyle(fontSize: 14),
                         ),
                       ),
                     )
                     .toList(),
                 onChanged: _tempSelectedProduct == null
                     ? null
                     : (val) => setState(() => _tempSelectedUnit = val),
               ),
             ),
          );

          // 3. حقل الكمية
          final qtyField = SizedBox(
            width: 100, // عرض ثابت مناسب
            child: TextField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'الكمية',
                prefixIcon: const Icon(Icons.numbers_rounded, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              ),
            ),
          );

          // 4. زر الإضافة
          final addButton = ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              elevation: 4,
              shadowColor: themeColor.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: (_tempSelectedProduct != null && _tempSelectedUnit != null)
                ? _addItem
                : null,
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: const Text('إضافة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          );

          // التخطيط (Layout)
          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                productSearchField,
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 2, child: unitDropdown),
                    const SizedBox(width: 12),
                    qtyField,
                  ],
                ),
                const SizedBox(height: 12),
                addButton,
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start, // محاذاة للأعلى
              children: [
                Expanded(flex: 4, child: productSearchField),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: unitDropdown),
                const SizedBox(width: 12),
                qtyField,
                const SizedBox(width: 12),
                addButton, // الزر لا يحتاج Expanded هنا ليكون بحجمه الطبيعي
              ],
            );
          }
        },
      ),
    );
  }

  void _addItem() {
    final qty = PosUtils.parseInt(_qtyCtrl.text);
    if (qty <= 0) return;

    final item = InvoiceItemEntity(
      productId: _tempSelectedProduct!.id,
      productName: _tempSelectedProduct!.name,
      unitId: _tempSelectedUnit!.unitId,
      unitName: _tempSelectedUnit!.unitName,
      conversionFactor: _tempSelectedUnit!.conversionFactor,
      quantity: qty,
      price: _tempSelectedUnit!.sellPrice,
      total: qty * _tempSelectedUnit!.sellPrice,
    );

    context.read<SalesCubit>().addItem(item);
    
    // إعادة تعيين الحقول لاستقبال منتج جديد
    // ملاحظة: لا نمسح المنتج المختار لسهولة إضافة وحدات أخرى لنفس المنتج،
    // لكن يمكن مسحه إذا كان التفضيل هو البدء من الصفر.
    setState(() {
      _qtyCtrl.text = '1';
      _tempSelectedProduct = null; // اختياري
      _tempSelectedUnit = null;    // اختياري
    });
    
    // إظهار تنبيه صغير
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${item.productName}'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }
}