// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/entities/product_entity.dart';
import 'product_unit_model.dart'; 

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  // هذا يجبر Freezed على توليد كود يحول القوائم المتداخلة إلى JSON بشكل صحيح
  @JsonSerializable(explicitToJson: true) 
  const factory ProductModel({
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
    required String name,
    String? description,
    
    // --- التعديل 1: إضافة حقل الباركود ---
    String? barcode,
    
    required String categoryId,
    required String categoryName,
    
    // القائمة الجديدة
    required List<ProductUnitModel> units, 
    
    @Default(0.0) double stock,
    @Default(5) int minStockAlert,
    @TimestampConverter() required DateTime createdAt,
  }) = _ProductModel;


  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson(data).copyWith(id: doc.id);
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? '',
      name: name,
      description: description,
      barcode: barcode, // --- التعديل 2: نقل الباركود للكيان ---
      categoryId: categoryId,
      categoryName: categoryName,
      units: units.map((u) => u.toEntity()).toList(),
      stock: stock,
      minStockAlert: minStockAlert,
      createdAt: createdAt,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      barcode: entity.barcode, // --- التعديل 3: نقل الباركود للمودل ---
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      units: entity.units.map((u) => ProductUnitModel.fromEntity(u)).toList(),
      stock: entity.stock,
      minStockAlert: entity.minStockAlert,
      createdAt: entity.createdAt,
    );
  }
}