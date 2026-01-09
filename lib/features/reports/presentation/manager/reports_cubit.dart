// [phase_3] correction
// file: lib/features/reports/presentation/manager/reports_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/generate_account_statement_usecase.dart';
import '../../domain/entities/statement_line_entity.dart';
import '../../../../core/services/pdf_report_service.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import 'reports_state.dart';

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  final GenerateAccountStatementUseCase _generateStatement;
  final PdfReportService _pdfService;

  ReportsCubit(this._generateStatement, this._pdfService)
    : super(const ReportsState.initial());

  Future<void> getAccountStatement({
    required String clientSupplierId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(const ReportsState.loading());

    final result = await _generateStatement(
      clientSupplierId: clientSupplierId,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (failure) => emit(ReportsState.error('حدث خطأ في جلب البيانات')),
      (lines) => emit(ReportsState.statementLoaded(lines)),
    );
  }

  Future<void> exportStatementToPdf(
    ClientSupplierEntity client,
    List<StatementLineEntity> lines,
  ) async {
    try {
      final columns = ['التاريخ', 'المرجع', 'البيان', 'مدين', 'دائن', 'الرصيد'];

      final data = lines.map((line) {
        if (line.description == 'رصيد سابق / افتتاحي') {
          return [
            DateFormat('yyyy-MM-dd').format(line.date),
            '-',
            'رصيد سابق (افتتاحي)',
            '-',
            '-',
            line.balance.toStringAsFixed(2),
          ];
        }

        return [
          DateFormat('yyyy-MM-dd').format(line.date),
          line.refNumber,
          line.description,
          line.debit > 0 ? line.debit.toStringAsFixed(2) : '',
          line.credit > 0 ? line.credit.toStringAsFixed(2) : '',
          line.balance.toStringAsFixed(2),
        ];
      }).toList();

      double periodDebit = 0;
      double periodCredit = 0;

      for (var line in lines) {
        if (line.description != 'رصيد سابق / افتتاحي') {
          periodDebit += line.debit;
          periodCredit += line.credit;
        }
      }

      final finalBalance = lines.isNotEmpty ? lines.last.balance : 0.0;

      final summary = {
        'إجمالي حركة المدين': periodDebit.toStringAsFixed(2),
        'إجمالي حركة الدائن': periodCredit.toStringAsFixed(2),
        'الرصيد الحالي': finalBalance.toStringAsFixed(2),
      };

      await _pdfService.generateTablePdf(
        title: 'كشف حساب',
        subtitle:
            'الحساب: ${client.name}\nتاريخ الطباعة: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
        columns: columns,
        data: data,
        summary: summary,
      );
    } catch (e, stack) {
      // طباعة الخطأ الكامل في الكونسول
      print('---------- PDF EXPORT ERROR ----------');
      print('Error: $e');
      print('Stack Trace: $stack');
      print('--------------------------------------');
    }
  }
}
