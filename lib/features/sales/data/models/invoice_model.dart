// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/entities/invoice_entity.dart';
import 'invoice_item_model.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
abstract class InvoiceModel with _$InvoiceModel {
  const InvoiceModel._();

  // --- هام جداً: إضافة هذا السطر ---
  @JsonSerializable(explicitToJson: true)
  // --------------------------------
  const factory InvoiceModel({
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
    required String invoiceNumber,
    required String clientId,
    required String clientName,
    @TimestampConverter() required DateTime date,
    
    // القائمة التي تسبب المشكلة إذا لم يكن explicitToJson مفعلاً
    required List<InvoiceItemModel> items, 
    
    required double subTotal,
    @Default(0.0) double discount,
    @Default(0.0) double tax,
    required double totalAmount,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  factory InvoiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InvoiceModel.fromJson(data).copyWith(id: doc.id);
  }

  InvoiceEntity toEntity() {
    return InvoiceEntity(
      id: id ?? '',
      invoiceNumber: invoiceNumber,
      clientId: clientId,
      clientName: clientName,
      date: date,
      items: items.map((e) => e.toEntity()).toList(),
      subTotal: subTotal,
      discount: discount,
      tax: tax,
      totalAmount: totalAmount,
    );
  }

  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id,
      invoiceNumber: entity.invoiceNumber,
      clientId: entity.clientId,
      clientName: entity.clientName,
      date: entity.date,
      items: entity.items.map((e) => InvoiceItemModel.fromEntity(e)).toList(),
      subTotal: entity.subTotal,
      discount: entity.discount,
      tax: entity.tax,
      totalAmount: entity.totalAmount,
    );
  }
}