// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientSupplierModel _$ClientSupplierModelFromJson(Map<String, dynamic> json) =>
    _ClientSupplierModel(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      taxNumber: json['taxNumber'] as String?,
      type: $enumDecode(_$ClientTypeEnumMap, json['type']),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Object),
    );

Map<String, dynamic> _$ClientSupplierModelToJson(
        _ClientSupplierModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'taxNumber': instance.taxNumber,
      'type': _$ClientTypeEnumMap[instance.type]!,
      'balance': instance.balance,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$ClientTypeEnumMap = {
  ClientType.client: 'client',
  ClientType.supplier: 'supplier',
};
