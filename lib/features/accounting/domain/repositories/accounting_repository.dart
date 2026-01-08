import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/voucher_entity.dart';

abstract class AccountingRepository {
  Future<Either<Failure, Unit>> addVoucher(VoucherEntity voucher);
  
  Future<Either<Failure, List<VoucherEntity>>> getVouchers();

  // [NEW] دالة حذف السند
  Future<Either<Failure, Unit>> deleteVoucher(String voucherId);

  // [NEW] دالة تعديل السند
  Future<Either<Failure, Unit>> updateVoucher(VoucherEntity voucher);
}