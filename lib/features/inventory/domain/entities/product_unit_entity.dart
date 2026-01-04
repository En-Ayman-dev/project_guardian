import 'package:equatable/equatable.dart';

class ProductUnitEntity extends Equatable {
  final String unitId;
  final String unitName;
  final double conversionFactor; // معامل التحويل (مثلاً 12 للدرزن، 1 للحبة)
  final double buyPrice;
  final double sellPrice;
  final String? barcode;

  const ProductUnitEntity({
    required this.unitId,
    required this.unitName,
    required this.conversionFactor,
    required this.buyPrice,
    required this.sellPrice,
    this.barcode,
  });

  @override
  List<Object?> get props => [unitId, unitName, conversionFactor, buyPrice, sellPrice, barcode];
}