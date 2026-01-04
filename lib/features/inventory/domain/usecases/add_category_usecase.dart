import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class AddCategoryUseCase {
  final InventoryRepository _repository;

  AddCategoryUseCase(this._repository);

  Future<Either<Failure, void>> call(CategoryEntity category) {
    return _repository.addCategory(category);
  }
}