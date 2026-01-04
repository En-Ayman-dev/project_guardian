// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) =>
    _InvoiceModel(
      invoiceNumber: json['invoiceNumber'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Object),
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceModelToJson(_InvoiceModel instance) =>
    <String, dynamic>{
      'invoiceNumber': instance.invoiceNumber,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'date': const TimestampConverter().toJson(instance.date),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'tax': instance.tax,
      'totalAmount': instance.totalAmount,
    };
