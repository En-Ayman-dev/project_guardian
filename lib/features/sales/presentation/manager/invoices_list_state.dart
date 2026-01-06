import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_entity.dart';

part 'invoices_list_state.freezed.dart';

@freezed
abstract class InvoicesListState with _$InvoicesListState {
  const factory InvoicesListState({
    @Default(false) bool isLoading,
    @Default([]) List<InvoiceEntity> allInvoices, // المصدر الرئيسي
    @Default([]) List<InvoiceEntity> filteredInvoices, // المعروض
    @Default(InvoiceType.sales) InvoiceType filterType, // التبويب
    @Default('') String searchQuery, // [NEW] نص البحث
    String? errorMessage,
  }) = _InvoicesListState;
}