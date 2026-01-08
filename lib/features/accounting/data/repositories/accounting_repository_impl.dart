import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../datasources/accounting_remote_data_source.dart';

@LazySingleton(as: AccountingRepository)
class AccountingRepositoryImpl implements AccountingRepository {
  final AccountingRemoteDataSource _remoteDataSource;

  AccountingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> addVoucher(VoucherEntity voucher) async {
    try {
      await _remoteDataSource.addVoucherWithTransaction(voucher);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VoucherEntity>>> getVouchers() async {
    try {
      final vouchers = await _remoteDataSource.getVouchers();
      return Right(vouchers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // [NEW] تنفيذ الحذف
  @override
  Future<Either<Failure, Unit>> deleteVoucher(String voucherId) async {
    try {
      await _remoteDataSource.deleteVoucher(voucherId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // [NEW] تنفيذ التعديل
  @override
  Future<Either<Failure, Unit>> updateVoucher(VoucherEntity voucher) async {
    try {
      await _remoteDataSource.updateVoucher(voucher);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}