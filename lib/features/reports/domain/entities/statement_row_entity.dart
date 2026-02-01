// [phase_2] creation
// file: lib/features/reports/domain/entities/statement_row_entity.dart

class StatementRowEntity {
  final DateTime date;
  final String documentNumber; // رقم الفاتورة أو السند
  final String description;    // شرح العملية (فاتورة مبيعات، سند قبض...)
  final double debit;          // مدين (على العميل)
  final double credit;         // دائن (لصالح العميل)
  final double balance;        // الرصيد التراكمي (سيتم حسابه لاحقاً)

  StatementRowEntity({
    required this.date,
    required this.documentNumber,
    required this.description,
    required this.debit,
    required this.credit,
    this.balance = 0.0,
  });
}