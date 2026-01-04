import 'package:equatable/equatable.dart';
import 'invoice_item_entity.dart';

/// تحديد نوع الفاتورة: مبيعات، مشتريات، أو مرتجعات
/// هذا الأساس الذي سيغير سلوك الواجهة والمخزون
enum InvoiceType {
  sales,          // فاتورة مبيعات (تنقص المخزون، تزيد الصندوق)
  purchase,       // فاتورة مشتريات (تزيد المخزون، تنقص الصندوق)
  salesReturn,    // مرتجع مبيعات (يزيد المخزون، ينقص الصندوق)
  purchaseReturn  // مرتجع مشتريات (ينقص المخزون، يزيد الصندوق)
}

/// حالة الفاتورة في النظام
enum InvoiceStatus {
  draft,    // مسودة: يمكن تعديلها، لا تؤثر على المخزون أو الحسابات
  posted,   // مرحّلة: نهائية، تم خصم الكميات وتسجيل القيود المالية
  canceled  // ملغاة: لا تؤثر في الحسابات ولكن تبقى في الأرشيف
}

/// حالة الدفع للفاتورة
enum PaymentStatus {
  unpaid,   // غير مدفوعة
  partial,  // مدفوعة جزئياً
  paid      // خالصة
}

class InvoiceEntity extends Equatable {
  final String id;
  final String invoiceNumber;
  
  // التصنيف والحالة
  final InvoiceType type;
  final InvoiceStatus status;

  // بيانات الطرف الثاني (العميل في المبيعات / المورد في المشتريات)
  final String clientId;
  final String clientName;

  // التواريخ
  final DateTime date;      // تاريخ الإصدار
  final DateTime? dueDate;  // تاريخ الاستحقاق (للفواتير الآجلة)

  final List<InvoiceItemEntity> items;

  // الحسابات المالية
  final double subTotal;    // المجموع قبل الخصم والضريبة
  final double discount;    // قيمة الخصم الإجمالي
  final double tax;         // قيمة الضريبة المضافة
  final double totalAmount; // الصافي النهائي المستحق
  
  // المدفوعات
  final double paidAmount;  // المبلغ المدفوع حتى الآن
  final String? note;       // ملاحظات إضافية

  // Getters ذكية للمنطق
  double get remainingAmount => totalAmount - paidAmount;
  
  PaymentStatus get paymentStatus {
    if (paidAmount >= totalAmount) return PaymentStatus.paid;
    if (paidAmount > 0) return PaymentStatus.partial;
    return PaymentStatus.unpaid;
  }

  bool get isPosted => status == InvoiceStatus.posted;
  bool get isDraft => status == InvoiceStatus.draft;

  // هل هذه العملية تعتبر "إرجاع"؟
  bool get isReturn => type == InvoiceType.salesReturn || type == InvoiceType.purchaseReturn;

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.type,
    this.status = InvoiceStatus.draft,
    required this.clientId,
    required this.clientName,
    required this.date,
    this.dueDate,
    required this.items,
    required this.subTotal,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    this.paidAmount = 0.0,
    this.note,
  });

  @override
  List<Object?> get props => [
        id,
        invoiceNumber,
        type,
        status,
        clientId,
        clientName,
        date,
        dueDate,
        items,
        subTotal,
        discount,
        tax,
        totalAmount,
        paidAmount,
        note,
      ];
}