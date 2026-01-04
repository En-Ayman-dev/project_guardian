// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/unit_entity.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
abstract class UnitModel with _$UnitModel {
  const UnitModel._();

  const factory UnitModel({
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
    required String name,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  factory UnitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UnitModel.fromJson(data).copyWith(id: doc.id);
  }

  UnitEntity toEntity() {
    return UnitEntity(
      id: id ?? '',
      name: name,
    );
  }

  factory UnitModel.fromEntity(UnitEntity entity) {
    return UnitModel(
      id: entity.id,
      name: entity.name,
    );
  }
}