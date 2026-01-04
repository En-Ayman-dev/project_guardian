// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      name: json['name'] as String,
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      units: (json['units'] as List<dynamic>)
          .map((e) => ProductUnitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stock: (json['stock'] as num?)?.toDouble() ?? 0.0,
      minStockAlert: (json['minStockAlert'] as num?)?.toInt() ?? 5,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Object,
      ),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'barcode': instance.barcode,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'units': instance.units.map((e) => e.toJson()).toList(),
      'stock': instance.stock,
      'minStockAlert': instance.minStockAlert,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
