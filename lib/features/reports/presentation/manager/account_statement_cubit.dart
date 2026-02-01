// [phase_3] modification
// file: lib/features/reports/presentation/manager/account_statement_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../sales/domain/entities/invoice_entity.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../accounting/domain/entities/voucher_entity.dart';
import '../../../accounting/domain/repositories/voucher_repository.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../domain/entities/statement_row_entity.dart';
import 'account_statement_state.dart';

@injectable
class AccountStatementCubit extends Cubit<AccountStatementState> {
  final SalesRepository _salesRepo;
  final VoucherRepository _voucherRepo;

  AccountStatementCubit(this._salesRepo, this._voucherRepo)
      : super(AccountStatementInitial());

  Future<void> generateStatement(ClientSupplierEntity client) async {
    emit(AccountStatementLoading());

    // 1. جلب البيانات
    final invoicesResult = await _salesRepo.getInvoices(limit: 10000);
    final vouchersResult = await _voucherRepo.getVouchersByClient(client.id);

    List<InvoiceEntity> allInvoices = [];
    List<VoucherEntity> allVouchers = [];
    String? errorMsg;

    invoicesResult.fold((l) => errorMsg = l.message,
        (r) => allInvoices = r.where((i) => i.clientId == client.id).toList());
    vouchersResult.fold((l) => errorMsg = l.message, (r) => allVouchers = r);

    if (errorMsg != null) {
      emit(AccountStatementError(errorMsg!));
      return;
    }

    // 2. دمج البيانات في قائمة واحدة
    List<StatementRowEntity> rows = [];

    // معالجة الفواتير
    for (var inv in allInvoices) {
      double debit = 0;
      double credit = 0;
      String desc = "";

      // قاعدة محاسبية:
      // فاتورة مبيعات = مدين (على العميل)
      // فاتورة مشتريات = دائن (للمورد)
      // المرتجعات عكس العملية الأصلية
      switch (inv.type) {
        case InvoiceType.sales:
          desc = "فاتورة مبيعات";
          debit = inv.totalAmount;
          break;
        case InvoiceType.salesReturn:
          desc = "مرتجع مبيعات";
          credit = inv.totalAmount;
          break;
        case InvoiceType.purchase:
          desc = "فاتورة مشتريات";
          credit = inv.totalAmount;
          break;
        case InvoiceType.purchaseReturn:
          desc = "مرتجع مشتريات";
          debit = inv.totalAmount;
          break;
      }

      rows.add(StatementRowEntity(
        date: inv.date,
        documentNumber: inv.invoiceNumber,
        description: desc,
        debit: debit,
        credit: credit,
      ));
    }

    // معالجة السندات
    for (var v in allVouchers) {
      double debit = 0;
      double credit = 0;
      String desc = "";

      // قاعدة محاسبية:
      // سند قبض (من عميل) = دائن (ينقص مديونية العميل)
      // سند صرف (لمورد) = مدين (ينقص دائنية المورد)
      if (v.type == VoucherType.receipt) {
        desc = "سند قبض";
        credit = v.amount;
      } else {
        desc = "سند صرف";
        debit = v.amount;
      }

      rows.add(StatementRowEntity(
        date: v.date,
        documentNumber: v.voucherNumber,
        description: desc,
        debit: debit,
        credit: credit,
      ));
    }

    // 3. الترتيب الزمني
    rows.sort((a, b) => a.date.compareTo(b.date));

    // 4. حساب الرصيد التراكمي والمجاميع
    List<StatementRowEntity> calculatedRows = [];
    double runningBalance = 0;
    double sumDebit = 0;
    double sumCredit = 0;

    for (var row in rows) {
      sumDebit += row.debit;
      sumCredit += row.credit;

      // المعادلة: الرصيد = الرصيد السابق + (مدين - دائن)
      runningBalance = runningBalance + (row.debit - row.credit);

      calculatedRows.add(StatementRowEntity(
        date: row.date,
        documentNumber: row.documentNumber,
        description: row.description,
        debit: row.debit,
        credit: row.credit,
        balance: runningBalance,
      ));
    }

    emit(AccountStatementLoaded(
      rows: calculatedRows,
      totalDebit: sumDebit,
      totalCredit: sumCredit,
      finalBalance: runningBalance,
    ));
  }
}
