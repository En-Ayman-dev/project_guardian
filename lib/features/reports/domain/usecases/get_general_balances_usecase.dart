// [phase_2] creation
// file: lib/features/reports/domain/usecases/get_general_balances_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../../../clients_suppliers/domain/repositories/client_supplier_repository.dart';

@lazySingleton
class GetGeneralBalancesUseCase {
  final ClientSupplierRepository repository;

  GetGeneralBalancesUseCase(this.repository);

  Future<Either<Failure, List<ClientSupplierEntity>>> call() async {
    // جلب العملاء
    final clientsResult = await repository.getClientsSuppliers(ClientType.client);
    // جلب الموردين
    final suppliersResult = await repository.getClientsSuppliers(ClientType.supplier);

    return clientsResult.fold(
      (failure) => Left(failure),
      (clients) {
        return suppliersResult.fold(
          (failure) => Left(failure),
          (suppliers) {
            // دمج القائمتين
            final all = [...clients, ...suppliers];
            // ترتيب حسب الرصيد (الأعلى مديونية أولاً) لإبراز الأهم
            all.sort((a, b) => b.balance.abs().compareTo(a.balance.abs()));
            return Right(all);
          },
        );
      },
    );
  }
}