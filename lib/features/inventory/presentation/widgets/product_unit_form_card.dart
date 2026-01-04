import 'package:flutter/material.dart';
import '../../domain/entities/unit_entity.dart';

/// ويدجت لإدخال بيانات وحدة واحدة (سواء كانت أساسية أو فرعية)
class ProductUnitFormCard extends StatefulWidget {
  final int index;
  final List<UnitEntity> availableUnits;
  final bool isBaseUnit; // هل هذه هي الوحدة الأساسية؟ (لا يمكن تعديل المعامل)
  final VoidCallback onRemove;
  
  // Controllers (نمررها من الخارج للتحكم بها)
  final TextEditingController factorCtrl;
  final TextEditingController buyPriceCtrl;
  final TextEditingController sellPriceCtrl;
  final TextEditingController barcodeCtrl;
  final Function(UnitEntity?) onUnitChanged;
  final UnitEntity? selectedUnit;

  const ProductUnitFormCard({
    super.key,
    required this.index,
    required this.availableUnits,
    required this.isBaseUnit,
    required this.onRemove,
    required this.factorCtrl,
    required this.buyPriceCtrl,
    required this.sellPriceCtrl,
    required this.barcodeCtrl,
    required this.onUnitChanged,
    this.selectedUnit,
  });

  @override
  State<ProductUnitFormCard> createState() => _ProductUnitFormCardState();
}

class _ProductUnitFormCardState extends State<ProductUnitFormCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + Remove Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isBaseUnit ? "Base Unit (Default)" : "Sub Unit #${widget.index + 1}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.isBaseUnit ? Colors.green : Colors.blue,
                  ),
                ),
                if (!widget.isBaseUnit)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: widget.onRemove,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const Divider(),
            
            // Row 1: Unit Selection + Factor
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<UnitEntity>(
                    initialValue: widget.selectedUnit,
                    decoration: const InputDecoration(labelText: 'Unit *', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    items: widget.availableUnits.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
                    onChanged: widget.onUnitChanged,
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: widget.factorCtrl,
                    keyboardType: TextInputType.number,
                    // الوحدة الأساسية دائماً معاملها 1 ولا يمكن تغييره
                    enabled: !widget.isBaseUnit, 
                    decoration: const InputDecoration(labelText: 'Factor', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    validator: (v) => v!.isEmpty ? 'Req' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Row 2: Prices
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.buyPriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Buy Price', prefixIcon: Icon(Icons.attach_money, size: 16)),
                    validator: (v) => v!.isEmpty ? 'Req' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: widget.sellPriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Sell Price', prefixIcon: Icon(Icons.attach_money, size: 16)),
                    validator: (v) => v!.isEmpty ? 'Req' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Row 3: Barcode
            TextFormField(
              controller: widget.barcodeCtrl,
              decoration: const InputDecoration(labelText: 'Barcode (Optional)', prefixIcon: Icon(Icons.qr_code, size: 16)),
            ),
          ],
        ),
      ),
    );
  }
}