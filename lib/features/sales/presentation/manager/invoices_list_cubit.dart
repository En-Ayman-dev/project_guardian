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

  InvoicesListCubit(
    this._getInvoicesUseCase,
    this._deleteInvoiceUseCase,
  ) : super(const InvoicesListState());

  /// تحميل الفواتير عند فتح الصفحة
  Future<void> loadInvoices() async {
    if (isClosed) return;
    
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getInvoicesUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false, 
        errorMessage: failure.message
      )),
      (invoices) {
        // نقوم بفلترة البيانات فوراً بناءً على الفلتر الافتراضي
        final filtered = invoices.where((inv) => inv.type == state.filterType).toList();
        
        emit(state.copyWith(
          isLoading: false,
          allInvoices: invoices,
          filteredInvoices: filtered,
        ));
      },
    );
  }

  /// تغيير نوع الفلتر (مبيعات / مشتريات) محلياً
  void changeFilter(InvoiceType type) {
    if (isClosed) return;

    final filtered = state.allInvoices.where((inv) => inv.type == type).toList();
    
    emit(state.copyWith(
      filterType: type,
      filteredInvoices: filtered,
    ));
  }

  /// حذف فاتورة
  Future<void> deleteInvoice(InvoiceEntity invoice) async {
    if (isClosed) return;

    // 1. التحديث التفاؤلي (Optimistic Update) لسرعة الواجهة
    // نحتفظ بنسخة احتياطية في حال الفشل
    final previousList = List<InvoiceEntity>.from(state.allInvoices);
    final updatedList = state.allInvoices.where((i) => i.id != invoice.id).toList();
    
    // تحديث الواجهة فوراً
    _updateFilteredList(updatedList, state.filterType);

    // 2. تنفيذ الحذف في الخلفية
    final result = await _deleteInvoiceUseCase(invoice);

    if (isClosed) return;

    result.fold(
      (failure) {
        // في حال الفشل، نعيد القائمة القديمة ونعرض خطأ
        emit(state.copyWith(errorMessage: failure.message));
        _updateFilteredList(previousList, state.filterType);
      },
      (_) {
        // نجاح الحذف، لا داعي لعمل شيء لأننا حدثنا الواجهة مسبقاً
        // لكن لضمان تطابق البيانات (Stock Reversion)، يفضل إعادة التحميل
        loadInvoices(); 
      },
    );
  }

  void _updateFilteredList(List<InvoiceEntity> all, InvoiceType type) {
    final filtered = all.where((inv) => inv.type == type).toList();
    emit(state.copyWith(
      allInvoices: all,
      filteredInvoices: filtered,
      filterType: type
    ));
  }
}