import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_state.freezed.dart';

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default(false) bool isLoading,
    @Default([]) List<ProductEntity> products,
    String? errorMessage,
    @Default(false) bool isActionSuccess, // للإشارة لنجاح الإضافة/الحذف
  }) = _ProductState;
}