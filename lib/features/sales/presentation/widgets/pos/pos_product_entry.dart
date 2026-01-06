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
  ProductEntity? _tempSelectedProduct;
  ProductUnitEntity? _tempSelectedUnit;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = PosUtils.getThemeColor(widget.invoiceType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

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
              });
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: 'ابحث عن منتج (اسم أو باركود)...',
                  prefixIcon: Icon(Icons.qr_code_scanner),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                ),
              );
            },
          );

          final unitDropdown = DropdownButtonFormField<ProductUnitEntity>(
            key: ValueKey(_tempSelectedUnit),
            initialValue: _tempSelectedUnit,
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              border: OutlineInputBorder(),
              labelText: 'الوحدة',
            ),
            items: _tempSelectedProduct?.units
                .map(
                  (u) => DropdownMenuItem(
                    value: u,
                    child: Text(
                      '${u.unitName} (${u.sellPrice})',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                )
                .toList(),
            onChanged: _tempSelectedProduct == null
                ? null
                : (val) => setState(() => _tempSelectedUnit = val),
          );

          final qtyField = SizedBox(
            width: 80,
            child: TextField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الكمية',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 0,
                ),
              ),
            ),
          );

          final addButton = ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              minimumSize: const Size(100, 50),
            ),
            onPressed:
                (_tempSelectedProduct != null && _tempSelectedUnit != null)
                    ? _addItem
                    : null,
            icon: const Icon(Icons.add),
            label: const Text('إضافة'),
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                productSearchField,
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(flex: 2, child: unitDropdown),
                    const SizedBox(width: 8),
                    qtyField,
                    const SizedBox(width: 8),
                    addButton,
                  ],
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(flex: 3, child: productSearchField),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: unitDropdown),
                const SizedBox(width: 8),
                qtyField,
                const SizedBox(width: 8),
                addButton,
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
    setState(() {
      _qtyCtrl.text = '1';
    });
  }
}