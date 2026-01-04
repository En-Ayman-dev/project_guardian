import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/client_supplier_entity.dart';
import '../../domain/entities/enums/client_type.dart';
import '../../domain/usecases/add_client_supplier_usecase.dart';
import '../../domain/usecases/get_clients_suppliers_usecase.dart';
import 'client_supplier_state.dart';

@injectable
class ClientSupplierCubit extends Cubit<ClientSupplierState> {
  final GetClientsSuppliersUseCase _getUseCase;
  final AddClientSupplierUseCase _addUseCase;

  // سنحتاج للاحتفاظ بنوع القائمة الحالية (عملاء أم موردين) لإعادة التحديث
  ClientType _currentType = ClientType.client;

  ClientSupplierCubit(
    this._getUseCase,
    this._addUseCase,
  ) : super(const ClientSupplierState.initial());

  Future<void> getList(ClientType type) async {
    _currentType = type;
    emit(const ClientSupplierState.loading());
    
    final result = await _getUseCase(type);
    
    result.fold(
      (failure) => emit(ClientSupplierState.error(failure.message)),
      (list) => emit(ClientSupplierState.success(list)),
    );
  }

  Future<void> addEntry(ClientSupplierEntity entity) async {
    emit(const ClientSupplierState.loading());

    final result = await _addUseCase(entity);

    result.fold(
      (failure) => emit(ClientSupplierState.error(failure.message)),
      (_) {
        emit(const ClientSupplierState.actionSuccess());
        // إعادة تحميل القائمة بعد الإضافة الناجحة
        getList(_currentType); 
      },
    );
  }
}