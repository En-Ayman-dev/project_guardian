import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../inventory/domain/repositories/product_repository.dart';
import '../../../clients_suppliers/domain/repositories/client_supplier_repository.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final SalesRepository _salesRepository;
  final ProductRepository _productRepository;
  final ClientSupplierRepository _clientRepository;

  DashboardCubit(
    this._salesRepository,
    this._productRepository,
    this._clientRepository,
  ) : super(const DashboardState());

  Future<void> loadStats() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // تنفيذ الطلبات بشكل متوازي لزيادة السرعة
    final results = await Future.wait([
      _salesRepository.getInvoices(),
      _productRepository.getProducts(),
      _clientRepository.getClientsSuppliers(ClientType.client),
    ]);

    // 1. معالجة المبيعات
    double totalSales = 0;
    int invoiceCount = 0;
    results[0].fold(
      (l) {}, // Ignore error for stats
      (invoices) {
        // invoices هو List<InvoiceEntity> لكن Future.wait يرجعه كـ dynamic هنا لذا نحتاج casting إذا لزم الأمر
        // أو نعتمد على النوع الديناميكي
        final list = invoices as List;
        invoiceCount = list.length;
        for (var inv in list) {
          totalSales += inv.totalAmount;
        }
      },
    );

    // 2. معالجة المخزون المنخفض
    int lowStock = 0;
    results[1].fold(
      (l) {},
      (products) {
        final list = products as List;
        lowStock = list.where((p) => p.stock <= p.minStockAlert).length;
      },
    );

    // 3. معالجة العملاء
    int clients = 0;
    results[2].fold(
      (l) {},
      (c) {
        clients = (c as List).length;
      },
    );

    emit(state.copyWith(
      isLoading: false,
      totalSales: totalSales,
      lowStockCount: lowStock,
      clientsCount: clients,
      invoiceCount: invoiceCount,
    ));
  }
}