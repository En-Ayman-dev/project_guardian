import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/sales_repository.dart';

@lazySingleton
class SearchInvoicesUseCase {
  final SalesRepository _repository;

  SearchInvoicesUseCase(this._repository);

  Future<Either<Failure, List<InvoiceEntity>>> call(String query) {
    return _repository.searchInvoices(query);
  }
}