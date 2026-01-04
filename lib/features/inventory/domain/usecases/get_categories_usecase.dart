import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class GetCategoriesUseCase {
  final InventoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _repository.getCategories();
  }
}