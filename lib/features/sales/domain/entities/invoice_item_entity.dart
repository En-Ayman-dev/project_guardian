import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  final String productId;
  final String productName;
  
  // الوحدة التي تم البيع بها (حبة، كرتون، إلخ)
  final String unitId;
  final String unitName;
  final double conversionFactor; // معامل التحويل لحساب الخصم من المخزون
  
  final int quantity;
  final double price; // سعر البيع للوحدة الواحدة
  final double total; // quantity * price

  const InvoiceItemEntity({
    required this.productId,
    required this.productName,
    required this.unitId,
    required this.unitName,
    required this.conversionFactor,
    required this.quantity,
    required this.price,
    required this.total,
  });

  /// إنشاء نسخة معدلة من الكائن الحالي
  InvoiceItemEntity copyWith({
    String? productId,
    String? productName,
    String? unitId,
    String? unitName,
    double? conversionFactor,
    int? quantity,
    double? price,
    double? total,
  }) {
    return InvoiceItemEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitId: unitId ?? this.unitId,
      unitName: unitName ?? this.unitName,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
    productId, productName, unitId, unitName, conversionFactor, quantity, price, total
  ];
}