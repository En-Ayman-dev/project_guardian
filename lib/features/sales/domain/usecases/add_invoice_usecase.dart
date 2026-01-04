import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/sales_repository.dart';

@lazySingleton
class AddInvoiceUseCase {
  final SalesRepository _repository;

  AddInvoiceUseCase(this._repository);

  Future<Either<Failure, void>> call(InvoiceEntity invoice) {
    return _repository.addInvoice(invoice);
  }
}