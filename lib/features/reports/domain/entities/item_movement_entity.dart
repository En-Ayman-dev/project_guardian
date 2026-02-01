// [phase_2] creation
// file: lib/features/reports/domain/entities/item_movement_entity.dart

class ItemMovementEntity {
  final DateTime date;
  final String invoiceNumber;
  final String transactionType; // مبيعات، مشتريات...
  final String partnerName;     // اسم العميل أو المورد
  final double quantity;        // الكمية (موجبة أو سالبة حسب النوع)
  final String unitName;
  final double price;
  final double total;

  const ItemMovementEntity({
    required this.date,
    required this.invoiceNumber,
    required this.transactionType,
    required this.partnerName,
    required this.quantity,
    required this.unitName,
    required this.price,
    required this.total,
  });
}