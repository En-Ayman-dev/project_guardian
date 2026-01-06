// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) =>
    _InvoiceModel(
      invoiceNumber: json['invoiceNumber'] as String,
      type: $enumDecode(_$InvoiceTypeEnumMap, json['type']),
      status:
          $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ??
          InvoiceStatus.draft,
      paymentType:
          $enumDecodeNullable(
            _$InvoicePaymentTypeEnumMap,
            json['paymentType'],
          ) ??
          InvoicePaymentType.cash,
      originalInvoiceNumber: json['originalInvoiceNumber'] as String?,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Object),
      dueDate: _$JsonConverterFromJson<Object, DateTime>(
        json['dueDate'],
        const TimestampConverter().fromJson,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$InvoiceModelToJson(_InvoiceModel instance) =>
    <String, dynamic>{
      'invoiceNumber': instance.invoiceNumber,
      'type': _$InvoiceTypeEnumMap[instance.type]!,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'paymentType': _$InvoicePaymentTypeEnumMap[instance.paymentType]!,
      'originalInvoiceNumber': instance.originalInvoiceNumber,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'date': const TimestampConverter().toJson(instance.date),
      'dueDate': _$JsonConverterToJson<Object, DateTime>(
        instance.dueDate,
        const TimestampConverter().toJson,
      ),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'tax': instance.tax,
      'totalAmount': instance.totalAmount,
      'paidAmount': instance.paidAmount,
      'note': instance.note,
    };

const _$InvoiceTypeEnumMap = {
  InvoiceType.sales: 'sales',
  InvoiceType.purchase: 'purchase',
  InvoiceType.salesReturn: 'salesReturn',
  InvoiceType.purchaseReturn: 'purchaseReturn',
};

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.posted: 'posted',
  InvoiceStatus.canceled: 'canceled',
};

const _$InvoicePaymentTypeEnumMap = {
  InvoicePaymentType.cash: 'cash',
  InvoicePaymentType.credit: 'credit',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
