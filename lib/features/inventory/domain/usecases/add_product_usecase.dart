import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class AddProductUseCase {
  final ProductRepository _repository;

  AddProductUseCase(this._repository);

  Future<Either<Failure, void>> call(ProductEntity product) {
    return _repository.addProduct(product);
  }
}