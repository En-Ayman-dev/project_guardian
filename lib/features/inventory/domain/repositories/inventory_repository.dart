import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';
import '../entities/unit_entity.dart';

abstract class InventoryRepository {
  // --- Categories ---
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, void>> addCategory(CategoryEntity category);
  Future<Either<Failure, void>> deleteCategory(String id);
  Future<Either<Failure, void>> updateCategory(CategoryEntity category);

  // --- Units ---
  Future<Either<Failure, List<UnitEntity>>> getUnits();
  Future<Either<Failure, void>> addUnit(UnitEntity unit);
  Future<Either<Failure, void>> deleteUnit(String id);
  Future<Either<Failure, void>> updateUnit(UnitEntity unit);
  // أضف هذا السطر داخل الـ abstract class
Future<Either<Failure, List<ProductEntity>>> getProducts();
}