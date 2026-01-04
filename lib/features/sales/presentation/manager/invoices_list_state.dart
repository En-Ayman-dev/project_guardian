import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_entity.dart';

part 'invoices_list_state.freezed.dart';

@freezed
abstract class InvoicesListState with _$InvoicesListState {
  const factory InvoicesListState({
    @Default(false) bool isLoading,
    @Default([]) List<InvoiceEntity> allInvoices, // كل الفواتير المحملة
    @Default([]) List<InvoiceEntity> filteredInvoices, // الفواتير المعروضة حالياً
    @Default(InvoiceType.sales) InvoiceType filterType, // نوع الفلتر الحالي
    String? errorMessage,
  }) = _InvoicesListState;
}