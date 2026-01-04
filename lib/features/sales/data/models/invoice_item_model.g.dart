// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceItemModel _$InvoiceItemModelFromJson(Map<String, dynamic> json) =>
    _InvoiceItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      unitId: json['unitId'] as String,
      unitName: json['unitName'] as String,
      conversionFactor: (json['conversionFactor'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemModelToJson(_InvoiceItemModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'conversionFactor': instance.conversionFactor,
      'quantity': instance.quantity,
      'price': instance.price,
      'total': instance.total,
    };
