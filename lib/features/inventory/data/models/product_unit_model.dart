import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_unit_entity.dart';

part 'product_unit_model.freezed.dart';
part 'product_unit_model.g.dart';

@freezed
abstract class ProductUnitModel with _$ProductUnitModel {
  const ProductUnitModel._();

  const factory ProductUnitModel({
    required String unitId,
    required String unitName,
    required double conversionFactor,
    required double buyPrice,
    required double sellPrice,
    String? barcode,
  }) = _ProductUnitModel;

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) => _$ProductUnitModelFromJson(json);

  ProductUnitEntity toEntity() {
    return ProductUnitEntity(
      unitId: unitId,
      unitName: unitName,
      conversionFactor: conversionFactor,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      barcode: barcode,
    );
  }

  factory ProductUnitModel.fromEntity(ProductUnitEntity entity) {
    return ProductUnitModel(
      unitId: entity.unitId,
      unitName: entity.unitName,
      conversionFactor: entity.conversionFactor,
      buyPrice: entity.buyPrice,
      sellPrice: entity.sellPrice,
      barcode: entity.barcode,
    );
  }
}