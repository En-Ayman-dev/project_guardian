// [phase_2] creation
// file: lib/features/accounting/domain/repositories/voucher_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/voucher_entity.dart';

abstract class VoucherRepository {
  // جلب السندات الخاصة بعميل/مورد معين
  Future<Either<Failure, List<VoucherEntity>>> getVouchersByClient(String clientId);
  
  // دوال أخرى قد تحتاجها مستقبلاً
  Future<Either<Failure, void>> addVoucher(VoucherEntity voucher);
}