import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/voucher_entity.dart';

abstract class AccountingRemoteDataSource {
  Future<void> addVoucherWithTransaction(VoucherEntity voucher);
  Future<List<VoucherEntity>> getVouchers();
  // [NEW] دوال التعديل والحذف
  Future<void> deleteVoucher(String voucherId);
  Future<void> updateVoucher(VoucherEntity voucher);
}

@LazySingleton(as: AccountingRemoteDataSource)
class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  final FirebaseFirestore _firestore;

  AccountingRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> addVoucherWithTransaction(VoucherEntity voucher) async {
    final voucherRef = _firestore.collection('vouchers').doc(voucher.id);
    final clientRef = _firestore.collection('clients_suppliers').doc(voucher.clientSupplierId);

    final voucherData = {
      'id': voucher.id,
      'voucherNumber': voucher.voucherNumber,
      'type': voucher.type.name,
      'amount': voucher.amount,
      'date': Timestamp.fromDate(voucher.date),
      'clientSupplierId': voucher.clientSupplierId,
      'clientSupplierName': voucher.clientSupplierName,
      'linkedInvoiceId': voucher.linkedInvoiceId,
      'note': voucher.note,
    };

    return _firestore.runTransaction((transaction) async {
      final clientSnapshot = await transaction.get(clientRef);
      if (!clientSnapshot.exists) {
        throw Exception("Client/Supplier not found!");
      }

      transaction.set(voucherRef, voucherData);

      // تحديث الرصيد: الدفع ينقص المديونية دائماً
      transaction.update(clientRef, {
        'balance': FieldValue.increment(-voucher.amount),
      });
    });
  }

  @override
  Future<List<VoucherEntity>> getVouchers() async {
    final snapshot = await _firestore
        .collection('vouchers')
        .orderBy('date', descending: true) // الأحدث أولاً
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return VoucherEntity(
        id: data['id'],
        voucherNumber: data['voucherNumber'],
        type: VoucherType.values.firstWhere((e) => e.name == data['type']),
        amount: (data['amount'] as num).toDouble(),
        date: (data['date'] as Timestamp).toDate(),
        clientSupplierId: data['clientSupplierId'],
        clientSupplierName: data['clientSupplierName'],
        linkedInvoiceId: data['linkedInvoiceId'],
        note: data['note'] ?? '',
      );
    }).toList();
  }

  // [NEW] حذف السند مع تصحيح الرصيد المالي
  @override
  Future<void> deleteVoucher(String voucherId) async {
    final voucherRef = _firestore.collection('vouchers').doc(voucherId);

    return _firestore.runTransaction((transaction) async {
      final voucherSnapshot = await transaction.get(voucherRef);
      if (!voucherSnapshot.exists) {
        throw Exception("Voucher not found!");
      }

      final data = voucherSnapshot.data()!;
      final double amount = (data['amount'] as num).toDouble();
      final String clientId = data['clientSupplierId'];
      final clientRef = _firestore.collection('clients_suppliers').doc(clientId);

      // عكس العملية: إذا كان السند قد أنقص الرصيد، الحذف يجب أن يزيده (يعيد الدين كما كان)
      transaction.update(clientRef, {
        'balance': FieldValue.increment(amount),
      });

      transaction.delete(voucherRef);
    });
  }

  // [NEW] تعديل السند مع تسوية الفروقات المالية
  @override
  Future<void> updateVoucher(VoucherEntity voucher) async {
    final voucherRef = _firestore.collection('vouchers').doc(voucher.id);
    final clientRef = _firestore.collection('clients_suppliers').doc(voucher.clientSupplierId);

    return _firestore.runTransaction((transaction) async {
      final voucherSnapshot = await transaction.get(voucherRef);
      if (!voucherSnapshot.exists) {
        throw Exception("Voucher not found!");
      }

      final oldData = voucherSnapshot.data()!;
      final double oldAmount = (oldData['amount'] as num).toDouble();
      
      // حساب الفرق لتعديل الرصيد
      // المعادلة: الرصيد الجديد = الرصيد الحالي + (المبلغ القديم - المبلغ الجديد)
      // مثال: كان 100 وأصبح 150. الفرق -50. الرصيد ينقص بـ 50 إضافية.
      final double adjustment = oldAmount - voucher.amount;

      transaction.update(clientRef, {
        'balance': FieldValue.increment(adjustment),
      });

      // تحديث بيانات السند
      transaction.update(voucherRef, {
        'type': voucher.type.name,
        'amount': voucher.amount,
        'date': Timestamp.fromDate(voucher.date),
        'linkedInvoiceId': voucher.linkedInvoiceId,
        'note': voucher.note,
      });
    });
  }
}