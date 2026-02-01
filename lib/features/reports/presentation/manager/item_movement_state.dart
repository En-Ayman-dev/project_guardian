// // [phase_2] creation
// // file: lib/features/reports/presentation/manager/item_movement_state.dart

// import '../../domain/entities/item_movement_entity.dart';
// import '../../../inventory/domain/entities/product_entity.dart';

// abstract class ItemMovementState {}

// class ItemMovementInitial extends ItemMovementState {}

// class ItemMovementLoading extends ItemMovementState {}

// class ItemMovementLoaded extends ItemMovementState {
//   final List<ItemMovementEntity> movements;
//   final ProductEntity selectedProduct;
//   final double totalQuantity; // مجموع الكميات (رصيد الصنف)
//   final double totalValue;    // مجموع القيمة

//   ItemMovementLoaded({
//     required this.movements,
//     required this.selectedProduct,
//     this.totalQuantity = 0,
//     this.totalValue = 0,
//   });
// }

// class ItemMovementError extends ItemMovementState {
//   final String message;
//   ItemMovementError(this.message);
// }

// [phase_2] final_version
// file: lib/features/reports/presentation/manager/item_movement_state.dart

import '../../domain/entities/item_movement_entity.dart';
import '../../../inventory/domain/entities/product_entity.dart';

// [NEW] كيان لسطر تقرير المخزون
class StockReportItem {
  final String productName;
  final double totalQty;     // الكمية الكلية (وارد)
  final double soldQty;      // الكمية المباعة (صادر)
  final double remainingQty; // المتبقي

  StockReportItem({
    required this.productName,
    required this.totalQty,
    required this.soldQty,
    required this.remainingQty,
  });
}

abstract class ItemMovementState {}

class ItemMovementInitial extends ItemMovementState {}

class ItemMovementLoading extends ItemMovementState {}

// حالة تقرير الحركة (التبويب الأول)
class ItemMovementLoaded extends ItemMovementState {
  final List<ItemMovementEntity> movements;
  final ProductEntity selectedProduct;
  final double totalQuantity;
  final double totalValue;

  ItemMovementLoaded({
    required this.movements,
    required this.selectedProduct,
    this.totalQuantity = 0,
    this.totalValue = 0,
  });
}

// [NEW] حالة تقرير المخزون (التبويب الثاني)
class InventoryStockLoaded extends ItemMovementState {
  final List<StockReportItem> stockItems;
  InventoryStockLoaded(this.stockItems);
}

class ItemMovementError extends ItemMovementState {
  final String message;
  ItemMovementError(this.message);
}