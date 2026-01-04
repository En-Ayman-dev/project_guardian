import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_entity.dart'; // ضروري لـ InvoiceType
import '../../domain/entities/invoice_item_entity.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';

part 'sales_state.freezed.dart';

@freezed
abstract class SalesState with _$SalesState {
  const factory SalesState({
    @Default(false) bool isLoading,
    
    // البيانات المرجعية (Reference Data)
    @Default([]) List<ProductEntity> products,
    @Default([]) List<ClientSupplierEntity> clients,
    
    // بيانات العملية الحالية (Transaction Data)
    @Default(InvoiceType.sales) InvoiceType invoiceType, // نوع الفاتورة الحالي
    @Default([]) List<InvoiceItemEntity> cartItems,
    
    // الحسابات المالية (Financials)
    @Default(0.0) double subTotal,
    @Default(0.0) double discount,   // الخصم
    @Default(0.0) double tax,
    @Default(0.0) double totalAmount,
    @Default(0.0) double paidAmount, // المبلغ المدفوع (للآجل/النقدي)
    
    // حالة التحكم (Control State)
    String? errorMessage,
    @Default(false) bool isSuccess,
  }) = _SalesState;
}