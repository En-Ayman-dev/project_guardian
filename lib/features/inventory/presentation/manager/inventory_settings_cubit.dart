import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/add_unit_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/delete_unit_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_units_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/update_unit_usecase.dart';
import 'inventory_settings_state.dart';

@injectable
class InventorySettingsCubit extends Cubit<InventorySettingsState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase; // جديد

  final GetUnitsUseCase _getUnitsUseCase;
  final AddUnitUseCase _addUnitUseCase;
  final DeleteUnitUseCase _deleteUnitUseCase;
  final UpdateUnitUseCase _updateUnitUseCase; // جديد

  InventorySettingsCubit(
    this._getCategoriesUseCase,
    this._addCategoryUseCase,
    this._deleteCategoryUseCase,
    this._getUnitsUseCase,
    this._addUnitUseCase,
    this._deleteUnitUseCase,
    this._updateCategoryUseCase,
    this._updateUnitUseCase,
  ) : super(const InventorySettingsState());

  // --- Categories Logic ---

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (list) => emit(state.copyWith(isLoading: false, categories: list)),
    );
  }

  Future<void> addCategory(String name) async {
    // ننشئ كيان مؤقت، الـ Repository سيتكفل بالـ ID إذا لزم الأمر أو نولده هنا
    // في حالة Firestore، المودل الذي كتبناه يتجاهل الـ ID عند الإرسال (toJson) ويستخدم ID الوثيقة عند القراءة
    final entity = CategoryEntity(id: '', name: name);

    emit(
      state.copyWith(
        isLoading: true,
        isActionSuccess: false,
        errorMessage: null,
      ),
    );

    final result = await _addCategoryUseCase(entity);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        // نجاح الإضافة -> إعادة تحميل القائمة وتفعيل فلاج النجاح
        emit(state.copyWith(isActionSuccess: true));
        loadCategories();
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(
      state.copyWith(
        isLoading: true,
        isActionSuccess: false,
        errorMessage: null,
      ),
    );
    final result = await _deleteCategoryUseCase(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isActionSuccess: true));
        loadCategories();
      },
    );
  }

  // --- Units Logic ---

  Future<void> loadUnits() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getUnitsUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (list) => emit(state.copyWith(isLoading: false, units: list)),
    );
  }

  Future<void> addUnit(String name) async {
    final entity = UnitEntity(id: '', name: name);

    emit(
      state.copyWith(
        isLoading: true,
        isActionSuccess: false,
        errorMessage: null,
      ),
    );

    final result = await _addUnitUseCase(entity);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isActionSuccess: true));
        loadUnits();
      },
    );
  }

  Future<void> deleteUnit(String id) async {
    emit(
      state.copyWith(
        isLoading: true,
        isActionSuccess: false,
        errorMessage: null,
      ),
    );
    final result = await _deleteUnitUseCase(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isActionSuccess: true));
        loadUnits();
      },
    );
  }

// --- دالة تحديث القسم ---   
  Future<void> updateCategory(CategoryEntity category) async {
    emit(
      state.copyWith(
        isLoading: true,
        isActionSuccess: false,
        errorMessage: null,
      ),
    );
    final result = await _updateCategoryUseCase(category);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isActionSuccess: true));
        loadCategories();
      },
    );
  }

  // --- دالة تحديث الوحدة ---
  Future<void> updateUnit(UnitEntity unit) async {
    emit(
      state.copyWith(
        isLoading: true,
        isActionSuccess: false,
        errorMessage: null,
      ),
    );
    final result = await _updateUnitUseCase(unit);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isActionSuccess: true));
        loadUnits();
      },
    );
  }

  // دالة مساعدة لتصفير حالة النجاح بعد عرض الـ SnackBar
  void resetActionState() {
    emit(state.copyWith(isActionSuccess: false, errorMessage: null));
  }
}
