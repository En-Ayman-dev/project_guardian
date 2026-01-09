// [phase_4] fix_fonts - Full File
// file: lib/core/services/pdf_report_service.dart

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:injectable/injectable.dart';
import '../../features/reports/domain/entities/daily_report_row.dart';

@lazySingleton
class PdfReportService {
  // دالة مساعدة لتحميل الخطوط لضمان عدم تكرار الكود
  Future<pw.Font> _loadFont(String path) async {
    try {
      final fontData = await rootBundle.load(path);
      return pw.Font.ttf(fontData);
    } catch (e) {
      print('ERROR LOADING FONT $path: $e');
      // في حال الفشل نعود للخط الافتراضي لتجنب توقف التطبيق، لكن ستظهر مربعات
      return pw.Font.courier();
    }
  }

  /// --------------------------------------------------------------------------
  /// 1. دالة التقرير العام (كشف حساب، أرصدة، إلخ)
  /// --------------------------------------------------------------------------
  Future<void> generateTablePdf({
    required String title,
    required String subtitle,
    required List<String> columns,
    required List<List<dynamic>> data,
    required Map<String, String> summary,
    bool isLandscape = false,
  }) async {
    // 1. تحميل الخطوط
    final ttf = await _loadFont('assets/fonts/Cairo-Regular.ttf');
    final ttfBold = await _loadFont('assets/fonts/Cairo-Bold.ttf');

    // 2. معالجة البيانات (RTL fix + Null Safety)
    final safeData = data.map((row) {
      return row.map((cell) {
        // تحويل النص إلى String وضمان عدم وجود null
        final text = cell?.toString() ?? '-';
        // مكتبة PDF تقوم بقلب الحروف العربية تلقائياً عادة،
        // ولكن إذا واجهت مشكلة الحروف المقلوبة يمكن استخدام bidi package هنا.
        // حالياً سنعتمد على textDirection: RTL
        return text;
      }).toList();
    }).toList();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
        // تعيين الثيم العام للصفحة
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        textDirection: pw.TextDirection.rtl, // أساسي للعربية

        footer: (pw.Context context) => _buildFooter(context, ttf),

        build: (pw.Context context) {
          return [
            _buildHeader(title, subtitle, ttfBold),
            pw.SizedBox(height: 20),
            // نمرر الخطوط صراحة للجدول
            _buildTable(columns, safeData, ttfBold, ttf),
            pw.SizedBox(height: 20),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: _buildSummary(summary, ttfBold),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  /// --------------------------------------------------------------------------
  /// 2. دالة تقرير المبيعات اليومي (Daily Report)
  /// --------------------------------------------------------------------------
  Future<void> generateDailyReportPdf({
    required String title,
    required String date,
    required List<String> productHeaders,
    required List<DailyReportRow> rows,
  }) async {
    final ttf = await _loadFont('assets/fonts/Cairo-Regular.ttf');
    final ttfBold = await _loadFont('assets/fonts/Cairo-Bold.ttf');

    final List<String> tableHeaders = [
      'رقم الفاتورة',
      ...productHeaders,
      'الاسم',
      'الواصل',
      'الرصيد السابق',
      'الرصيد (الباقي)',
    ];

    final data = rows.map((row) {
      final productCells = productHeaders.map((prodName) {
        final val = row.productValues[prodName];
        return val != null ? val.toString() : '-';
      }).toList();

      return [
        row.invoiceNumber,
        ...productCells,
        row.clientName,
        row.paidAmount.toStringAsFixed(2),
        row.previousBalance.toStringAsFixed(2),
        row.remainingBalance.toStringAsFixed(2),
      ];
    }).toList();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        textDirection: pw.TextDirection.rtl,

        footer: (pw.Context context) => _buildFooter(context, ttf),

        build: (context) => [
          _buildHeader(title, 'تاريخ التقرير: $date', ttfBold),
          pw.SizedBox(height: 10),

          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: data,
            border: null,
            // تنسيق الهيدر (العناوين)
            headerStyle: pw.TextStyle(
              font: ttfBold, // تأكد من استخدام الخط العريض هنا
              fontSize: 10,
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              ),
            ),
            // [FIX] هنا الحل للمربعات: تعيين الخط للخلايا صراحة
            cellStyle: pw.TextStyle(
              font: ttf, // استخدام الخط العادي (Cairo-Regular)
              fontSize: 9,
            ),
            cellAlignment: pw.Alignment.center,
            headerAlignment: pw.Alignment.center,
            cellPadding: const pw.EdgeInsets.all(5),
            oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'daily_report_$date.pdf',
    );
  }

  // --- Helpers ---

  pw.Widget _buildHeader(String title, String subtitle, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'نظام جارديان للإدارة المتكاملة',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
            pw.PdfLogo(),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 20,
                font: font,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.Text(
              subtitle,
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Divider(color: PdfColors.blue900, thickness: 2),
      ],
    );
  }

  pw.Widget _buildTable(
    List<String> columns,
    List<List<dynamic>> data,
    pw.Font headerFont,
    pw.Font cellFont,
  ) {
    return pw.Table.fromTextArray(
      headers: columns,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(
        font: headerFont,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 10,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.all(6),
      // [FIX] تمرير الخط للخلايا
      cellStyle: pw.TextStyle(font: cellFont, fontSize: 9),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
    );
  }

  pw.Widget _buildSummary(Map<String, String> summary, pw.Font font) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(5),
            color: PdfColors.grey50,
          ),
          child: pw.Column(
            children: summary.entries.map((e) {
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    e.key,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    e.value,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.Font font) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'تم التوليد بواسطة: نظام جارديان',
              style: pw.TextStyle(
                font: font,
                fontSize: 8,
                color: PdfColors.grey,
              ),
            ),
            pw.Text(
              'الصفحة ${context.pageNumber} من ${context.pagesCount}',
              style: pw.TextStyle(
                font: font,
                fontSize: 8,
                color: PdfColors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
