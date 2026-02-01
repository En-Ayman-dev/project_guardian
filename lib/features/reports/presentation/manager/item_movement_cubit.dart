// // [phase_3] fix_autocomplete
// // file: lib/features/reports/presentation/manager/item_movement_cubit.dart

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import '../../../sales/domain/entities/invoice_entity.dart';
// import '../../../sales/domain/repositories/sales_repository.dart';
// import '../../../inventory/domain/entities/product_entity.dart';
// import '../../../inventory/domain/repositories/inventory_repository.dart';
// import '../../../clients_suppliers/domain/repositories/client_supplier_repository.dart';
// import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
// import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
// import '../../domain/entities/item_movement_entity.dart';
// import 'item_movement_state.dart';

// @injectable
// class ItemMovementCubit extends Cubit<ItemMovementState> {
//   final SalesRepository _salesRepo;
//   final InventoryRepository _inventoryRepo;
//   final ClientSupplierRepository _clientRepo;

//   // قوائم الكاش للبحث السريع
//   List<ProductEntity> _allProducts = [];
//   List<ClientSupplierEntity> _allClients = [];
//   List<ClientSupplierEntity> _allSuppliers = [];

//   ItemMovementCubit(
//     this._salesRepo,
//     this._inventoryRepo,
//     this._clientRepo,
//   ) : super(ItemMovementInitial());

//   // تحميل كل البيانات المطلوبة للبحث عند فتح الصفحة
//   Future<void> loadInitialData() async {
//     // 1. المنتجات
//     final prodResult = await _inventoryRepo.getProducts();
//     prodResult.fold((l) {}, (r) => _allProducts = r);

//     // 2. العملاء
//     final clientResult =
//         await _clientRepo.getClientsSuppliers(ClientType.client);
//     clientResult.fold((l) {}, (r) => _allClients = r);

//     // 3. الموردين
//     final supplierResult =
//         await _clientRepo.getClientsSuppliers(ClientType.supplier);
//     supplierResult.fold((l) {}, (r) => _allSuppliers = r);
//   }

//   // بحث الأصناف
//   List<ProductEntity> searchProducts(String query) {
//     if (query.isEmpty) return _allProducts; // إرجاع الكل إذا كان الحقل فارغاً
//     final lowerQuery = query.toLowerCase();
//     return _allProducts
//         .where((p) =>
//             p.name.toLowerCase().contains(lowerQuery) ||
//             (p.barcode?.contains(lowerQuery) ?? false))
//         .toList();
//   }

//   // بحث الشركاء (عميل أو مورد)
//   List<ClientSupplierEntity> searchPartners(String query,
//       {bool isSupplier = false}) {
//     final sourceList = isSupplier ? _allSuppliers : _allClients;
//     if (query.isEmpty) return sourceList;
//     final lowerQuery = query.toLowerCase();
//     return sourceList
//         .where((c) =>
//             c.name.toLowerCase().contains(lowerQuery) ||
//             c.phone.contains(lowerQuery))
//         .toList();
//   }

//   // توليد التقرير
//   Future<void> generateReportForProduct(
//     ProductEntity product, {
//     ClientSupplierEntity? selectedPartner,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     emit(ItemMovementLoading());

//     final result = await _salesRepo.getInvoices(limit: 5000);

//     result.fold(
//       (failure) => emit(ItemMovementError(failure.message)),
//       (invoices) {
//         List<ItemMovementEntity> movements = [];
//         double totalQty = 0;
//         double totalVal = 0;

//         // ترتيب زمني
//         invoices.sort((a, b) => a.date.compareTo(b.date));

//         for (var invoice in invoices) {
//           // 1. فلترة التاريخ
//           if (startDate != null) {
//             final invDate = DateTime(
//                 invoice.date.year, invoice.date.month, invoice.date.day);
//             final start =
//                 DateTime(startDate.year, startDate.month, startDate.day);
//             if (invDate.isBefore(start)) continue;
//           }
//           if (endDate != null) {
//             final invDate = DateTime(
//                 invoice.date.year, invoice.date.month, invoice.date.day);
//             final end = DateTime(endDate.year, endDate.month, endDate.day);
//             if (invDate.isAfter(end)) continue;
//           }

//           // 2. فلترة الشريك (بالـ ID)
//           if (selectedPartner != null) {
//             if (invoice.clientId != selectedPartner.id) continue;
//           }

//           // 3. البحث عن المنتج داخل الفاتورة
//           final matchingItems =
//               invoice.items.where((item) => item.productId == product.id);

//           for (var item in matchingItems) {
//             final typeStr = _getTransactionTypeString(invoice.type);

//             movements.add(ItemMovementEntity(
//               date: invoice.date,
//               invoiceNumber: invoice.invoiceNumber,
//               transactionType: typeStr,
//               partnerName: invoice.clientName,
//               quantity: item.quantity.toDouble(),
//               unitName: item.unitName,
//               price: item.price,
//               total: item.total,
//             ));

//             totalVal += item.total;
//             totalQty += item.quantity;
//           }
//         }

//         emit(ItemMovementLoaded(
//           movements: movements,
//           selectedProduct: product,
//           totalQuantity: totalQty,
//           totalValue: totalVal,
//         ));
//       },
//     );
//   }

//   String _getTransactionTypeString(InvoiceType type) {
//     switch (type) {
//       case InvoiceType.sales:
//         return "مبيعات";
//       case InvoiceType.purchase:
//         return "مشتريات";
//       case InvoiceType.salesReturn:
//         return "مرتجع مبيعات";
//       case InvoiceType.purchaseReturn:
//         return "مرتجع مشتريات";
//     }
//   }
// }
// [phase_2] final_version
// file: lib/features/reports/presentation/manager/item_movement_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../sales/domain/entities/invoice_entity.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../clients_suppliers/domain/repositories/client_supplier_repository.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../../domain/entities/item_movement_entity.dart';
import 'item_movement_state.dart';

@injectable
class ItemMovementCubit extends Cubit<ItemMovementState> {
  final SalesRepository _salesRepo;
  final InventoryRepository _inventoryRepo;
  final ClientSupplierRepository _clientRepo;

  List<ProductEntity> _allProducts = [];
  List<ClientSupplierEntity> _allClients = [];
  List<ClientSupplierEntity> _allSuppliers = [];

  ItemMovementCubit(
    this._salesRepo,
    this._inventoryRepo,
    this._clientRepo,
  ) : super(ItemMovementInitial());

  // تحميل البيانات الأولية
  Future<void> loadInitialData() async {
    final prodResult = await _inventoryRepo.getProducts();
    prodResult.fold((l) {}, (r) => _allProducts = r);

    final clientResult = await _clientRepo.getClientsSuppliers(ClientType.client);
    clientResult.fold((l) {}, (r) => _allClients = r);

    final supplierResult = await _clientRepo.getClientsSuppliers(ClientType.supplier);
    supplierResult.fold((l) {}, (r) => _allSuppliers = r);
  }

  // بحث المنتجات
  List<ProductEntity> searchProducts(String query) {
    if (query.isEmpty) return _allProducts;
    final lowerQuery = query.toLowerCase();
    return _allProducts.where((p) =>
        p.name.toLowerCase().contains(lowerQuery) ||
        (p.barcode?.contains(lowerQuery) ?? false)).toList();
  }

  // بحث الشركاء
  List<ClientSupplierEntity> searchPartners(String query, {bool isSupplier = false}) {
    final sourceList = isSupplier ? _allSuppliers : _allClients;
    if (query.isEmpty) return sourceList;
    final lowerQuery = query.toLowerCase();
    return sourceList.where((c) =>
        c.name.toLowerCase().contains(lowerQuery) ||
        c.phone.contains(lowerQuery)).toList();
  }

  // 1. تقرير حركة صنف (التبويب الأول)
  Future<void> generateReportForProduct(
    ProductEntity product, {
    ClientSupplierEntity? selectedPartner,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(ItemMovementLoading());

    final result = await _salesRepo.getInvoices(limit: 5000);

    result.fold(
      (failure) => emit(ItemMovementError(failure.message)),
      (invoices) {
        List<ItemMovementEntity> movements = [];
        double totalQty = 0;
        double totalVal = 0;

        invoices.sort((a, b) => a.date.compareTo(b.date));

        for (var invoice in invoices) {
          if (startDate != null) {
            final invDate = DateTime(invoice.date.year, invoice.date.month, invoice.date.day);
            final start = DateTime(startDate.year, startDate.month, startDate.day);
            if (invDate.isBefore(start)) continue;
          }
          if (endDate != null) {
            final invDate = DateTime(invoice.date.year, invoice.date.month, invoice.date.day);
            final end = DateTime(endDate.year, endDate.month, endDate.day);
            if (invDate.isAfter(end)) continue;
          }
          if (selectedPartner != null) {
            if (invoice.clientId != selectedPartner.id) continue;
          }

          final matchingItems = invoice.items.where((item) => item.productId == product.id);

          for (var item in matchingItems) {
            final typeStr = _getTransactionTypeString(invoice.type);
            movements.add(ItemMovementEntity(
              date: invoice.date,
              invoiceNumber: invoice.invoiceNumber,
              transactionType: typeStr,
              partnerName: invoice.clientName,
              quantity: item.quantity.toDouble(),
              unitName: item.unitName,
              price: item.price,
              total: item.total,
            ));
            totalVal += item.total;
            totalQty += item.quantity;
          }
        }
        emit(ItemMovementLoaded(
          movements: movements,
          selectedProduct: product,
          totalQuantity: totalQty,
          totalValue: totalVal,
        ));
      },
    );
  }

  // 2. [NEW] تقرير جرد المخزون (التبويب الثاني)
  Future<void> generateInventoryReport({
    required List<ProductEntity> products,
    ClientSupplierEntity? partnerFilter,
  }) async {
    if (products.isEmpty) {
      emit(ItemMovementError("يرجى اختيار صنف واحد على الأقل"));
      return;
    }
    emit(ItemMovementLoading());

    final result = await _salesRepo.getInvoices(limit: 10000);

    result.fold(
      (l) => emit(ItemMovementError(l.message)),
      (allInvoices) {
        List<StockReportItem> reportItems = [];

        for (var product in products) {
          double totalIn = 0;
          double totalOut = 0;
          
          // إضافة الرصيد المخزني الحالي كبداية (أو يمكن حسابه من الصفر)
          totalIn += product.stock; 

          for (var invoice in allInvoices) {
            if (partnerFilter != null && invoice.clientId != partnerFilter.id) continue;

            final items = invoice.items.where((i) => i.productId == product.id);
            for (var item in items) {
              switch (invoice.type) {
                case InvoiceType.sales:
                  totalOut += item.quantity;
                  break;
                case InvoiceType.purchase:
                  totalIn += item.quantity;
                  break;
                case InvoiceType.salesReturn:
                  totalIn += item.quantity; // المرتجع يعود للمخزون
                  break;
                case InvoiceType.purchaseReturn:
                  totalOut += item.quantity; // يخرج من المخزون
                  break;
              }
            }
          }

          reportItems.add(StockReportItem(
            productName: product.name,
            totalQty: totalIn,
            soldQty: totalOut,
            remainingQty: totalIn - totalOut,
          ));
        }
        emit(InventoryStockLoaded(reportItems));
      },
    );
  }

  String _getTransactionTypeString(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales: return "مبيعات";
      case InvoiceType.purchase: return "مشتريات";
      case InvoiceType.salesReturn: return "مرتجع مبيعات";
      case InvoiceType.purchaseReturn: return "مرتجع مشتريات";
    }
  }
}