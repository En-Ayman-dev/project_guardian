// [phase_2] creation
// file: lib/features/reports/domain/entities/statement_line_entity.dart

import 'package:equatable/equatable.dart';

enum StatementSourceType { invoice, voucher }

class StatementLineEntity extends Equatable {
  final DateTime date;
  final String refNumber; // رقم المرجع (رقم الفاتورة أو السند)
  final String description; // البيان
  final double debit; // مدين (لنا) - يزيد المديونية
  final double credit; // دائن (علينا) - ينقص المديونية
  final double balance; // الرصيد بعد هذه الحركة
  final StatementSourceType sourceType; // نوع المصدر (للتنقل عند الضغط)
  final dynamic sourceObject; // الكائن الأصلي (InvoiceEntity or VoucherEntity)

  const StatementLineEntity({
    required this.date,
    required this.refNumber,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.sourceType,
    required this.sourceObject,
  });

  @override
  List<Object?> get props => [
        date,
        refNumber,
        description,
        debit,
        credit,
        balance,
        sourceType,
        sourceObject
      ];
}