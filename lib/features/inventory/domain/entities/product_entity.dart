import 'package:equatable/equatable.dart';
import 'product_unit_entity.dart'; // استيراد الكيان الجديد

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  
  // التصنيف يبقى كما هو
  final String categoryId;
  final String categoryName;
  
  // --- التغيير الجذري هنا ---
  // بدلاً من وحدة واحدة، لدينا قائمة وحدات
  // أول عنصر في القائمة يعتبر هو "الوحدة الأساسية" (Base Unit)
  final List<ProductUnitEntity> units; 
  
  // المخزون يتم تخزينه دائماً بـ "الوحدة الأساسية"
  final double stock;         
  final int minStockAlert;    
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    required this.categoryName,
    required this.units, // القائمة الجديدة
    this.stock = 0.0,
    this.minStockAlert = 5,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, name, description, categoryId, units, stock, minStockAlert
  ];

  // دالة مساعدة للحصول على الوحدة الأساسية بسهولة
  ProductUnitEntity get baseUnit => units.firstWhere((u) => u.conversionFactor == 1.0, orElse: () => units.first);
}