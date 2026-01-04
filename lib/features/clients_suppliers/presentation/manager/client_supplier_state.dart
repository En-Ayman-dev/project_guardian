import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/client_supplier_entity.dart';

part 'client_supplier_state.freezed.dart';

@freezed
class ClientSupplierState with _$ClientSupplierState {
  const factory ClientSupplierState.initial() = _Initial;
  const factory ClientSupplierState.loading() = _Loading;
  const factory ClientSupplierState.success(List<ClientSupplierEntity> list) = _Success;
  const factory ClientSupplierState.error(String message) = _Error;
  // حالة خاصة لعمليات الإضافة/التعديل الناجحة (لإظهار رسالة نجاح والعودة للخلف)
  const factory ClientSupplierState.actionSuccess() = _ActionSuccess;
}