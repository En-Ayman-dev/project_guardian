import 'package:equatable/equatable.dart';
import 'invoice_item_entity.dart';

class InvoiceEntity extends Equatable {
  final String id;
  final String invoiceNumber; // رقم متسلسل أو معرف قصير للعرض
  
  // بيانات العميل
  final String clientId;
  final String clientName;
  
  final DateTime date;
  
  final List<InvoiceItemEntity> items;
  
  // الحسابات المالية
  final double subTotal; // المجموع قبل الخصم والضريبة
  final double discount; // قيمة الخصم
  final double tax;      // قيمة الضريبة
  final double totalAmount; // الصافي النهائي

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.items,
    required this.subTotal,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [
    id, invoiceNumber, clientId, clientName, date, items, subTotal, discount, tax, totalAmount
  ];
}