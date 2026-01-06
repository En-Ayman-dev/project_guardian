import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/sales_repository.dart';

@lazySingleton
class GetInvoicesUseCase {
  final SalesRepository _repository;

  GetInvoicesUseCase(this._repository);

  Future<Either<Failure, List<InvoiceEntity>>> call({
    required int limit,
    InvoiceEntity? startAfter,
    InvoiceType? type, // [NEW]
  }) {
    return _repository.getInvoices(
      limit: limit,
      startAfter: startAfter,
      type: type, // [NEW]
    );
  }
}
