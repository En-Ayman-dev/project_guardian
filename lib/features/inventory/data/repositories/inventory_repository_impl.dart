import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/unit_model.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource _remoteDataSource;

  InventoryRepositoryImpl(this._remoteDataSource);

  // --- Categories ---
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch categories'));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(CategoryEntity category) async {
    try {
      await _remoteDataSource.addCategory(CategoryModel.fromEntity(category));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to add category'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _remoteDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to delete category'));
    }
  }

  // --- Units ---
  @override
  Future<Either<Failure, List<UnitEntity>>> getUnits() async {
    try {
      final models = await _remoteDataSource.getUnits();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch units'));
    }
  }

  @override
  Future<Either<Failure, void>> addUnit(UnitEntity unit) async {
    try {
      await _remoteDataSource.addUnit(UnitModel.fromEntity(unit));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to add unit'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUnit(String id) async {
    try {
      await _remoteDataSource.deleteUnit(id);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to delete unit'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      await _remoteDataSource.updateCategory(
        CategoryModel.fromEntity(category),
      );
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to update category'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUnit(UnitEntity unit) async {
    try {
      await _remoteDataSource.updateUnit(UnitModel.fromEntity(unit));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to update unit'));
    }
  }
}
