import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../inventory/domain/entities/product_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../domain/usecases/add_invoice_usecase.dart';
import '../../domain/usecases/get_invoice_by_number_usecase.dart';
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
  final GetInvoiceByNumberUseCase _getInvoiceByNumberUseCase;

  InvoiceEntity? _editingInvoice;

  SalesCubit(
    this._addInvoiceUseCase,
    this._updateInvoiceUseCase,
    this._getProductsUseCase,
    this._getClientsUseCase,
    this._getInvoiceByNumberUseCase,
  ) : super(const SalesState());

  /// تهيئة الصفحة (وضع جديد أو تعديل)
  Future<void> initialize({
    InvoiceType type = InvoiceType.sales,
    InvoiceEntity? invoiceToEdit,
  }) async {
    if (isClosed) return;

    _editingInvoice = invoiceToEdit;

    // [NEW] منطق استرجاع الفاتورة الأصلية عند التعديل
    InvoiceEntity? fetchedOriginalInvoice;

    // إذا كنا نعدل فاتورة، وهي من نوع مرتجع، ولديها رقم مرجعي
    if (invoiceToEdit != null &&
        invoiceToEdit.originalInvoiceNumber != null &&
        (invoiceToEdit.type == InvoiceType.salesReturn ||
            invoiceToEdit.type == InvoiceType.purchaseReturn)) {
      // نقوم بجلب الفاتورة الأصلية لتمكين التحقق من الكميات
      final result = await _getInvoiceByNumberUseCase(
        invoiceToEdit.originalInvoiceNumber!,
      );
      result.fold((failure) {
        // في حال فشل الجلب (مثلاً الفاتورة الأصلية حذفت)، يمكننا تركها null
        // أو تسجيل خطأ، لكن سنكمل التحميل لكي لا نعطل المستخدم
      }, (invoice) => fetchedOriginalInvoice = invoice);
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
        lastSavedInvoice: null,

        // [FIXED] تعبئة الفاتورة الأصلية إذا وجدت
        originalInvoice: fetchedOriginalInvoice,

        invoiceType: invoiceToEdit?.type ?? type,
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

  /// البحث عن فاتورة أصلية للمرتجع (عند الإنشاء الجديد)
  Future<void> searchForInvoice(String invoiceNumber) async {
    if (invoiceNumber.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getInvoiceByNumberUseCase(invoiceNumber);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "الفاتورة رقم $invoiceNumber غير موجودة",
        ),
      ),
      (originalInvoice) => initializeForReturn(originalInvoice),
    );
  }

  Future<void> changeInvoiceType(InvoiceType type) async {
    if (_editingInvoice != null) return;
    if (state.invoiceType == type) return;
    await initialize(type: type);
  }

  void setPaymentType(InvoicePaymentType type) {
    if (isClosed) return;

    if (state.originalInvoice != null) return;

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

    // [VALIDATION] التحقق من المرتجعات
    if (state.originalInvoice != null) {
      final originalItem = state.originalInvoice!.items.firstWhere(
        (item) => item.productId == newItem.productId,
        orElse: () => newItem.copyWith(quantity: -1),
      );

      if (originalItem.quantity == -1) {
        emit(
          state.copyWith(
            errorMessage: "هذا المنتج غير موجود في الفاتورة الأصلية!",
          ),
        );
        return;
      }

      // حساب الكمية المتوقعة بعد الإضافة
      int finalQtyToCheck = newItem.quantity;
      final existingIndex = state.cartItems.indexWhere(
        (item) => item.productId == newItem.productId,
      );
      if (existingIndex != -1) {
        finalQtyToCheck += state.cartItems[existingIndex].quantity;
      }

      if (finalQtyToCheck > originalItem.quantity) {
        emit(
          state.copyWith(
            errorMessage:
                "لا يمكن إرجاع كمية ($finalQtyToCheck) أكبر من المباعة (${originalItem.quantity})!",
          ),
        );
        return;
      }
    }

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

    // [VALIDATION] التحقق عند تعديل الكمية
    if (state.originalInvoice != null) {
      final itemBeingUpdated = state.cartItems[index];
      final originalItem = state.originalInvoice!.items.firstWhere(
        (e) => e.productId == itemBeingUpdated.productId,
      );

      if (newQuantity > originalItem.quantity) {
        emit(
          state.copyWith(
            errorMessage:
                "الكمية تتجاوز الكمية الأصلية (${originalItem.quantity})",
          ),
        );
        return;
      }
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

    double tax = 0;
    double total = (subTotal - discount);
    if (total < 0) total = 0;

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
    final invoiceId = _editingInvoice?.id ?? const Uuid().v4();
    final invoiceNumber = _editingInvoice?.invoiceNumber ?? "TEMP";

    final invoice = InvoiceEntity(
      id: invoiceId,
      invoiceNumber: invoiceNumber,
      type: state.invoiceType,
      status: status,
      paymentType: state.paymentType,
      originalInvoiceNumber: state.originalInvoice?.invoiceNumber,
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
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            lastSavedInvoice: invoice,
          ),
        );
        _editingInvoice = null;
      },
    );
  }

  void resetAfterSuccess() {
    initialize(type: state.invoiceType);
  }

  Future<void> initializeForReturn(InvoiceEntity originalInvoice) async {
    if (isClosed) return;
    _editingInvoice = null;

    InvoiceType returnType;
    if (originalInvoice.type == InvoiceType.sales) {
      returnType = InvoiceType.salesReturn;
    } else if (originalInvoice.type == InvoiceType.purchase) {
      returnType = InvoiceType.purchaseReturn;
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "لا يمكن إنشاء مرتجع لهذه الفاتورة",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
        lastSavedInvoice: null,
        originalInvoice: originalInvoice,
        invoiceType: returnType,
        paymentType: originalInvoice.paymentType,
        cartItems: [],
        subTotal: 0,
        totalAmount: 0,
        discount: 0,
        paidAmount: 0,
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
