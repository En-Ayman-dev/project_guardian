// [phase_2] creation
// file: lib/features/reports/presentation/manager/general_balances_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';

part 'general_balances_state.freezed.dart';

@freezed
class GeneralBalancesState with _$GeneralBalancesState {
  const factory GeneralBalancesState.initial() = _Initial;
  const factory GeneralBalancesState.loading() = _Loading;
  const factory GeneralBalancesState.loaded({
    required List<ClientSupplierEntity> allEntities,
    required List<ClientSupplierEntity> filteredEntities,
    required double totalReceivables, // إجمالي المديونيات (لنا)
    required double totalPayables,    // إجمالي الالتزامات (علينا)
  }) = _Loaded;
  const factory GeneralBalancesState.error(String message) = _Error;
}