import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class DeleteProductUseCase {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteProduct(id);
  }
}