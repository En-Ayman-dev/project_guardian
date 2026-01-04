// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/entities/client_supplier_entity.dart';
import '../../domain/entities/enums/client_type.dart';

part 'client_supplier_model.freezed.dart';
part 'client_supplier_model.g.dart';

@freezed
abstract class ClientSupplierModel with _$ClientSupplierModel {
  const ClientSupplierModel._();

  // تجاهل الـ id في الـ json لأنه يأتي من اسم الوثيقة، لكن سنحتاجه في التحويل
  const factory ClientSupplierModel({
    @JsonKey(includeFromJson: false, includeToJson: false) String? id, 
    required String name,
    required String phone,
    String? email,
    String? address,
    String? taxNumber,
    required ClientType type,
    @Default(0.0) double balance,
    @TimestampConverter() required DateTime createdAt,
  }) = _ClientSupplierModel;

  factory ClientSupplierModel.fromJson(Map<String, dynamic> json) =>
      _$ClientSupplierModelFromJson(json);

  // التحويل من Firestore Document
  factory ClientSupplierModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClientSupplierModel.fromJson(data).copyWith(id: doc.id);
  }

  // التحويل إلى Entity
  ClientSupplierEntity toEntity() {
    return ClientSupplierEntity(
      id: id ?? '',
      name: name,
      phone: phone,
      email: email,
      address: address,
      taxNumber: taxNumber,
      type: type,
      balance: balance,
      createdAt: createdAt,
    );
  }

  // التحويل من Entity
  factory ClientSupplierModel.fromEntity(ClientSupplierEntity entity) {
    return ClientSupplierModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      taxNumber: entity.taxNumber,
      type: entity.type,
      balance: entity.balance,
      createdAt: entity.createdAt,
    );
  }
}