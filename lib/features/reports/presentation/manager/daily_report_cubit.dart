// [phase_3] correction
// file: lib/features/reports/presentation/manager/daily_report_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/pdf_report_service.dart';
// تأكد أن المسارات صحيحة
import '../../../sales/domain/entities/invoice_item_entity.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../clients_suppliers/domain/repositories/client_supplier_repository.dart';
// هذا الاستيراد ضروري لكي يتعرف على InvoiceEntity و InvoiceItemEntity
import '../../../inventory/domain/entities/product_entity.dart';
import '../../domain/entities/daily_report_row.dart';

// حالات الكيوبت
abstract class DailyReportState {}
class DailyReportInitial extends DailyReportState {}
class DailyReportLoading extends DailyReportState {}
class DailyReportDataLoaded extends DailyReportState {
  final List<ProductEntity> allProducts;
  DailyReportDataLoaded(this.allProducts);
}

@injectable
class DailyReportCubit extends Cubit<DailyReportState> {
  final SalesRepository _salesRepo;
  final InventoryRepository _inventoryRepo;
  final ClientSupplierRepository _clientRepo;
  final PdfReportService _pdfService;

  DailyReportCubit(
    this._salesRepo,
    this._inventoryRepo,
    this._clientRepo,
    this._pdfService,
  ) : super(DailyReportInitial());

  // تحميل المنتجات عند فتح الصفحة
  Future<void> loadInitialData() async {
    emit(DailyReportLoading());
    // تم إصلاح هذا الخطأ بإضافة الدالة في المستودع في الخطوة 1
    final productsResult = await _inventoryRepo.getProducts(); 
    productsResult.fold(
      (l) => emit(DailyReportInitial()),
      (products) => emit(DailyReportDataLoaded(products)),
    );
  }

  // توليد التقرير
  Future<void> generateReport({
    required DateTime date,
    required List<ProductEntity> selectedProducts,
  }) async {
    // 1. جلب فواتير اليوم المحدد
    final invoicesResult = await _salesRepo.getInvoices(limit: 10000); // جلب كل الفواتير
    
    await invoicesResult.fold((l) async {}, (allInvoices) async {
      final dailyInvoices = allInvoices.where((inv) => 
        inv.date.year == date.year && 
        inv.date.month == date.month && 
        inv.date.day == date.day
      ).toList();

      List<DailyReportRow> rows = [];

      for (var invoice in dailyInvoices) {
        // تم إصلاح هذا الخطأ بإضافة الدالة في المستودع في الخطوة 2
        final clientResult = await _clientRepo.getClientById(invoice.clientId);
        final clientBalance = clientResult.fold((l) => 0.0, (c) => c.balance);
        
        Map<String, dynamic> prodValues = {};
        for (var prod in selectedProducts) {
          
          // هنا كان الخطأ: InvoiceItemEntity
          // نستخدم firstWhere مع orElse لضمان عدم حدوث خطأ إذا لم يوجد المنتج
          final item = invoice.items.firstWhere(
            (i) => i.productId == prod.id, 
            // تأكد أن InvoiceItemEntity موجودة ولها كونستركتور صحيح
            orElse: () => const InvoiceItemEntity(
              productId: '', 
              productName: '', 
              quantity: 0, 
              price: 0, 
              total: 0, unitId: '', unitName: '', conversionFactor: 0
            ),
          );
          
          if (item.quantity > 0) {
            prodValues[prod.name] = item.quantity; 
          }
        }

        double paid = 0.0; 
        double prevBalance = clientBalance - (invoice.totalAmount - paid);

        rows.add(DailyReportRow(
          invoiceNumber: '#${invoice.invoiceNumber}',
          clientName: invoice.clientName,
          previousBalance: prevBalance,
          paidAmount: paid,
          remainingBalance: clientBalance,
          productValues: prodValues,
        ));
      }

      await _pdfService.generateDailyReportPdf(
        title: 'تقرير المبيعات اليومي (الأصناف)',
        date: DateFormat('yyyy-MM-dd').format(date),
        productHeaders: selectedProducts.map((e) => e.name).toList(),
        rows: rows,
      );
    });
  }
}