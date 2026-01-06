import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/usecases/delete_invoice_usecase.dart';
import 'invoices_list_state.dart';

@injectable
class InvoicesListCubit extends Cubit<InvoicesListState> {
  final GetInvoicesUseCase _getInvoicesUseCase;
  final DeleteInvoiceUseCase _deleteInvoiceUseCase;

  InvoicesListCubit(this._getInvoicesUseCase, this._deleteInvoiceUseCase)
    : super(const InvoicesListState());

  /// تحميل الفواتير
  Future<void> loadInvoices() async {
    if (isClosed) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getInvoicesUseCase();

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (invoices) {
        emit(state.copyWith(isLoading: false, allInvoices: invoices));
        // تطبيق الفلاتر الحالية (النوع + البحث إن وجد)
        _applyFilter();
      },
    );
  }

  /// [NEW] البحث في الفواتير
  void searchInvoices(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilter();
  }

  /// تغيير التبويب
  void changeFilter(InvoiceType type) {
    emit(state.copyWith(filterType: type));
    _applyFilter();
  }

  /// [CORE] دالة الفلترة المركزية
  void _applyFilter() {
    final query = state.searchQuery.trim().toLowerCase();
    final normalizedQuery = _normalizeNumbers(
      query,
    ); // التعامل مع الأرقام العربية

    final filtered = state.allInvoices.where((inv) {
      // 1. شرط النوع (التبويب)
      final matchesType = inv.type == state.filterType;

      // 2. شرط البحث (الاسم أو الرقم)
      if (query.isEmpty) return matchesType;

      final matchesName = inv.clientName.toLowerCase().contains(query);
      final matchesNumber = inv.invoiceNumber.contains(normalizedQuery);

      return matchesType && (matchesName || matchesNumber);
    }).toList();

    emit(state.copyWith(filteredInvoices: filtered));
  }

  /// تحويل الأرقام العربية إلى إنجليزية للبحث
  String _normalizeNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  /// حذف فاتورة
  Future<void> deleteInvoice(InvoiceEntity invoice) async {
    if (isClosed) return;

    final previousList = List<InvoiceEntity>.from(state.allInvoices);

    // التحديث التفاؤلي للقائمة الرئيسية
    final updatedAllList = state.allInvoices
        .where((i) => i.id != invoice.id)
        .toList();

    // تحديث الحالة بالقائمة الجديدة ثم إعادة تطبيق الفلتر
    emit(state.copyWith(allInvoices: updatedAllList));
    _applyFilter();

    final result = await _deleteInvoiceUseCase(invoice);

    if (isClosed) return;

    result.fold(
      (failure) {
        // تراجع عند الخطأ
        emit(
          state.copyWith(
            errorMessage: failure.message,
            allInvoices: previousList,
          ),
        );
        _applyFilter();
      },
      (_) {
        // نجاح، يفضل إعادة التحميل لضمان تزامن المخزون
        loadInvoices();
      },
    );
  }
}
