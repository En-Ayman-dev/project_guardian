// [phase_2] modification
// file: lib/features/accounting/data/repositories/voucher_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../models/voucher_model.dart'; 

@LazySingleton(as: VoucherRepository)
class VoucherRepositoryImpl implements VoucherRepository {
  final FirebaseFirestore _firestore;

  VoucherRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, List<VoucherEntity>>> getVouchersByClient(String clientId) async {
    try {
      final snapshot = await _firestore
          .collection('vouchers')
          .where('clientSupplierId', isEqualTo: clientId)
          .get();

      // [UPDATED] استخدام الموديل الجاهز للتحويل المباشر
      final vouchers = snapshot.docs.map((doc) {
        return VoucherModel.fromJson(doc.data(), doc.id);
      }).toList();

      return Right(vouchers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addVoucher(VoucherEntity voucher) async {
    // سيتم تنفيذ إضافة السند لاحقاً عند الحاجة
    return const Right(null);
  }
}