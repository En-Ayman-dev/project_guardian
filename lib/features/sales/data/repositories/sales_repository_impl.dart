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
      return Left(ServerFailure(e.toString()));
    }
  }

  // [NEW] تنفيذ البحث
  @override
  Future<Either<Failure, InvoiceEntity>> getInvoiceByNumber(String invoiceNumber) async {
    try {
      final model = await _remoteDataSource.getInvoiceByNumber(invoiceNumber);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addInvoice(InvoiceEntity invoice) async {
    try {
      await _remoteDataSource.addInvoice(InvoiceModel.fromEntity(invoice));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e is ServerFailure ? e.message : e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteInvoice(InvoiceEntity invoice) async {
    try {
      await _remoteDataSource.deleteInvoice(InvoiceModel.fromEntity(invoice));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e is ServerFailure ? e.message : e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateInvoice(InvoiceEntity invoice) async {
    try {
      await _remoteDataSource.updateInvoice(InvoiceModel.fromEntity(invoice));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e is ServerFailure ? e.message : e.toString()));
    }
  }
}