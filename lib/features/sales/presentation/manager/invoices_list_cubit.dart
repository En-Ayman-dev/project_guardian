import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/usecases/search_invoices_usecase.dart'; // [NEW]
import '../../domain/usecases/delete_invoice_usecase.dart';
import 'invoices_list_state.dart';

@injectable
class InvoicesListCubit extends Cubit<InvoicesListState> {
  final GetInvoicesUseCase _getInvoicesUseCase;
  final SearchInvoicesUseCase _searchInvoicesUseCase; // [NEW]
  final DeleteInvoiceUseCase _deleteInvoiceUseCase;

  static const int _pageSize = 10; // عدد العناصر في كل صفحة

  InvoicesListCubit(
    this._getInvoicesUseCase,
    this._searchInvoicesUseCase,
    this._deleteInvoiceUseCase,
  ) : super(const InvoicesListState());

  /// تحميل الفواتير (Pagination)
  Future<void> loadInvoices({bool refresh = false}) async {
    if (isClosed) return;
    if (state.isMoreLoading) return; // منع التكرار أثناء التحميل

    // إذا كان تحديث (سحب لأسفل)، نصفر كل شيء
    if (refresh) {
      emit(
        state.copyWith(
          isLoading: true,
          allInvoices: [],
          hasReachedMax: false,
          isSearching: false,
          searchQuery: '',
        ),
      );
    } else {
      // إذا لم يكن تحديثاً ووصلنا للنهاية، نتوقف
      if (state.hasReachedMax) return;
      emit(state.copyWith(isMoreLoading: true, errorMessage: null));
    }

    // تحديد نقطة البداية (StartAfter)
    InvoiceEntity? startAfter;
    if (!refresh && state.allInvoices.isNotEmpty) {
      startAfter = state.allInvoices.last;
    }

// في داخل loadInvoices، مرر النوع الحالي
final result = await _getInvoicesUseCase(
  limit: _pageSize, 
  startAfter: startAfter,
  type: state.filterType, // [NEW] نمرر نوع الفلتر الحالي للسيرفر
);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isMoreLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (newInvoices) {
        final isMax = newInvoices.length < _pageSize;
        final updatedList = refresh
            ? newInvoices
            : [...state.allInvoices, ...newInvoices];

        emit(
          state.copyWith(
            isLoading: false,
            isMoreLoading: false,
            hasReachedMax: isMax,
            allInvoices: updatedList,
            isSearching: false, // تأكيد الخروج من وضع البحث
          ),
        );
        _applyFilter(); // تحديث القائمة المعروضة
      },
    );
  }

  /// البحث في السيرفر
  Future<void> searchInvoices(String query) async {
    if (isClosed) return;
    final normalizedQuery = _normalizeNumbers(query.trim());

    if (normalizedQuery.isEmpty) {
      // إلغاء البحث والعودة للقائمة العادية
      emit(
        state.copyWith(isSearching: false, searchQuery: '', errorMessage: null),
      );
      _applyFilter();
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isSearching: true,
        searchQuery: normalizedQuery,
      ),
    );

    final result = await _searchInvoicesUseCase(normalizedQuery);

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (results) {
        emit(state.copyWith(isLoading: false, searchResults: results));
        _applyFilter();
      },
    );
  }

void changeFilter(InvoiceType type) {
  // 1. نحدث النوع في الحالة
  emit(state.copyWith(filterType: type));
  
  // 2. [IMPORTANT] نعيد تحميل البيانات من السيرفر بناءً على النوع الجديد
  loadInvoices(refresh: true); 
}

  /// دالة الفلترة المركزية
  void _applyFilter() {
    List<InvoiceEntity> sourceList;

    // تحديد مصدر البيانات (بحث أم قائمة عادية)
    if (state.isSearching) {
      sourceList = state.searchResults;
    } else {
      sourceList = state.allInvoices;
    }

    // تطبيق فلتر التبويب (Sales, Purchase, etc.)
    final filtered = sourceList
        .where((inv) => inv.type == state.filterType)
        .toList();

    emit(state.copyWith(filteredInvoices: filtered));
  }

  String _normalizeNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  Future<void> deleteInvoice(InvoiceEntity invoice) async {
    if (isClosed) return;

    // حذف محلي سريع
    final updatedAll = state.allInvoices
        .where((i) => i.id != invoice.id)
        .toList();
    final updatedSearch = state.searchResults
        .where((i) => i.id != invoice.id)
        .toList();

    emit(state.copyWith(allInvoices: updatedAll, searchResults: updatedSearch));
    _applyFilter();

    final result = await _deleteInvoiceUseCase(invoice);

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ), // يمكن إعادة التحميل هنا للتصحيح
      (_) {},
    );
  }
}
