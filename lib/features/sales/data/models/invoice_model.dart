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

  @JsonSerializable(explicitToJson: true)
  const factory InvoiceModel({
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
    required String invoiceNumber,

    // --- حقول التصنيف والحالة (ERP) ---
    required InvoiceType type,
    @Default(InvoiceStatus.draft) InvoiceStatus status,

    // طريقة الدفع (نقد / آجل)
    @Default(InvoicePaymentType.cash) InvoicePaymentType paymentType,

    // [NEW] رقم الفاتورة الأصلية (للمرتجعات فقط)
    String? originalInvoiceNumber,

    // بيانات العميل
    required String clientId,
    required String clientName,

    // التواريخ
    @TimestampConverter() required DateTime date,
    @TimestampConverter() DateTime? dueDate,

    // العناصر
    required List<InvoiceItemModel> items,

    // الحسابات المالية
    required double subTotal,
    @Default(0.0) double discount,
    @Default(0.0) double tax,
    required double totalAmount,

    // المدفوعات والملاحظات
    @Default(0.0) double paidAmount,
    String? note,
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
      type: type,
      status: status,
      paymentType: paymentType,
      originalInvoiceNumber: originalInvoiceNumber, // [MAPPED]
      clientId: clientId,
      clientName: clientName,
      date: date,
      dueDate: dueDate,
      items: items.map((e) => e.toEntity()).toList(),
      subTotal: subTotal,
      discount: discount,
      tax: tax,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      note: note,
    );
  }

  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id,
      invoiceNumber: entity.invoiceNumber,
      type: entity.type,
      status: entity.status,
      paymentType: entity.paymentType,
      originalInvoiceNumber: entity.originalInvoiceNumber, // [MAPPED]
      clientId: entity.clientId,
      clientName: entity.clientName,
      date: entity.date,
      dueDate: entity.dueDate,
      items: entity.items.map((e) => InvoiceItemModel.fromEntity(e)).toList(),
      subTotal: entity.subTotal,
      discount: entity.discount,
      tax: entity.tax,
      totalAmount: entity.totalAmount,
      paidAmount: entity.paidAmount,
      note: entity.note,
    );
  }
}
