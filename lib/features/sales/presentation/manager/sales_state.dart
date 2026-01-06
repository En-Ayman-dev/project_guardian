import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_entity.dart'; 
import '../../domain/entities/invoice_item_entity.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';

part 'sales_state.freezed.dart';

@freezed
abstract class SalesState with _$SalesState {
  const factory SalesState({
    @Default(false) bool isLoading,
    
    // البيانات المرجعية
    @Default([]) List<ProductEntity> products,
    @Default([]) List<ClientSupplierEntity> clients,
    
    // بيانات العملية الحالية
    @Default(InvoiceType.sales) InvoiceType invoiceType,
    @Default(InvoicePaymentType.cash) InvoicePaymentType paymentType,
    @Default([]) List<InvoiceItemEntity> cartItems,
    
    // الحسابات المالية
    @Default(0.0) double subTotal,
    @Default(0.0) double discount,
    @Default(0.0) double tax,
    @Default(0.0) double totalAmount,
    @Default(0.0) double paidAmount,
    
    // حالة التحكم
    String? errorMessage,
    @Default(false) bool isSuccess,
    
    // الفاتورة التي تم حفظها للتو (لغرض الطباعة)
    InvoiceEntity? lastSavedInvoice, 

    // [NEW] الفاتورة الأصلية (المرجعية) لعمليات المرتجع
    // تستخدم للتحقق من الكميات وتحديد نوع الخصم المالي
    InvoiceEntity? originalInvoice,
  }) = _SalesState;
}