import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';

abstract class SalesRepository {
  // [NEW] البحث الشامل في السيرفر (Server-side Search)
  Future<Either<Failure, List<InvoiceEntity>>> searchInvoices(String query);

  // البحث عن فاتورة برقمها (للمرتجعات - دقيق)
  Future<Either<Failure, InvoiceEntity>> getInvoiceByNumber(
    String invoiceNumber,
  );

  Future<Either<Failure, void>> addInvoice(InvoiceEntity invoice);
  Future<Either<Failure, void>> deleteInvoice(InvoiceEntity invoice);
  Future<Either<Failure, void>> updateInvoice(InvoiceEntity invoice);
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices({
    required int limit,
    InvoiceEntity? startAfter,
    InvoiceType? type, // [NEW]
  });
}
