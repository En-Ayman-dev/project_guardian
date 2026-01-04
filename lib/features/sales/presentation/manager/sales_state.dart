import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../../../../features/clients_suppliers/domain/entities/client_supplier_entity.dart';

part 'sales_state.freezed.dart';

@freezed
abstract class SalesState with _$SalesState {
  const factory SalesState({
    @Default(false) bool isLoading,
    @Default([]) List<ProductEntity> products, // المنتجات المتاحة للبيع
    @Default([]) List<ClientSupplierEntity> clients, // قائمة العملاء
    @Default([]) List<InvoiceItemEntity> cartItems, // سلة المشتريات
    @Default(0.0) double subTotal,
    @Default(0.0) double tax,
    @Default(0.0) double totalAmount,
    String? errorMessage,
    @Default(false) bool isSuccess, // لنجاح عملية حفظ الفاتورة
  }) = _SalesState;
}