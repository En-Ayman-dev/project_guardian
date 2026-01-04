import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/client_supplier_entity.dart';
import '../entities/enums/client_type.dart';
import '../repositories/client_supplier_repository.dart';

@lazySingleton
class GetClientsSuppliersUseCase {
  final ClientSupplierRepository _repository;

  GetClientsSuppliersUseCase(this._repository);

  Future<Either<Failure, List<ClientSupplierEntity>>> call(ClientType type) {
    return _repository.getClientsSuppliers(type);
  }
}