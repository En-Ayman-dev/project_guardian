import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../inventory/domain/entities/product_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../domain/usecases/add_invoice_usecase.dart';
import '../../domain/usecases/update_invoice_usecase.dart';
import '../../../inventory/domain/usecases/get_products_usecase.dart';
import '../../../clients_suppliers/domain/usecases/get_clients_suppliers_usecase.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import 'sales_state.dart';

@injectable
class SalesCubit extends Cubit<SalesState> {
  final AddInvoiceUseCase _addInvoiceUseCase;
  final UpdateInvoiceUseCase _updateInvoiceUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final GetClientsSuppliersUseCase _getClientsUseCase;

  InvoiceEntity? _editingInvoice;

  SalesCubit(
    this._addInvoiceUseCase,
    this._updateInvoiceUseCase,
    this._getProductsUseCase,
    this._getClientsUseCase,
  ) : super(const SalesState());

  /// تهيئة الصفحة (وضع جديد أو تعديل)
  Future<void> initialize({
    InvoiceType type = InvoiceType.sales,
    InvoiceEntity? invoiceToEdit,
  }) async {
    if (isClosed) return;

    _editingInvoice = invoiceToEdit;

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
        lastSavedInvoice: null, // تصفير آخر فاتورة محفوظة

        invoiceType: invoiceToEdit?.type ?? type,
        // إذا كنا نعدل، نأخذ نوع الدفع من الفاتورة القديمة
        paymentType: invoiceToEdit?.paymentType ?? InvoicePaymentType.cash,

        cartItems: invoiceToEdit?.items ?? [],
        subTotal: invoiceToEdit?.subTotal ?? 0,
        totalAmount: invoiceToEdit?.totalAmount ?? 0,
        paidAmount: invoiceToEdit?.paidAmount ?? 0,
        discount: invoiceToEdit?.discount ?? 0,
      ),
    );

    await _loadDependencies();
  }

  /// تغيير نوع الفاتورة (مبيعات/مشتريات/...)
  Future<void> changeInvoiceType(InvoiceType type) async {
    if (_editingInvoice != null) return;
    if (state.invoiceType == type) return;
    await initialize(type: type);
  }

  /// [NEW] تغيير طريقة الدفع (نقد/أجل)
  void setPaymentType(InvoicePaymentType type) {
    if (isClosed) return;

    // منطق ذكي: إذا نقد، المدفوع = الإجمالي. إذا أجل، المدفوع = 0 مبدئياً
    double newPaidAmount = state.paidAmount;
    if (type == InvoicePaymentType.cash) {
      newPaidAmount = state.totalAmount;
    } else {
      newPaidAmount = 0;
    }

    emit(state.copyWith(paymentType: type, paidAmount: newPaidAmount));
  }

  void addItem(InvoiceItemEntity newItem) {
    if (isClosed) return;
    final currentCart = List<InvoiceItemEntity>.from(state.cartItems);
    final existingIndex = currentCart.indexWhere(
      (item) => item.productId == newItem.productId,
    );

    if (existingIndex != -1) {
      final existingItem = currentCart[existingIndex];
      final updatedQuantity = existingItem.quantity + newItem.quantity;
      currentCart[existingIndex] = existingItem.copyWith(
        quantity: updatedQuantity,
        total: updatedQuantity * existingItem.price,
      );
    } else {
      currentCart.add(newItem);
    }
    _calculateTotals(cart: currentCart);
  }

  void updateItemQuantity(int index, int newQuantity) {
    if (isClosed) return;
    if (newQuantity <= 0) {
      removeItem(index);
      return;
    }
    final currentCart = List<InvoiceItemEntity>.from(state.cartItems);
    final item = currentCart[index];
    currentCart[index] = item.copyWith(
      quantity: newQuantity,
      total: newQuantity * item.price,
    );
    _calculateTotals(cart: currentCart);
  }

  void removeItem(int index) {
    if (isClosed) return;
    final currentCart = List<InvoiceItemEntity>.from(state.cartItems)
      ..removeAt(index);
    _calculateTotals(cart: currentCart);
  }

  void setDiscount(double discount) {
    _calculateTotals(discountOverride: discount);
  }

  void setPaidAmount(double amount) {
    if (isClosed) return;
    emit(state.copyWith(paidAmount: amount));
  }

  /// المحرك الحسابي
  void _calculateTotals({
    List<InvoiceItemEntity>? cart,
    double? discountOverride,
  }) {
    if (isClosed) return;
    final currentCart = cart ?? state.cartItems;
    final discount = discountOverride ?? state.discount;

    double subTotal = 0;
    for (var item in currentCart) {
      subTotal += item.total;
    }

    double tax = 0; // الضريبة ملغاة
    double total = (subTotal - discount);
    if (total < 0) total = 0;

    // تحديث المدفوع تلقائياً إذا كان الدفع نقداً
    double paid = state.paidAmount;
    if (state.paymentType == InvoicePaymentType.cash) {
      paid = total;
    }

    emit(
      state.copyWith(
        cartItems: currentCart,
        subTotal: subTotal,
        discount: discount,
        tax: tax,
        totalAmount: total,
        paidAmount: paid,
      ),
    );
  }

  Future<void> submitInvoice({
    required String clientId,
    required String clientName,
    String? note,
  }) async {
    if (state.cartItems.isEmpty || isClosed) return;

    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    const status = InvoiceStatus.posted;

    // في حالة الإضافة، الـ invoiceNumber سيتم توليده في الـ DataSource
    // لذا نمرر قيمة مؤقتة هنا وسيتم استبدالها هناك.
    final invoiceId = _editingInvoice?.id ?? const Uuid().v4();
    final invoiceNumber = _editingInvoice?.invoiceNumber ?? "TEMP";

    final invoice = InvoiceEntity(
      id: invoiceId,
      invoiceNumber: invoiceNumber,
      type: state.invoiceType,
      status: status,
      paymentType: state.paymentType, // [MAPPED]
      clientId: clientId,
      clientName: clientName,
      date: DateTime.now(),
      dueDate: state.paymentType == InvoicePaymentType.credit
          ? DateTime.now().add(const Duration(days: 30))
          : null,
      items: state.cartItems,
      subTotal: state.subTotal,
      discount: state.discount,
      tax: state.tax,
      totalAmount: state.totalAmount,
      paidAmount: state.paidAmount,
      note: note,
    );

    final result = _editingInvoice == null
        ? await _addInvoiceUseCase(invoice)
        : await _updateInvoiceUseCase(invoice);

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        // عند النجاح، نحفظ الفاتورة في الحالة ولا نصفر البيانات فوراً
        // لكي نعرض زر الطباعة
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            lastSavedInvoice: invoice, // حفظ الفاتورة للطباعة
          ),
        );

        // ملاحظة: لا نصفر cartItems هنا، بل نترك للمستخدم خيار "فاتورة جديدة"
        // أو الطباعة ثم الخروج.
        _editingInvoice = null;
      },
    );
  }

  /// دالة لبدء فاتورة جديدة بعد النجاح
  void resetAfterSuccess() {
    initialize(type: state.invoiceType);
  }

  // --- Helpers ---

  Future<void> initializeForReturn(InvoiceEntity originalInvoice) async {
    if (isClosed) return;
    _editingInvoice = null;

    InvoiceType returnType;
    if (originalInvoice.type == InvoiceType.sales) {
      returnType = InvoiceType.salesReturn;
    } else if (originalInvoice.type == InvoiceType.purchase) {
      returnType = InvoiceType.purchaseReturn;
    } else {
      returnType = InvoiceType.salesReturn;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
        lastSavedInvoice: null,

        invoiceType: returnType,
        // في المرتجع، غالباً الدفع يكون نقد (إرجاع مال) أو خصم من الدين
        // سنفترضه نقد مبدئياً
        paymentType: InvoicePaymentType.cash,

        cartItems: originalInvoice.items.map((e) => e.copyWith()).toList(),
        subTotal: originalInvoice.subTotal,
        totalAmount: originalInvoice.subTotal - originalInvoice.discount,
        discount: originalInvoice.discount,
        paidAmount:
            originalInvoice.subTotal - originalInvoice.discount, // لأنه نقد
        tax: 0,
      ),
    );

    await _loadDependencies();
  }

  Future<void> _loadDependencies() async {
    final targetClientType = _mapInvoiceTypeToClientType(state.invoiceType);
    final results = await Future.wait([
      _getProductsUseCase(),
      _getClientsUseCase(targetClientType),
    ]);

    if (isClosed) return;

    final productsResult = results[0] as dynamic;
    final clientsResult = results[1] as dynamic;

    final products = productsResult.getOrElse(() => <ProductEntity>[]);
    final clients = clientsResult.getOrElse(() => <ClientSupplierEntity>[]);

    emit(
      state.copyWith(isLoading: false, products: products, clients: clients),
    );
  }

  ClientType _mapInvoiceTypeToClientType(InvoiceType invoiceType) {
    switch (invoiceType) {
      case InvoiceType.sales:
      case InvoiceType.salesReturn:
        return ClientType.client;
      case InvoiceType.purchase:
      case InvoiceType.purchaseReturn:
        return ClientType.supplier;
    }
  }
}
