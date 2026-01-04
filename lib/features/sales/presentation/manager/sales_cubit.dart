import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../domain/usecases/add_invoice_usecase.dart';
import '../../../inventory/domain/usecases/get_products_usecase.dart';
import '../../../clients_suppliers/domain/usecases/get_clients_suppliers_usecase.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import 'sales_state.dart';

@injectable
class SalesCubit extends Cubit<SalesState> {
  final AddInvoiceUseCase _addInvoiceUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final GetClientsSuppliersUseCase _getClientsUseCase;

  SalesCubit(
    this._addInvoiceUseCase,
    this._getProductsUseCase,
    this._getClientsUseCase,
  ) : super(const SalesState());

  // تحميل البيانات الأولية (المنتجات والعملاء)
  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    // جلب المنتجات
    final productsResult = await _getProductsUseCase();
    // جلب العملاء فقط
    final clientsResult = await _getClientsUseCase(ClientType.client);

    final products = productsResult.getOrElse(() => []);
    final clients = clientsResult.getOrElse(() => []);

    emit(state.copyWith(
      isLoading: false,
      products: products,
      clients: clients,
    ));
  }

  // إضافة منتج للسلة
  void addToCart(InvoiceItemEntity item) {
    // التحقق مما إذا كان المنتج موجوداً مسبقاً لزيادة الكمية (اختياري، حالياً سنضيف سطراً جديداً)
    final newCart = List<InvoiceItemEntity>.from(state.cartItems)..add(item);
    _calculateTotals(newCart);
  }

  // حذف منتج من السلة
  void removeFromCart(int index) {
    final newCart = List<InvoiceItemEntity>.from(state.cartItems)..removeAt(index);
    _calculateTotals(newCart);
  }

  // حساب الإجماليات
  void _calculateTotals(List<InvoiceItemEntity> cart) {
    double subTotal = 0;
    for (var item in cart) {
      subTotal += item.total;
    }
    // ضريبة مبسطة 15% (يمكن تغييرها لاحقاً)
    double tax = 0.0; // subTotal * 0.15; 
    double total = subTotal + tax;

    emit(state.copyWith(
      cartItems: cart,
      subTotal: subTotal,
      tax: tax,
      totalAmount: total,
    ));
  }

  // حفظ الفاتورة
  Future<void> submitInvoice(String clientId, String clientName) async {
    if (state.cartItems.isEmpty) return;

    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    final invoice = InvoiceEntity(
      id: const Uuid().v4(), // Generate ID locally (Firestore will overwrite or use doc ID)
      invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString().substring(7), // Simple number
      clientId: clientId,
      clientName: clientName,
      date: DateTime.now(),
      items: state.cartItems,
      subTotal: state.subTotal,
      tax: state.tax,
      totalAmount: state.totalAmount,
    );

    final result = await _addInvoiceUseCase(invoice);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true, cartItems: [], subTotal: 0, totalAmount: 0)), // تصفير السلة بعد النجاح
    );
  }
}