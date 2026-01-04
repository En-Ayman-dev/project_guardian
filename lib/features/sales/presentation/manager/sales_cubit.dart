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
        isSuccess: false, // [FIX] تصفير حالة النجاح لمنع تكرار السناك بار

        invoiceType: invoiceToEdit?.type ?? type,
        cartItems: invoiceToEdit?.items ?? [],
        subTotal: invoiceToEdit?.subTotal ?? 0,
        totalAmount: invoiceToEdit?.totalAmount ?? 0,
        paidAmount: invoiceToEdit?.paidAmount ?? 0,
        discount: invoiceToEdit?.discount ?? 0,
      ),
    );

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

  Future<void> changeInvoiceType(InvoiceType type) async {
    if (_editingInvoice != null) return;
    if (state.invoiceType == type) return;
    await initialize(type: type);
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

    // [FIX] إلغاء الضريبة تماماً
    double tax = 0;

    // الإجمالي = المجموع الفرعي - الخصم (بدون ضريبة)
    double total = (subTotal - discount);
    if (total < 0) total = 0;

    emit(
      state.copyWith(
        cartItems: currentCart,
        subTotal: subTotal,
        discount: discount,
        tax: tax,
        totalAmount: total,
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

    final invoiceId = _editingInvoice?.id ?? const Uuid().v4();
    final invoiceNumber =
        _editingInvoice?.invoiceNumber ??
        DateTime.now().millisecondsSinceEpoch.toString().substring(5);

    final invoice = InvoiceEntity(
      id: invoiceId,
      invoiceNumber: invoiceNumber,
      type: state.invoiceType,
      status: status,
      clientId: clientId,
      clientName: clientName,
      date: DateTime.now(),
      dueDate: state.paidAmount < state.totalAmount
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
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            // تصفير القيم بعد النجاح
            cartItems: [],
            subTotal: 0,
            totalAmount: 0,
            paidAmount: 0,
            discount: 0,
          ),
        );
        _editingInvoice = null;
      },
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

  Future<void> initializeForReturn(InvoiceEntity originalInvoice) async {
    if (isClosed) return;

    InvoiceType returnType;
    switch (originalInvoice.type) {
      case InvoiceType.sales:
        returnType = InvoiceType.salesReturn;
        break;
      case InvoiceType.purchase:
        returnType = InvoiceType.purchaseReturn;
        break;
      default:
        returnType = InvoiceType.salesReturn;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false, // [FIX] تصفير حالة النجاح
        invoiceType: returnType,
        cartItems: originalInvoice.items.map((e) => e.copyWith()).toList(),
        subTotal: originalInvoice.subTotal,

        // إعادة حساب الإجمالي بناءً على القيم الأصلية لكن بدون ضريبة لو أردنا،
        // أو نعتمد القيم كما هي إذا كانت الفاتورة القديمة بها ضريبة،
        // لكن بما أنك لغيت الضريبة، يفضل تصفيرها هنا أيضاً للمستقبل:
        tax: 0,
        // نقوم بتعديل التوتال ليكون بدون ضريبة
        totalAmount: originalInvoice.subTotal - originalInvoice.discount,

        discount: originalInvoice.discount,
        paidAmount: 0,
      ),
    );

    final targetClientType = _mapInvoiceTypeToClientType(returnType);

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
}
