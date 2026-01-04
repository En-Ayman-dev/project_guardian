import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class DeleteUnitUseCase {
  final InventoryRepository _repository;

  DeleteUnitUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteUnit(id);
  }
}