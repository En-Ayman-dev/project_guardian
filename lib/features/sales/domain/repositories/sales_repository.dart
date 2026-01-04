import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';

abstract class SalesRepository {
  // جلب كل الفواتير
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices();
  
  // إضافة فاتورة جديدة
  Future<Either<Failure, void>> addInvoice(InvoiceEntity invoice);

  // حذف فاتورة (مع عكس تأثير المخزون)
  Future<Either<Failure, void>> deleteInvoice(InvoiceEntity invoice);

  // تعديل فاتورة (نسخة مبسطة: تقوم عادة بحذف القديمة وإنشاء جديدة)
  Future<Either<Failure, void>> updateInvoice(InvoiceEntity invoice);
}