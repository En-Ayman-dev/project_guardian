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
    // ✅ مهم: إذا تم استدعاء الدالة بعد الإغلاق لأي سبب، اخرج فورًا
    if (isClosed) return;

    // (اختياري لكنه مفيد): تجنب emit متكرر لنفس حالة التحميل
    if (!state.isLoading || state.errorMessage != null) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }

    try {
      // تنفيذ الطلبات بشكل متوازي لزيادة السرعة
      final results = await Future.wait([
        _salesRepository.getInvoices(limit: 10),
        _productRepository.getProducts(),
        _clientRepository.getClientsSuppliers(ClientType.client),
      ]);

      // ✅ أهم سطر: قد تكون الصفحة انغلقت أثناء await
      if (isClosed) return;

      // 1. معالجة المبيعات
      double totalSales = 0;
      int invoiceCount = 0;
      results[0].fold(
        (l) {}, // Ignore error for stats
        (invoices) {
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

      // ✅ قبل emit الأخير أيضًا (احتياط إضافي)
      if (isClosed) return;

      emit(state.copyWith(
        isLoading: false,
        totalSales: totalSales,
        lowStockCount: lowStock,
        clientsCount: clients,
        invoiceCount: invoiceCount,
        errorMessage: null,
      ));
    } catch (e) {
      // ✅ لا ترمي الاستثناء لو Cubit أغلق أثناء التنفيذ
      if (isClosed) return;

      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
