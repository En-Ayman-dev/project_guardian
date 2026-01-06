import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/sales_repository.dart';

@lazySingleton
class GetInvoiceByNumberUseCase {
  final SalesRepository _repository;

  GetInvoiceByNumberUseCase(this._repository);

  Future<Either<Failure, InvoiceEntity>> call(String invoiceNumber) async {
    return await _repository.getInvoiceByNumber(invoiceNumber);
  }
}