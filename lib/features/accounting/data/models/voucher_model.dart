// [phase_2] creation
// file: lib/features/accounting/data/models/voucher_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/voucher_entity.dart';

class VoucherModel extends VoucherEntity {
  const VoucherModel({
    required super.id,
    required super.voucherNumber,
    required super.type,
    required super.amount,
    required super.date,
    required super.clientSupplierId,
    required super.clientSupplierName,
    super.linkedInvoiceId,
    required super.note,
  });

  // تحويل من JSON (Firestore) إلى Model
  factory VoucherModel.fromJson(Map<String, dynamic> json, String id) {
    return VoucherModel(
      id: id,
      voucherNumber: json['voucherNumber'] ?? '',
      type: VoucherType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'receipt'),
        orElse: () => VoucherType.receipt,
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      // التعامل مع التاريخ (Firestore Timestamp)
      date: (json['date'] is Timestamp) 
          ? (json['date'] as Timestamp).toDate() 
          : DateTime.now(),
      clientSupplierId: json['clientSupplierId'] ?? '',
      clientSupplierName: json['clientSupplierName'] ?? '',
      linkedInvoiceId: json['linkedInvoiceId'],
      note: json['note'] ?? '',
    );
  }

  // تحويل من Model إلى JSON (للحفظ في Firestore)
  Map<String, dynamic> toJson() {
    return {
      'voucherNumber': voucherNumber,
      'type': type.name, // تخزين الـ Enum كنص
      'amount': amount,
      'date': Timestamp.fromDate(date), // تحويل DateTime إلى Timestamp
      'clientSupplierId': clientSupplierId,
      'clientSupplierName': clientSupplierName,
      'linkedInvoiceId': linkedInvoiceId,
      'note': note,
    };
  }
}