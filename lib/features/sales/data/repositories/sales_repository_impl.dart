import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_data_source.dart';
import '../models/invoice_model.dart';

@LazySingleton(as: SalesRepository)
class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource _remoteDataSource;

  SalesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices() async {
    try {
      final models = await _remoteDataSource.getInvoices();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch invoices'));
    }
  }

  @override
  Future<Either<Failure, void>> addInvoice(InvoiceEntity invoice) async {
    try {
      await _remoteDataSource.addInvoice(InvoiceModel.fromEntity(invoice));
      return const Right(null);
    } catch (e) {
      // نمرر رسالة الخطأ القادمة من المصدر (قد تكون "Product not found" أو غيرها)
      return Left(ServerFailure(e is ServerFailure ? e.message : 'Failed to add invoice'));
    }
  }
}