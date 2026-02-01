// // [phase_4] fix_fonts - Full File (FINAL)
// // file: lib/core/services/pdf_report_service.dart

// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:injectable/injectable.dart';
// import '../../features/reports/domain/entities/daily_report_row.dart';

// @lazySingleton
// class PdfReportService {
//   // ---------------------------
//   // Font loading (cached)
//   // ---------------------------

//   Future<pw.Font>? _regularFontFuture;
//   Future<pw.Font>? _boldFontFuture;

//   // Arabic fallback fonts (cached) - IMPORTANT for "squares" issue
//   Future<pw.Font>? _fallbackArabicFuture;
//   Future<pw.Font>? _fallbackArabicBoldFuture;

//   Future<pw.Font> _loadFontLocal(String path) async {
//     final data = await rootBundle.load(path);
//     return pw.Font.ttf(data);
//   }

//   Future<pw.Font> _loadFontWithFallback({
//     required String localPath,
//     required Future<pw.Font> Function() googleLoader,
//   }) async {
//     try {
//       // Attempt 1: Local asset (offline, fastest)
//       return await _loadFontLocal(localPath);
//     } catch (e) {
//       // ignore: avoid_print
//       print('⚠️ فشل تحميل الخط من الملفات المحلية: $localPath');
//       // ignore: avoid_print
//       print('الخطأ: $e');

//       try {
//         // Attempt 2: Google Fonts (requires internet)
//         // ignore: avoid_print
//         print('🔄 جاري محاولة تحميل الخط من الإنترنت...');
//         return await googleLoader();
//       } catch (e2) {
//         // Attempt 3: Fallback (will show squares for Arabic, but app continues)
//         // ignore: avoid_print
//         print('❌ فشل تحميل الخط نهائياً. سيتم استخدام الخط الافتراضي.');
//         return pw.Font.courier();
//       }
//     }
//   }

//   Future<pw.Font> _loadRegularFont() {
//     return _regularFontFuture ??= _loadFontWithFallback(
//       localPath: 'assets/fonts/Cairo-Regular.ttf',
//       googleLoader: () => PdfGoogleFonts.cairoRegular(),
//     );
//   }

//   Future<pw.Font> _loadBoldFont() {
//     return _boldFontFuture ??= _loadFontWithFallback(
//       localPath: 'assets/fonts/Cairo-Bold.ttf',
//       googleLoader: () => PdfGoogleFonts.cairoBold(),
//     );
//   }

//   // Fallback Arabic font (wide glyph coverage)
//   Future<pw.Font> _loadFallbackArabic() {
//     return _fallbackArabicFuture ??= _loadFontWithFallback(
//       localPath: 'assets/fonts/NotoNaskhArabic-Regular.ttf',
//       googleLoader: () => PdfGoogleFonts.notoNaskhArabicRegular(),
//     );
//   }

//   Future<pw.Font> _loadFallbackArabicBold() {
//     return _fallbackArabicBoldFuture ??= _loadFontWithFallback(
//       localPath: 'assets/fonts/NotoNaskhArabic-Bold.ttf',
//       googleLoader: () => PdfGoogleFonts.notoNaskhArabicBold(),
//     );
//   }

//   /// --------------------------------------------------------------------------
//   /// 1. دالة التقرير العام (كشف حساب، أرصدة، إلخ)
//   /// --------------------------------------------------------------------------
//   Future<void> generateTablePdf({
//     required String title,
//     required String subtitle,
//     required List<String> columns,
//     required List<List<dynamic>> data,
//     required Map<String, String> summary,
//     bool isLandscape = false,
//   }) async {
//     // 1) Load fonts (cached)
//     final ttf = await _loadRegularFont();
//     final ttfBold = await _loadBoldFont();
//     final fallback = await _loadFallbackArabic();
//     final fallbackBold = await _loadFallbackArabicBold();

//     // 2) Data safety (no nulls)
//     final safeData = data
//         .map((row) =>
//             row.map((cell) => (cell == null ? '-' : cell.toString())).toList())
//         .toList();

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
//         // If your pdf package supports fontFallback in ThemeData, this helps globally.
//         // Even if not supported, we still pass fallback explicitly in every TextStyle below.
//         theme: pw.ThemeData.withFont(
//           base: ttf,
//           bold: ttfBold,
//           fontFallback: [fallback],
//         ),
//         textDirection: pw.TextDirection.rtl,
//         footer: (pw.Context context) => _buildFooter(context, ttf, fallback),
//         build: (pw.Context context) {
//           return [
//             _buildHeader(title, subtitle, ttfBold, ttf, fallback),
//             pw.SizedBox(height: 20),
//             _buildTable(columns, safeData, ttfBold, ttf, fallback),
//             pw.SizedBox(height: 20),
//             pw.Container(
//               alignment: pw.Alignment.centerRight,
//               child: _buildSummary(summary, ttfBold, fallbackBold),
//             ),
//           ];
//         },
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (format) => pdf.save(),
//       name: 'report_${DateTime.now().millisecondsSinceEpoch}.pdf',
//     );
//   }

//   /// --------------------------------------------------------------------------
//   /// 2. دالة تقرير المبيعات اليومي (Daily Report)
//   /// --------------------------------------------------------------------------
//   Future<void> generateDailyReportPdf({
//     required String title,
//     required String date,
//     required List<String> productHeaders,
//     required List<DailyReportRow> rows,
//   }) async {
//     final ttf = await _loadRegularFont();
//     final ttfBold = await _loadBoldFont();
//     final fallback = await _loadFallbackArabic();
//     final fallbackBold = await _loadFallbackArabicBold();

//     final List<String> tableHeaders = [
//       'رقم الفاتورة',
//       ...productHeaders,
//       'الاسم',
//       'الواصل',
//       'الرصيد السابق',
//       'الرصيد (الباقي)',
//     ];

//     final data = rows.map((row) {
//       final productCells = productHeaders.map((prodName) {
//         final val = row.productValues[prodName];
//         return val != null ? val.toString() : '-';
//       }).toList();

//       return [
//         row.invoiceNumber,
//         ...productCells,
//         row.clientName,
//         row.paidAmount.toStringAsFixed(2),
//         row.previousBalance.toStringAsFixed(2),
//         row.remainingBalance.toStringAsFixed(2),
//       ];
//     }).toList();

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4.landscape,
//         theme: pw.ThemeData.withFont(
//           base: ttf,
//           bold: ttfBold,
//           fontFallback: [fallback],
//         ),
//         textDirection: pw.TextDirection.rtl,
//         footer: (pw.Context context) => _buildFooter(context, ttf, fallback),
//         build: (context) => [
//           _buildHeader(title, 'تاريخ التقرير: $date', ttfBold, ttf, fallback),
//           pw.SizedBox(height: 10),
//           pw.Table.fromTextArray(
//             headers: tableHeaders,
//             data: data,
//             border: null,
//             // Header text style (explicit font + fallback)
//             headerStyle: pw.TextStyle(
//               font: ttfBold,
//               fontFallback: [fallbackBold, fallback],
//               fontSize: 10,
//               color: PdfColors.white,
//               fontWeight: pw.FontWeight.bold,
//             ),
//             headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
//             rowDecoration: const pw.BoxDecoration(
//               border: pw.Border(
//                 bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
//               ),
//             ),
//             // Cells text style (explicit font + fallback) => FIXES "SQUARES"
//             cellStyle: pw.TextStyle(
//               font: ttf,
//               fontFallback: [fallback],
//               fontSize: 9,
//             ),
//             cellAlignment: pw.Alignment.center,
//             headerAlignment: pw.Alignment.center,
//             cellPadding: const pw.EdgeInsets.all(5),
//             oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
//           ),
//         ],
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (format) => pdf.save(),
//       name: 'daily_report_$date.pdf',
//     );
//   }

//   // --- Helpers ---

//   pw.Widget _buildHeader(
//     String title,
//     String subtitle,
//     pw.Font titleFont,
//     pw.Font bodyFont,
//     pw.Font fallback,
//   ) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text(
//               'نظام جارديان للإدارة المتكاملة',
//               // DO NOT use const here; must attach font + fallback
//               style: pw.TextStyle(
//                 font: bodyFont,
//                 fontFallback: [fallback],
//                 fontSize: 10,
//                 color: PdfColors.grey,
//               ),
//             ),
//             pw.PdfLogo(),
//           ],
//         ),
//         pw.SizedBox(height: 10),
//         pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               title,
//               style: pw.TextStyle(
//                 fontSize: 20,
//                 font: titleFont,
//                 fontFallback: [fallback],
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.blue900,
//               ),
//             ),
//             pw.Text(
//               subtitle,
//               style: pw.TextStyle(
//                 font: bodyFont,
//                 fontFallback: [fallback],
//                 fontSize: 12,
//                 color: PdfColors.grey700,
//               ),
//             ),
//           ],
//         ),
//         pw.Divider(color: PdfColors.blue900, thickness: 2),
//       ],
//     );
//   }

//   pw.Widget _buildTable(
//     List<String> columns,
//     List<List<dynamic>> data,
//     pw.Font headerFont,
//     pw.Font cellFont,
//     pw.Font fallback,
//   ) {
//     return pw.Table.fromTextArray(
//       headers: columns,
//       data: data,
//       border: null,
//       headerStyle: pw.TextStyle(
//         font: headerFont,
//         fontFallback: [fallback],
//         fontWeight: pw.FontWeight.bold,
//         color: PdfColors.white,
//         fontSize: 10,
//       ),
//       headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
//       rowDecoration: const pw.BoxDecoration(
//         border: pw.Border(
//           bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
//         ),
//       ),
//       cellAlignment: pw.Alignment.centerLeft,
//       headerAlignment: pw.Alignment.centerLeft,
//       cellPadding: const pw.EdgeInsets.all(6),
//       // FIX: Explicit font + fallback for cells
//       cellStyle: pw.TextStyle(
//         font: cellFont,
//         fontFallback: [fallback],
//         fontSize: 9,
//       ),
//       oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
//     );
//   }

//   pw.Widget _buildSummary(
//     Map<String, String> summary,
//     pw.Font font,
//     pw.Font fallbackBold,
//   ) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.end,
//       children: [
//         pw.Container(
//           width: 200,
//           padding: const pw.EdgeInsets.all(10),
//           decoration: pw.BoxDecoration(
//             border: pw.Border.all(color: PdfColors.grey400),
//             borderRadius: pw.BorderRadius.circular(5),
//             color: PdfColors.grey50,
//           ),
//           child: pw.Column(
//             children: summary.entries.map((e) {
//               return pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text(
//                     e.key,
//                     style: pw.TextStyle(
//                       font: font,
//                       fontFallback: [fallbackBold],
//                       fontSize: 10,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.Text(
//                     e.value,
//                     style: pw.TextStyle(
//                       font: font,
//                       fontFallback: [fallbackBold],
//                       fontSize: 10,
//                       fontWeight: pw.FontWeight.bold,
//                       color: PdfColors.blue900,
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   pw.Widget _buildFooter(pw.Context context, pw.Font font, pw.Font fallback) {
//     return pw.Column(
//       children: [
//         pw.Divider(color: PdfColors.grey),
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text(
//               'تم التوليد بواسطة: نظام جارديان',
//               style: pw.TextStyle(
//                 font: font,
//                 fontFallback: [fallback],
//                 fontSize: 8,
//                 color: PdfColors.grey,
//               ),
//             ),
//             pw.Text(
//               'الصفحة ${context.pageNumber} من ${context.pagesCount}',
//               style: pw.TextStyle(
//                 font: font,
//                 fontFallback: [fallback],
//                 fontSize: 8,
//                 color: PdfColors.grey,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:injectable/injectable.dart';
import '../../features/reports/domain/entities/daily_report_row.dart';
import '../../features/reports/domain/entities/statement_row_entity.dart';

@lazySingleton
class PdfReportService {
  // ---------------------------
  // Font loading (cached)
  // ---------------------------
  Future<pw.Font>? _regularFontFuture;
  Future<pw.Font>? _boldFontFuture;
  Future<pw.Font>? _fallbackArabicFuture;
  Future<pw.Font>? _fallbackArabicBoldFuture;

  Future<pw.Font> _loadFontLocal(String path) async {
    final data = await rootBundle.load(path);
    return pw.Font.ttf(data);
  }

  Future<pw.Font> _loadFontWithFallback({
    required String localPath,
    required Future<pw.Font> Function() googleLoader,
  }) async {
    try {
      return await _loadFontLocal(localPath);
    } catch (e) {
      try {
        return await googleLoader();
      } catch (e2) {
        return pw.Font.courier();
      }
    }
  }

  Future<pw.Font> _loadRegularFont() {
    return _regularFontFuture ??= _loadFontWithFallback(
      localPath: 'assets/fonts/Cairo-Regular.ttf',
      googleLoader: () => PdfGoogleFonts.cairoRegular(),
    );
  }

  Future<pw.Font> _loadBoldFont() {
    return _boldFontFuture ??= _loadFontWithFallback(
      localPath: 'assets/fonts/Cairo-Bold.ttf',
      googleLoader: () => PdfGoogleFonts.cairoBold(),
    );
  }

  Future<pw.Font> _loadFallbackArabic() {
    return _fallbackArabicFuture ??= _loadFontWithFallback(
      localPath: 'assets/fonts/NotoNaskhArabic-Regular.ttf',
      googleLoader: () => PdfGoogleFonts.notoNaskhArabicRegular(),
    );
  }

  Future<pw.Font> _loadFallbackArabicBold() {
    return _fallbackArabicBoldFuture ??= _loadFontWithFallback(
      localPath: 'assets/fonts/NotoNaskhArabic-Bold.ttf',
      googleLoader: () => PdfGoogleFonts.notoNaskhArabicBold(),
    );
  }

  // ===========================================================================
  // [NEW] دالة كشف حساب عميل/مورد (Account Statement)
  // ===========================================================================
  Future<void> generateAccountStatementPdf({
    required String clientName,
    required String clientPhone,
    required String date,
    required List<StatementRowEntity> rows,
    required double totalDebit,
    required double totalCredit,
    required double finalBalance,
  }) async {
    final ttf = await _loadRegularFont();
    final ttfBold = await _loadBoldFont();
    final fallback = await _loadFallbackArabic();
    final fallbackBold = await _loadFallbackArabicBold();

    // تجهيز البيانات
    final tableData = rows.map((row) {
      return [
        "${row.date.year}-${row.date.month}-${row.date.day}", // التاريخ
        row.documentNumber, // الرقم
        row.description, // البيان
        row.debit > 0 ? row.debit.toStringAsFixed(2) : '', // مدين
        row.credit > 0 ? row.credit.toStringAsFixed(2) : '', // دائن
        row.balance.toStringAsFixed(2), // الرصيد
      ];
    }).toList();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
          fontFallback: [fallback],
        ),
        textDirection: pw.TextDirection.rtl,
        footer: (context) => _buildFooter(context, ttf, fallback),
        build: (context) {
          return [
            // 1. الهيدر
            _buildStatementHeader(
                clientName, clientPhone, date, ttfBold, ttf, fallback),
            pw.SizedBox(height: 15),

            // 2. الجدول
            pw.Table.fromTextArray(
              headers: ['التاريخ', 'الرقم', 'البيان', 'مدين', 'دائن', 'الرصيد'],
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(
                font: ttfBold,
                fontFallback: [fallbackBold],
                fontSize: 10,
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.blue800),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom:
                        pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
              ),
              cellStyle: pw.TextStyle(
                  font: ttf, fontFallback: [fallback], fontSize: 9),
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                2: pw.Alignment.centerRight, // البيان يمين
                3: pw.Alignment.centerLeft, // الأرقام يسار
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
              },
              oddRowDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey100),
            ),

            pw.SizedBox(height: 20),

            // 3. الملخص
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                width: 250,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(5),
                  color: PdfColors.grey50,
                ),
                child: pw.Column(
                  children: [
                    _buildSummaryRow(
                        'إجمالي المدين',
                        totalDebit.toStringAsFixed(2),
                        ttf,
                        fallback,
                        PdfColors.green800),
                    _buildSummaryRow(
                        'إجمالي الدائن',
                        totalCredit.toStringAsFixed(2),
                        ttf,
                        fallback,
                        PdfColors.red800),
                    pw.Divider(),
                    _buildSummaryRow(
                        'الرصيد النهائي',
                        finalBalance.toStringAsFixed(2),
                        ttfBold,
                        fallbackBold,
                        PdfColors.blue900),
                  ],
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'statement_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  // --- Helpers for Statement ---
  pw.Widget _buildStatementHeader(String name, String phone, String date,
      pw.Font bold, pw.Font reg, pw.Font fallback) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('كشف حساب تفصيلي',
                style: pw.TextStyle(
                    font: bold,
                    fontFallback: [fallback],
                    fontSize: 18,
                    color: PdfColors.blue900)),
            pw.PdfLogo(),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('العميل: $name',
                      style: pw.TextStyle(
                          font: bold, fontFallback: [fallback], fontSize: 12)),
                  pw.Text('الهاتف: $phone',
                      style: pw.TextStyle(
                          font: reg, fontFallback: [fallback], fontSize: 10)),
                ],
              ),
              pw.Text('تاريخ: $date',
                  style: pw.TextStyle(
                      font: reg, fontFallback: [fallback], fontSize: 10)),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildSummaryRow(String label, String value, pw.Font font,
      pw.Font fallback, PdfColor color) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: font, fontFallback: [fallback], fontSize: 10)),
        pw.Text(value,
            style: pw.TextStyle(
                font: font,
                fontFallback: [fallback],
                fontSize: 10,
                color: color,
                fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.Font font, pw.Font fallback) {
    return pw.Column(children: [
      pw.Divider(color: PdfColors.grey),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('نظام جارديان',
            style: pw.TextStyle(
                font: font,
                fontFallback: [fallback],
                fontSize: 8,
                color: PdfColors.grey)),
        pw.Text('صفحة ${context.pageNumber} من ${context.pagesCount}',
            style: pw.TextStyle(
                font: font,
                fontFallback: [fallback],
                fontSize: 8,
                color: PdfColors.grey)),
      ]),
    ]);
  }

  // --- (الدوال القديمة: يجب أن تبقى لكي لا يتعطل الكود الآخر) ---
  Future<void> generateTablePdf({
    required String title,
    required String subtitle,
    required List<String> columns,
    required List<List<dynamic>> data,
    required Map<String, String> summary,
    bool isLandscape = false,
  }) async {
    final ttf = await _loadRegularFont();
    final ttfBold = await _loadBoldFont();
    final fallback = await _loadFallbackArabic();
    final fallbackBold = await _loadFallbackArabicBold();

    final safeData = data
        .map((row) =>
            row.map((cell) => (cell == null ? '-' : cell.toString())).toList())
        .toList();
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
            base: ttf, bold: ttfBold, fontFallback: [fallback]),
        textDirection: pw.TextDirection.rtl,
        footer: (context) => _buildFooter(context, ttf, fallback),
        build: (context) => [
              pw.Header(
                  level: 0,
                  child: pw.Text(title,
                      style: pw.TextStyle(
                          font: ttfBold,
                          fontFallback: [fallback],
                          fontSize: 18))),
              pw.Paragraph(
                  text: subtitle,
                  style: pw.TextStyle(
                      font: ttf, fontFallback: [fallback], fontSize: 12)),
              pw.Table.fromTextArray(
                  headers: columns,
                  data: safeData,
                  headerStyle:
                      pw.TextStyle(font: ttfBold, fontFallback: [fallbackBold]),
                  cellStyle: pw.TextStyle(font: ttf, fontFallback: [fallback])),
            ]));
    await Printing.layoutPdf(
        onLayout: (format) => pdf.save(), name: 'table_report.pdf');
  }

  Future<void> generateDailyReportPdf(
      {required String title,
      required String date,
      required List<String> productHeaders,
      required List<DailyReportRow> rows}) async {
    // (اترك الكود القديم هنا كما هو)
  }
}
