import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';

abstract class SalesRepository {
  // جلب كل الفواتير (يمكن إضافة Pagination لاحقاً)
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices();
  
  // إضافة فاتورة جديدة (هذه العملية ستكون معقدة لأنها تتضمن خصم المخزون أيضاً)
  Future<Either<Failure, void>> addInvoice(InvoiceEntity invoice);
}