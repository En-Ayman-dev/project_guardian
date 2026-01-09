class DailyReportRow {
  final String invoiceNumber; // رقم الفاتورة
  final String clientName;    // الاسم
  final double previousBalance; // الرصيد السابق
  final double paidAmount;      // الواصل
  final double remainingBalance; // الباقي (الرصيد الحالي)
  
  // خريطة لتخزين كمية/سعر كل منتج (المفتاح هو اسم المنتج)
  final Map<String, dynamic> productValues; 

  DailyReportRow({
    required this.invoiceNumber,
    required this.clientName,
    required this.previousBalance,
    required this.paidAmount,
    required this.remainingBalance,
    required this.productValues,
  });
}