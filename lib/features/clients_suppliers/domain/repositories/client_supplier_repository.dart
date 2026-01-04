import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/client_supplier_entity.dart';
import '../entities/enums/client_type.dart';

abstract class ClientSupplierRepository {
  // جلب قائمة العملاء أو الموردين بناءً على النوع
  Future<Either<Failure, List<ClientSupplierEntity>>> getClientsSuppliers(ClientType type);
  
  // البحث
  Future<Either<Failure, List<ClientSupplierEntity>>> searchClientsSuppliers(String query);

  // إضافة
  Future<Either<Failure, void>> addClientSupplier(ClientSupplierEntity entity);

  // تعديل
  Future<Either<Failure, void>> updateClientSupplier(ClientSupplierEntity entity);

  // حذف
  Future<Either<Failure, void>> deleteClientSupplier(String id);
}