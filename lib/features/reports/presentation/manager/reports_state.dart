// [phase_2] creation
// file: lib/features/reports/presentation/manager/reports_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/statement_line_entity.dart';

part 'reports_state.freezed.dart';

@freezed
class ReportsState with _$ReportsState {
  const factory ReportsState.initial() = _Initial;
  const factory ReportsState.loading() = _Loading;
  const factory ReportsState.statementLoaded(List<StatementLineEntity> lines) = _StatementLoaded;
  const factory ReportsState.error(String message) = _Error;
}