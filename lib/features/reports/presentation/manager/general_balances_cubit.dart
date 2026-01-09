// [phase_2] creation
// file: lib/features/reports/presentation/manager/general_balances_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/pdf_report_service.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../../domain/usecases/get_general_balances_usecase.dart';
import 'general_balances_state.dart';

@injectable
class GeneralBalancesCubit extends Cubit<GeneralBalancesState> {
  final GetGeneralBalancesUseCase _getBalances;
  final PdfReportService _pdfService;

  GeneralBalancesCubit(this._getBalances, this._pdfService) : super(const GeneralBalancesState.initial());

  Future<void> loadBalances() async {
    emit(const GeneralBalancesState.loading());

    final result = await _getBalances();

    result.fold(
      (failure) => emit(GeneralBalancesState.error(failure.message)),
      (entities) {
        // حساب الإجماليات
        // افتراض: 
        // - العميل: رصيد موجب = لنا (Receivable)
        // - المورد: رصيد موجب = علينا (Payable) ... أو العكس حسب سياسة النظام لديك.
        // للتوافق مع ما سبق: 
        // سنفترض أن Balance يخزن القيمة الصافية.
        // إذا كان عميل والرصيد > 0 -> لنا.
        // إذا كان مورد والرصيد > 0 -> علينا (أو العكس، سأوحد المنطق هنا).
        
        // *المنطق المعتمد هنا:*
        // Total Receivables (لنا): مجموع أرصدة العملاء الموجبة + (أرصدة الموردين السالبة إذا وجدت أي دفعنا زيادة)
        // Total Payables (علينا): مجموع أرصدة الموردين الموجبة + (أرصدة العملاء السالبة إذا وجدت أي دفعوا زيادة)
        
        double receivables = 0;
        double payables = 0;

        for (var e in entities) {
          if (e.type == ClientType.client) {
            if (e.balance >= 0) receivables += e.balance;
            else payables += e.balance.abs();
          } else {
            // مورد
            if (e.balance >= 0) payables += e.balance; // دين علينا
            else receivables += e.balance.abs(); // لنا عند المورد
          }
        }

        emit(GeneralBalancesState.loaded(
          allEntities: entities,
          filteredEntities: entities,
          totalReceivables: receivables,
          totalPayables: payables,
        ));
      },
    );
  }

  void search(String query) {
    state.mapOrNull(loaded: (s) {
      if (query.isEmpty) {
        emit(s.copyWith(filteredEntities: s.allEntities));
      } else {
        final filtered = s.allEntities.where((e) {
          return e.name.toLowerCase().contains(query.toLowerCase()) ||
                 e.phone.contains(query);
        }).toList();
        emit(s.copyWith(filteredEntities: filtered));
      }
    });
  }

  void filterByType(ClientType? type) {
    state.mapOrNull(loaded: (s) {
      if (type == null) {
        emit(s.copyWith(filteredEntities: s.allEntities));
      } else {
        final filtered = s.allEntities.where((e) => e.type == type).toList();
        emit(s.copyWith(filteredEntities: filtered));
      }
    });
  }

  Future<void> exportToPdf() async {
    state.mapOrNull(loaded: (s) async {
      final columns = ['الاسم', 'النوع', 'الهاتف', 'الرصيد', 'الحالة'];
      
      final data = s.filteredEntities.map((e) {
        final isClient = e.type == ClientType.client;
        String status = '';
        if (e.balance == 0) status = 'متزن';
        else if (isClient) status = e.balance > 0 ? 'مدين (لنا)' : 'دائن (علينا)';
        else status = e.balance > 0 ? 'دائن (علينا)' : 'مدين (لنا)';

        return [
          e.name,
          isClient ? 'عميل' : 'مورد',
          e.phone,
          e.balance.abs().toStringAsFixed(2),
          status,
        ];
      }).toList();

      final summary = {
        'إجمالي مستحقاتنا (لنا)': s.totalReceivables.toStringAsFixed(2),
        'إجمالي التزاماتنا (علينا)': s.totalPayables.toStringAsFixed(2),
        'الصافي': (s.totalReceivables - s.totalPayables).toStringAsFixed(2),
      };

      await _pdfService.generateTablePdf(
        title: 'تقرير الأرصدة العامة',
        subtitle: 'تاريخ التقرير: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
        columns: columns,
        data: data,
        summary: summary,
      );
    });
  }
}