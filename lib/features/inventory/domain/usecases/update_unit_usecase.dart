import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/unit_entity.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class UpdateUnitUseCase {
  final InventoryRepository _repository;

  UpdateUnitUseCase(this._repository);

  Future<Either<Failure, void>> call(UnitEntity unit) {
    return _repository.updateUnit(unit);
  }
}