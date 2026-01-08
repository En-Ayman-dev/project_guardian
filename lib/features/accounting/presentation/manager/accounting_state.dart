import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/voucher_entity.dart';

part 'accounting_state.freezed.dart';

@freezed
class AccountingState with _$AccountingState {
  const factory AccountingState.initial() = _Initial;
  const factory AccountingState.loading() = _Loading;
  const factory AccountingState.success() = _Success;
  const factory AccountingState.loaded(List<VoucherEntity> vouchers) = _Loaded;
  const factory AccountingState.error(String message) = _Error;

  // --- حالات البحث عن الفواتير الجديدة ---
  const factory AccountingState.invoiceLookupLoading() = _InvoiceLookupLoading;
  // نعيد المبلغ المتبقي ورقم الفاتورة للتأكيد
  const factory AccountingState.invoiceLookupSuccess(double remainingAmount, String invoiceNumber) = _InvoiceLookupSuccess;
  const factory AccountingState.invoiceLookupError(String message) = _InvoiceLookupError;
}