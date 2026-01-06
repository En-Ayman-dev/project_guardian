import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';

abstract class SalesRepository {
  // جلب كل الفواتير
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices();
  
  // [NEW] البحث عن فاتورة برقمها (للمرتجعات)
  Future<Either<Failure, InvoiceEntity>> getInvoiceByNumber(String invoiceNumber);
  
  // إضافة فاتورة جديدة
  Future<Either<Failure, void>> addInvoice(InvoiceEntity invoice);

  // حذف فاتورة
  Future<Either<Failure, void>> deleteInvoice(InvoiceEntity invoice);

  // تعديل فاتورة
  Future<Either<Failure, void>> updateInvoice(InvoiceEntity invoice);
}