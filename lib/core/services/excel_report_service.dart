// [phase_2] creation
// file: lib/core/services/excel_report_service.dart

import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ExcelReportService {
  
  /// دالة عامة لتوليد ملف Excel
  /// [sheetName]: اسم الورقة داخل الملف
  /// [headers]: قائمة عناوين الأعمدة
  /// [data]: قائمة الصفوف (كل صف عبارة عن قائمة من القيم)
  Future<List<int>?> generateExcel({
    required String sheetName,
    required List<String> headers,
    required List<List<dynamic>> data,
  }) async {
    // 1. إنشاء ملف Excel جديد
    var excel = Excel.createExcel();
    
    // 2. إدارة الورقة (Sheet)
    // تغيير اسم الورقة الافتراضية أو إنشاء جديدة
    Sheet sheetObject = excel['Sheet1'];
    excel.rename('Sheet1', sheetName);
    
    // 3. إضافة العناوين (Headers)
    // نستخدم CellStyle لتمييز العناوين (اختياري، هنا بسيط)
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    // 4. إضافة البيانات (Rows)
    for (var row in data) {
      final List<CellValue> cellValues = row.map((cell) {
        if (cell == null) return TextCellValue("-");
        if (cell is double) return DoubleCellValue(cell);
        if (cell is int) return IntCellValue(cell);
        return TextCellValue(cell.toString());
      }).toList();
      
      sheetObject.appendRow(cellValues);
    }

    // 5. إرجاع البيانات كـ Bytes
    return excel.encode();
  }
}