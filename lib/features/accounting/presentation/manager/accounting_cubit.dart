import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../../../sales/domain/usecases/get_invoice_by_number_usecase.dart';
import 'accounting_state.dart';

@injectable
class AccountingCubit extends Cubit<AccountingState> {
  final AccountingRepository _repository;
  final GetInvoiceByNumberUseCase _getInvoiceByNumber;

  AccountingCubit(this._repository, this._getInvoiceByNumber)
    : super(const AccountingState.initial());

  /// إنشاء سند جديد
  Future<void> createVoucher(VoucherEntity voucher) async {
    emit(const AccountingState.loading());
    final result = await _repository.addVoucher(voucher);
    result.fold(
      (failure) => emit(AccountingState.error(failure.message)),
      (_) => emit(const AccountingState.success()),
    );
  }

  /// جلب سجل السندات
  Future<void> fetchVouchers() async {
    emit(const AccountingState.loading());
    final result = await _repository.getVouchers();
    result.fold(
      (failure) => emit(AccountingState.error(failure.message)),
      (vouchers) => emit(AccountingState.loaded(vouchers)),
    );
  }

  /// [NEW] تعديل سند موجود
  Future<void> updateVoucher(VoucherEntity voucher) async {
    emit(const AccountingState.loading());
    final result = await _repository.updateVoucher(voucher);
    result.fold((failure) => emit(AccountingState.error(failure.message)), (_) {
      // بعد التعديل الناجح، نعيد تحميل القائمة لتحديث البيانات
      emit(const AccountingState.success());
      fetchVouchers();
    });
  }

  /// [NEW] حذف سند
  Future<void> deleteVoucher(String voucherId) async {
    emit(const AccountingState.loading());
    final result = await _repository.deleteVoucher(voucherId);
    result.fold((failure) => emit(AccountingState.error(failure.message)), (_) {
      // بعد الحذف الناجح، نعيد تحميل القائمة
      emit(const AccountingState.success());
      fetchVouchers();
    });
  }

  /// البحث عن الفاتورة وجلب المبلغ المتبقي
  Future<void> lookupInvoice(String invoiceNumber, VoucherType type) async {
    if (type == VoucherType.payment) {
      emit(
        const AccountingState.invoiceLookupError(
          'البحث التلقائي غير مدعوم لفواتير المشتريات حالياً',
        ),
      );
      return;
    }

    if (invoiceNumber.isEmpty) return;

    emit(const AccountingState.invoiceLookupLoading());

    final result = await _getInvoiceByNumber(invoiceNumber);

    result.fold(
      (failure) =>
          emit(const AccountingState.invoiceLookupError('الفاتورة غير موجودة')),
      (invoice) {
        // حساب المبلغ المتبقي
        final double total = invoice.totalAmount;
        final double paid = invoice.paidAmount;
        final double remaining = total - paid;

        if (remaining <= 0) {
          emit(
            const AccountingState.invoiceLookupError(
              'هذه الفاتورة مدفوعة بالكامل',
            ),
          );
        } else {
          emit(
            AccountingState.invoiceLookupSuccess(
              remaining,
              invoice.invoiceNumber,
            ),
          );
        }
      },
    );
  }
}
