import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/unit_entity.dart';

part 'inventory_settings_state.freezed.dart';

@freezed
abstract class InventorySettingsState with _$InventorySettingsState {
  const factory InventorySettingsState({
    @Default(false) bool isLoading,
    @Default([]) List<CategoryEntity> categories,
    @Default([]) List<UnitEntity> units,
    String? errorMessage,
    // متغير لتنبيه الواجهة بأن عملية (إضافة/حذف) تمت بنجاح لعرض رسالة
    @Default(false) bool isActionSuccess, 
  }) = _InventorySettingsState;
}