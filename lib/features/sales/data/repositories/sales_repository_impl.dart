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
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices({
    required int limit,
    InvoiceEntity? startAfter,
    InvoiceType? type, // [NEW]
  }) async {
    try {
      final startAfterModel = startAfter != null
          ? InvoiceModel.fromEntity(startAfter)
          : null;

      // [NEW] تحويل الـ Enum إلى String ليناسب قاعدة البيانات
      // تأكد أن الاسم يطابق ما هو مخزن في فيربيس (مثلاً: "sales", "purchase")
      final typeString = type?.name;

      final models = await _remoteDataSource.getInvoices(
        limit: limit,
        startAfter: startAfterModel,
        invoiceType: typeString, // [NEW]
      );

      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // [NEW] تنفيذ البحث
  @override
  Future<Either<Failure, List<InvoiceEntity>>> searchInvoices(
    String query,
  ) async {
    try {
      final models = await _remoteDataSource.searchInvoices(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvoiceEntity>> getInvoiceByNumber(
    String invoiceNumber,
  ) async {
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
