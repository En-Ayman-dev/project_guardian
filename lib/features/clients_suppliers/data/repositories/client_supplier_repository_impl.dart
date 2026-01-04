import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/client_supplier_entity.dart';
import '../../domain/entities/enums/client_type.dart';
import '../../domain/repositories/client_supplier_repository.dart';
import '../datasources/client_supplier_remote_data_source.dart';
import '../models/client_supplier_model.dart';

@LazySingleton(as: ClientSupplierRepository)
class ClientSupplierRepositoryImpl implements ClientSupplierRepository {
  final ClientSupplierRemoteDataSource _remoteDataSource;

  ClientSupplierRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ClientSupplierEntity>>> getClientsSuppliers(ClientType type) async {
    try {
      final models = await _remoteDataSource.getClientsSuppliers(type);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch data'));
    }
  }

  @override
  Future<Either<Failure, void>> addClientSupplier(ClientSupplierEntity entity) async {
    try {
      final model = ClientSupplierModel.fromEntity(entity);
      await _remoteDataSource.addClientSupplier(model);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerFailure('Failed to add record'));
    }
  }

  @override
  Future<Either<Failure, void>> updateClientSupplier(ClientSupplierEntity entity) async {
    try {
      final model = ClientSupplierModel.fromEntity(entity);
      await _remoteDataSource.updateClientSupplier(model);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerFailure('Failed to update record'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClientSupplier(String id) async {
    try {
      await _remoteDataSource.deleteClientSupplier(id);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerFailure('Failed to delete record'));
    }
  }
  
  @override
  Future<Either<Failure, List<ClientSupplierEntity>>> searchClientsSuppliers(String query) async {
    // يمكن تنفيذ البحث محلياً أو عبر Firestore queries معقدة
    // للتبسيط الآن، سنقوم بإرجاع قائمة فارغة حتى ننفذ المنطق لاحقاً
    return const Right([]); 
  }
}