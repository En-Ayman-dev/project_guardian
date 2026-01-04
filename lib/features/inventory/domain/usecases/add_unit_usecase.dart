import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/unit_entity.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class AddUnitUseCase {
  final InventoryRepository _repository;

  AddUnitUseCase(this._repository);

  Future<Either<Failure, void>> call(UnitEntity unit) {
    return _repository.addUnit(unit);
  }
}