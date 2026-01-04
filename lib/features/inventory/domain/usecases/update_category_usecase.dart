import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class UpdateCategoryUseCase {
  final InventoryRepository _repository;

  UpdateCategoryUseCase(this._repository);

  Future<Either<Failure, void>> call(CategoryEntity category) {
    return _repository.updateCategory(category);
  }
}