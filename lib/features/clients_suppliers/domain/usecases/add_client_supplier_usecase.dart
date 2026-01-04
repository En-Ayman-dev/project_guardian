import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/client_supplier_entity.dart';
import '../repositories/client_supplier_repository.dart';

@lazySingleton
class AddClientSupplierUseCase {
  final ClientSupplierRepository _repository;

  AddClientSupplierUseCase(this._repository);

  Future<Either<Failure, void>> call(ClientSupplierEntity entity) {
    return _repository.addClientSupplier(entity);
  }
}