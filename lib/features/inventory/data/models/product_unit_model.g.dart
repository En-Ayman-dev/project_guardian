// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductUnitModel _$ProductUnitModelFromJson(Map<String, dynamic> json) =>
    _ProductUnitModel(
      unitId: json['unitId'] as String,
      unitName: json['unitName'] as String,
      conversionFactor: (json['conversionFactor'] as num).toDouble(),
      buyPrice: (json['buyPrice'] as num).toDouble(),
      sellPrice: (json['sellPrice'] as num).toDouble(),
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$ProductUnitModelToJson(_ProductUnitModel instance) =>
    <String, dynamic>{
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'conversionFactor': instance.conversionFactor,
      'buyPrice': instance.buyPrice,
      'sellPrice': instance.sellPrice,
      'barcode': instance.barcode,
    };
