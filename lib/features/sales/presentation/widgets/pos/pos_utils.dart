import 'package:flutter/material.dart';

import '../../../domain/entities/invoice_entity.dart';

class PosUtils {
  // دالة تعريب الأرقام
  static String normalizeNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const arabic2 = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
      input = input.replaceAll(arabic2[i], english[i]);
    }
    return input;
  }

  static double parseAmount(String val) {
    if (val.isEmpty) return 0.0;
    return double.tryParse(normalizeNumbers(val)) ?? 0.0;
  }

  static int parseInt(String val) {
    if (val.isEmpty) return 1;
    return int.tryParse(normalizeNumbers(val)) ?? 1;
  }

  static String getInvoiceTitle(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return 'فاتورة مبيعات';
      case InvoiceType.purchase:
        return 'فاتورة مشتريات';
      case InvoiceType.salesReturn:
        return 'مرتجع مبيعات';
      case InvoiceType.purchaseReturn:
        return 'مرتجع مشتريات';
    }
  }

  static Color getThemeColor(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return Colors.blue.shade700;
      case InvoiceType.purchase:
        return Colors.orange.shade700;
      case InvoiceType.salesReturn:
        return Colors.red.shade700;
      case InvoiceType.purchaseReturn:
        return Colors.purple.shade700;
    }
  }
}