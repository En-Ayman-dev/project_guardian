import 'package:equatable/equatable.dart';

enum VoucherType {
  receipt, // سند قبض (من عميل)
  payment, // سند صرف (لمورد)
}

class VoucherEntity extends Equatable {
  final String id;
  final String voucherNumber; // رقم السند التسلسلي (مثال: #REC-001)
  final VoucherType type;
  final double amount;
  final DateTime date;
  
  // بيانات الطرف الثاني (للعرض السريع وتاريخية البيانات)
  final String clientSupplierId;
  final String clientSupplierName;
  
  // الربط المرجعي (اختياري)
  final String? linkedInvoiceId; // رقم فاتورة المبيعات/المشتريات المرتبطة
  
  final String note;

  const VoucherEntity({
    required this.id,
    required this.voucherNumber,
    required this.type,
    required this.amount,
    required this.date,
    required this.clientSupplierId,
    required this.clientSupplierName,
    this.linkedInvoiceId,
    required this.note,
  });

  @override
  List<Object?> get props => [
        id,
        voucherNumber,
        type,
        amount,
        date,
        clientSupplierId,
        clientSupplierName,
        linkedInvoiceId,
        note,
      ];
}