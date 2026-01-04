import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/unit_entity.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class GetUnitsUseCase {
  final InventoryRepository _repository;

  GetUnitsUseCase(this._repository);

  Future<Either<Failure, List<UnitEntity>>> call() {
    return _repository.getUnits();
  }
}