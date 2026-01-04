// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_item_entity.dart';

part 'invoice_item_model.freezed.dart';
part 'invoice_item_model.g.dart';

@freezed
abstract class InvoiceItemModel with _$InvoiceItemModel {
  const InvoiceItemModel._();

  // --- هام جداً: إضافة هذا السطر لمنع الانهيار ---
  @JsonSerializable(explicitToJson: true)
  // ----------------------------------------------
  const factory InvoiceItemModel({
    required String productId,
    required String productName,
    required String unitId,
    required String unitName,
    required double conversionFactor,
    required int quantity,
    required double price,
    required double total,
  }) = _InvoiceItemModel;

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);

  InvoiceItemEntity toEntity() {
    return InvoiceItemEntity(
      productId: productId,
      productName: productName,
      unitId: unitId,
      unitName: unitName,
      conversionFactor: conversionFactor,
      quantity: quantity,
      price: price,
      total: total,
    );
  }

  factory InvoiceItemModel.fromEntity(InvoiceItemEntity entity) {
    return InvoiceItemModel(
      productId: entity.productId,
      productName: entity.productName,
      unitId: entity.unitId,
      unitName: entity.unitName,
      conversionFactor: entity.conversionFactor,
      quantity: entity.quantity,
      price: entity.price,
      total: entity.total,
    );
  }
}