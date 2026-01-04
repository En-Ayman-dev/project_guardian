import 'package:equatable/equatable.dart';
import 'invoice_item_entity.dart';

/// تحديد نوع الفاتورة: مبيعات، مشتريات، أو مرتجعات
enum InvoiceType {
  sales, // فاتورة مبيعات
  purchase, // فاتورة مشتريات
  salesReturn, // مرتجع مبيعات
  purchaseReturn, // مرتجع مشتريات
}

/// حالة الفاتورة في النظام
enum InvoiceStatus {
  draft, // مسودة
  posted, // مرحّلة
  canceled, // ملغاة
}

/// [NEW] نوع طريقة الدفع
enum InvoicePaymentType {
  cash, // نقد (يؤثر على الصندوق ولا يؤثر على رصيد العميل إلا بالصفر)
  credit, // آجل (يؤثر على رصيد العميل/المورد)
}

/// حالة الدفع للفاتورة
enum PaymentStatus {
  unpaid, // غير مدفوعة
  partial, // مدفوعة جزئياً
  paid, // خالصة
}

class InvoiceEntity extends Equatable {
  final String id;
  final String invoiceNumber; // سيصبح رقماً تسلسلياً (مثلاً: 1001)

  final InvoiceType type;
  final InvoiceStatus status;
  final InvoicePaymentType paymentType; // [NEW] طريقة الدفع

  final String clientId;
  final String clientName;

  final DateTime date;
  final DateTime? dueDate;

  final List<InvoiceItemEntity> items;

  final double subTotal;
  final double discount;
  final double tax;
  final double totalAmount;

  final double paidAmount;
  final String? note;

  // Getters
  double get remainingAmount => totalAmount - paidAmount;

  PaymentStatus get paymentStatus {
    // في حالة الدفع النقدي، نعتبرها مدفوعة دائماً عند الإنشاء
    if (paymentType == InvoicePaymentType.cash) return PaymentStatus.paid;

    if (paidAmount >= totalAmount - 0.01)
      return PaymentStatus.paid; // سماحية بسيطة في الكسور
    if (paidAmount > 0) return PaymentStatus.partial;
    return PaymentStatus.unpaid;
  }

  bool get isPosted => status == InvoiceStatus.posted;
  bool get isDraft => status == InvoiceStatus.draft;
  bool get isReturn =>
      type == InvoiceType.salesReturn || type == InvoiceType.purchaseReturn;

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.type,
    this.status = InvoiceStatus.draft,
    this.paymentType = InvoicePaymentType.cash, // الافتراضي نقد
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
    paymentType, // إضافة للحقل
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
