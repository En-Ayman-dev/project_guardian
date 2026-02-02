// [phase_3] refactor - Professional Accounting Logic
// file: lib/features/reports/domain/usecases/generate_account_statement_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../accounting/domain/repositories/accounting_repository.dart';
import '../../../accounting/domain/entities/voucher_entity.dart';
import '../../../sales/domain/entities/invoice_entity.dart';
import '../entities/statement_line_entity.dart';

@lazySingleton
class GenerateAccountStatementUseCase {
  final SalesRepository salesRepository;
  final AccountingRepository accountingRepository;

  GenerateAccountStatementUseCase(
    this.salesRepository,
    this.accountingRepository,
  );

  Future<Either<Failure, List<StatementLineEntity>>> call({
    required String clientSupplierId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // 1. جلب البيانات الخام كاملة
      final invoicesResult = await salesRepository.getInvoices(limit: 10000); // جلب كل الفواتير
      final vouchersResult = await accountingRepository.getVouchers();

      return invoicesResult.fold(
        (failure) => Left(failure),
        (allInvoices) {
          return vouchersResult.fold(
            (failure) => Left(failure),
            (allVouchers) {
              // 2. تصفية البيانات الخاصة بالعميل المحدد فقط
              final clientInvoices = allInvoices
                  .where((inv) => inv.clientId == clientSupplierId)
                  .toList();
              
              final clientVouchers = allVouchers
                  .where((v) => v.clientSupplierId == clientSupplierId)
                  .toList();

              // دمج الكل في قائمة واحدة مؤقتة للفرز
              List<_TempTransaction> allTransactions = [];

              // تحويل الفواتير
              for (var inv in clientInvoices) {
                double debit = 0;
                double credit = 0;
                // منطق: الفاتورة (مبيعات) = مدين للعميل (عليه فلوس)
                // المرتجع = دائن للعميل (له فلوس)
                if (inv.type == InvoiceType.sales) {
                  debit = inv.totalAmount;
                } else if (inv.type == InvoiceType.salesReturn) credit = inv.totalAmount;
                else if (inv.type == InvoiceType.purchase) credit = inv.totalAmount;
                else if (inv.type == InvoiceType.purchaseReturn) debit = inv.totalAmount;

                allTransactions.add(_TempTransaction(
                  date: inv.date,
                  debit: debit,
                  credit: credit,
                  source: StatementLineEntity(
                    date: inv.date,
                    refNumber: '#${inv.invoiceNumber}',
                    description: _getInvoiceDesc(inv.type),
                    debit: debit,
                    credit: credit,
                    balance: 0,
                    sourceType: StatementSourceType.invoice,
                    sourceObject: inv,
                  ),
                ));
              }

              // تحويل السندات
              for (var v in clientVouchers) {
                double debit = 0;
                double credit = 0;
                // سند قبض (استلمنا منه) = دائن (نقص رصيده)
                // سند صرف (أعطيناه) = مدين (زاد رصيده)
                if (v.type == VoucherType.receipt) {
                  credit = v.amount;
                } else {
                  debit = v.amount;
                }

                allTransactions.add(_TempTransaction(
                  date: v.date,
                  debit: debit,
                  credit: credit,
                  source: StatementLineEntity(
                    date: v.date,
                    refNumber: v.voucherNumber,
                    description: v.note.isNotEmpty ? v.note : 'سند ${v.type == VoucherType.receipt ? 'قبض' : 'صرف'}',
                    debit: debit,
                    credit: credit,
                    balance: 0,
                    sourceType: StatementSourceType.voucher,
                    sourceObject: v,
                  ),
                ));
              }

              // 3. الترتيب الزمني للأقدم أولاً
              allTransactions.sort((a, b) => a.date.compareTo(b.date));

              // 4. المنطق المحاسبي (الرصيد السابق + حركات الفترة)
              List<StatementLineEntity> finalLines = [];
              double runningBalance = 0;
              
              // تحديد تاريخ البداية (إذا لم يحدد، نعتبره من البداية)
              final effectiveStartDate = startDate ?? DateTime(2000); 
              // تحديد تاريخ النهاية (إذا لم يحدد، نعتبره للمستقبل البعيد)
              final effectiveEndDate = endDate ?? DateTime(3000);

              // أ) حساب الرصيد الافتتاحي (كل العمليات قبل تاريخ البداية)
              double openingBalance = 0;
              
              if (startDate != null) {
                for (var t in allTransactions) {
                  if (t.date.isBefore(effectiveStartDate)) {
                    openingBalance += (t.debit - t.credit);
                  }
                }
                
                // إضافة سطر الرصيد الافتتاحي
                runningBalance = openingBalance;
                finalLines.add(StatementLineEntity(
                  date: effectiveStartDate, // يظهر بتاريخ بداية الفترة
                  refNumber: '-',
                  description: 'رصيد سابق / افتتاحي',
                  debit: openingBalance > 0 ? openingBalance : 0, // للعرض فقط
                  credit: openingBalance < 0 ? openingBalance.abs() : 0, // للعرض فقط
                  balance: runningBalance,
                  sourceType: StatementSourceType.invoice, // نوع وهمي
                  sourceObject: null,
                ));
              }

              // ب) إضافة عمليات الفترة المختارة
              for (var t in allTransactions) {
                // نأخذ فقط العمليات داخل الفترة (تشمل يوم البداية والنهاية)
                // isAtSameMomentAs ضروري لشمولية الحدود
                bool isAfterOrSameStart = t.date.isAfter(effectiveStartDate) || t.date.isAtSameMomentAs(effectiveStartDate);
                bool isBeforeOrSameEnd = t.date.isBefore(effectiveEndDate) || t.date.isAtSameMomentAs(effectiveEndDate);

                // إذا لم يكن هناك تاريخ بداية محدد، نعرض الكل ولا نحسب رصيد سابق
                if (startDate == null) isAfterOrSameStart = true;

                if (isAfterOrSameStart && isBeforeOrSameEnd) {
                  runningBalance += (t.debit - t.credit);
                  
                  // تحديث الرصيد التراكمي للسطر
                  final updatedLine = StatementLineEntity(
                    date: t.source.date,
                    refNumber: t.source.refNumber,
                    description: t.source.description,
                    debit: t.source.debit,
                    credit: t.source.credit,
                    balance: runningBalance, // الرصيد بعد الحركة
                    sourceType: t.source.sourceType,
                    sourceObject: t.source.sourceObject,
                  );
                  
                  finalLines.add(updatedLine);
                }
              }

              return Right(finalLines);
            },
          );
        },
      );
    } catch (e) {
      return const Left(ServerFailure('خطأ في معالجة كشف الحساب'));
    }
  }

  String _getInvoiceDesc(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales: return 'فاتورة مبيعات';
      case InvoiceType.salesReturn: return 'مرتجع مبيعات';
      case InvoiceType.purchase: return 'فاتورة مشتريات';
      case InvoiceType.purchaseReturn: return 'مرتجع مشتريات';
    }
  }
}

// كلاس مساعد داخلي فقط
class _TempTransaction {
  final DateTime date;
  final double debit;
  final double credit;
  final StatementLineEntity source;

  _TempTransaction({required this.date, required this.debit, required this.credit, required this.source});
}