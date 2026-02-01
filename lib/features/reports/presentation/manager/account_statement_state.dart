// [phase_3] modification
// file: lib/features/reports/presentation/manager/account_statement_state.dart

import '../../domain/entities/statement_row_entity.dart';

abstract class AccountStatementState {}

class AccountStatementInitial extends AccountStatementState {}

class AccountStatementLoading extends AccountStatementState {}

class AccountStatementLoaded extends AccountStatementState {
  final List<StatementRowEntity> rows;
  final double totalDebit;   // [NEW] إجمالي المدين
  final double totalCredit;  // [NEW] إجمالي الدائن
  final double finalBalance; // الرصيد النهائي

  AccountStatementLoaded({
    required this.rows,
    required this.totalDebit,
    required this.totalCredit,
    required this.finalBalance,
  });
}

class AccountStatementError extends AccountStatementState {
  final String message;
  AccountStatementError(this.message);
}