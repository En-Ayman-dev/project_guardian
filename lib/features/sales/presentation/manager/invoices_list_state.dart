import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_entity.dart';

part 'invoices_list_state.freezed.dart';

@freezed
abstract class InvoicesListState with _$InvoicesListState {
  const factory InvoicesListState({
    @Default(false) bool isLoading,
    @Default(false) bool isMoreLoading, // [NEW] تحميل المزيد
    @Default(false) bool hasReachedMax, // [NEW] هل وصلنا للنهاية؟
    @Default(false) bool isSearching,   // [NEW] هل نحن في وضع البحث؟
    
    @Default([]) List<InvoiceEntity> allInvoices, // القائمة المتراكمة (Pagination)
    @Default([]) List<InvoiceEntity> searchResults, // نتائج البحث (Search)
    @Default([]) List<InvoiceEntity> filteredInvoices, // المعروض في الواجهة
    
    @Default(InvoiceType.sales) InvoiceType filterType,
    @Default('') String searchQuery,
    String? errorMessage,
  }) = _InvoicesListState;
}