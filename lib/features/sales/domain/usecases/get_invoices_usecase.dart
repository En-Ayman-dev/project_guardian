import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/sales_repository.dart';

@lazySingleton
class GetInvoicesUseCase {
  final SalesRepository _repository;

  GetInvoicesUseCase(this._repository);

  Future<Either<Failure, List<InvoiceEntity>>> call() {
    return _repository.getInvoices();
  }
}