// // [phase_3] fix_autocomplete
// // file: lib/features/reports/presentation/pages/item_movement_report_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../../../../core/di/injection_container.dart';
// import '../../../../core/services/excel_report_service.dart';
// import '../../../../core/services/pdf_report_service.dart';
// import '../../../inventory/domain/entities/product_entity.dart';
// import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
// import '../manager/item_movement_cubit.dart';
// import '../manager/item_movement_state.dart';

// class ItemMovementReportPage extends StatelessWidget {
//   const ItemMovementReportPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       // [FIX] استخدام loadInitialData لتحميل المنتجات والعملاء
//       create: (context) => getIt<ItemMovementCubit>()..loadInitialData(),
//       child: const _ReportView(),
//     );
//   }
// }

// class _ReportView extends StatefulWidget {
//   const _ReportView();

//   @override
//   State<_ReportView> createState() => _ReportViewState();
// }

// class _ReportViewState extends State<_ReportView> {
//   ProductEntity? _selectedProduct;
//   ClientSupplierEntity? _selectedPartner;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   bool _isSupplierMode = false;

//   final TextEditingController _productCtrl = TextEditingController();
//   final TextEditingController _partnerCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _productCtrl.dispose();
//     _partnerCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تقرير حركة صنف')),
//       body: Column(
//         children: [
//           // --- قسم الفلاتر ---
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.grey.shade50,
//             child: Column(
//               children: [
//                 // 1. بحث الصنف (Fixed Autocomplete)
//                 _buildProductAutocomplete(context),

//                 const SizedBox(height: 12),

//                 // 2. التاريخ ونوع الشريك
//                 Row(
//                   children: [
//                     Expanded(child: _buildDateFilter(context)),
//                     const SizedBox(width: 8),
//                     _buildPartnerTypeToggle(),
//                   ],
//                 ),

//                 const SizedBox(height: 12),

//                 // 3. بحث الشريك (Fixed Autocomplete)
//                 _buildPartnerAutocomplete(context),
//               ],
//             ),
//           ),
//           const Divider(height: 1, thickness: 2),

//           // --- النتائج ---
//           Expanded(
//             child: BlocBuilder<ItemMovementCubit, ItemMovementState>(
//               builder: (context, state) {
//                 if (state is ItemMovementLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is ItemMovementError) {
//                   return Center(
//                       child: Text(state.message,
//                           style: const TextStyle(color: Colors.red)));
//                 }
//                 if (state is ItemMovementLoaded) {
//                   if (state.movements.isEmpty) {
//                     return const Center(child: Text('لا توجد حركات مطابقة'));
//                   }
//                   return Column(
//                     children: [
//                       _buildSummaryCard(state),
//                       Expanded(child: _buildMovementsTable(state)),
//                     ],
//                   );
//                 }
//                 return const Center(child: Text('اختر صنفاً لعرض التقرير'));
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildExportButtons(context),
//     );
//   }

//   // --- أدوات البحث المحسنة ---

//   Widget _buildProductAutocomplete(BuildContext context) {
//     return BlocBuilder<ItemMovementCubit, ItemMovementState>(
//       builder: (context, state) {
//         return Autocomplete<ProductEntity>(
//           optionsBuilder: (textEditingValue) {
//             return context
//                 .read<ItemMovementCubit>()
//                 .searchProducts(textEditingValue.text);
//           },
//           displayStringForOption: (option) => option.name,
//           onSelected: (product) {
//             setState(() => _selectedProduct = product);
//             _productCtrl.text = product.name; // تحديث النص عند الاختيار
//             FocusScope.of(context).unfocus(); // إخفاء الكيبورد
//             _refreshReport(context);
//           },
//           fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//             if (_productCtrl.text.isEmpty && controller.text.isNotEmpty) {
//               // مزامنة مبدئية
//             }
//             return TextField(
//               controller: controller,
//               focusNode: focusNode,
//               decoration: InputDecoration(
//                 labelText: 'اسم الصنف أو الباركود',
//                 prefixIcon: const Icon(Icons.inventory_2),
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 filled: true,
//                 fillColor: Colors.white,
//                 suffixIcon: _selectedProduct != null
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, color: Colors.grey),
//                         onPressed: () {
//                           setState(() => _selectedProduct = null);
//                           controller.clear();
//                         },
//                       )
//                     : null,
//               ),
//             );
//           },
//           // [FIX] هذا الجزء هو المسؤول عن شكل القائمة واستجابتها للنقر
//           optionsViewBuilder: (context, onSelected, options) {
//             return Align(
//               alignment: Alignment.topLeft,
//               child: Material(
//                 elevation: 4,
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 32, // عرض مناسب
//                   constraints: const BoxConstraints(maxHeight: 250),
//                   child: ListView.separated(
//                     padding: EdgeInsets.zero,
//                     itemCount: options.length,
//                     separatorBuilder: (c, i) => const Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       final option = options.elementAt(index);
//                       return ListTile(
//                         title: Text(option.name,
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold)),
//                         subtitle: Text(
//                             'Stock: ${option.stock} | Price: ${option.baseUnit.sellPrice}'),
//                         onTap: () =>
//                             onSelected(option), // هنا يتم تنفيذ الاختيار
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPartnerAutocomplete(BuildContext context) {
//     return BlocBuilder<ItemMovementCubit, ItemMovementState>(
//       builder: (context, state) {
//         return Autocomplete<ClientSupplierEntity>(
//           optionsBuilder: (textEditingValue) {
//             return context.read<ItemMovementCubit>().searchPartners(
//                 textEditingValue.text,
//                 isSupplier: _isSupplierMode);
//           },
//           displayStringForOption: (option) => option.name,
//           onSelected: (partner) {
//             setState(() => _selectedPartner = partner);
//             _partnerCtrl.text = partner.name;
//             FocusScope.of(context).unfocus();
//             _refreshReport(context);
//           },
//           fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//             return TextField(
//               controller: controller,
//               focusNode: focusNode,
//               decoration: InputDecoration(
//                 labelText:
//                     _isSupplierMode ? 'بحث عن مورد...' : 'بحث عن عميل...',
//                 prefixIcon:
//                     Icon(_isSupplierMode ? Icons.local_shipping : Icons.person),
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 filled: true,
//                 fillColor: Colors.white,
//                 suffixIcon: _selectedPartner != null
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, color: Colors.grey),
//                         onPressed: () {
//                           setState(() => _selectedPartner = null);
//                           controller.clear();
//                           _refreshReport(context);
//                         },
//                       )
//                     : null,
//               ),
//             );
//           },
//           // [FIX] تحسين قائمة الشركاء
//           optionsViewBuilder: (context, onSelected, options) {
//             return Align(
//               alignment: Alignment.topLeft,
//               child: Material(
//                 elevation: 4,
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 32,
//                   constraints: const BoxConstraints(maxHeight: 200),
//                   child: ListView.separated(
//                     padding: EdgeInsets.zero,
//                     itemCount: options.length,
//                     separatorBuilder: (c, i) => const Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       final option = options.elementAt(index);
//                       return ListTile(
//                         leading: const Icon(Icons.account_circle,
//                             color: Colors.indigo),
//                         title: Text(option.name),
//                         subtitle: Text(option.phone.isNotEmpty
//                             ? option.phone
//                             : 'لا يوجد هاتف'),
//                         onTap: () => onSelected(option),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // --- بقية الـ Widgets المساعدة ---

//   Widget _buildDateFilter(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         final picked = await showDateRangePicker(
//           context: context,
//           firstDate: DateTime(2020),
//           lastDate: DateTime.now().add(const Duration(days: 1)),
//           initialDateRange: _startDate != null
//               ? DateTimeRange(start: _startDate!, end: _endDate!)
//               : null,
//         );
//         if (picked != null) {
//           setState(() {
//             _startDate = picked.start;
//             _endDate = picked.end;
//           });
//           _refreshReport(context);
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.calendar_today, size: 16, color: Colors.indigo),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 _startDate == null
//                     ? 'كل الفترة'
//                     : '${DateFormat('MM/dd').format(_startDate!)} - ${DateFormat('MM/dd').format(_endDate!)}',
//                 style:
//                     const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             if (_startDate != null)
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _startDate = null;
//                     _endDate = null;
//                   });
//                   _refreshReport(context);
//                 },
//                 child: const Icon(Icons.close, size: 16),
//               )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPartnerTypeToggle() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey),
//       ),
//       child: Row(
//         children: [
//           _typeIcon(false, Icons.person),
//           Container(width: 1, height: 20, color: Colors.grey),
//           _typeIcon(true, Icons.local_shipping),
//         ],
//       ),
//     );
//   }

//   Widget _typeIcon(bool isSupplier, IconData icon) {
//     final isSelected = _isSupplierMode == isSupplier;
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _isSupplierMode = isSupplier;
//           _selectedPartner = null; // تصفير الاختيار عند التبديل
//         });
//         // لا نحتاج لإعادة تحميل التقرير هنا لأننا صفرنا الشريك
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         color: isSelected ? Colors.indigo.withOpacity(0.1) : Colors.transparent,
//         child: Icon(icon,
//             size: 20, color: isSelected ? Colors.indigo : Colors.grey),
//       ),
//     );
//   }

//   void _refreshReport(BuildContext context) {
//     if (_selectedProduct != null) {
//       context.read<ItemMovementCubit>().generateReportForProduct(
//             _selectedProduct!,
//             selectedPartner: _selectedPartner,
//             startDate: _startDate,
//             endDate: _endDate,
//           );
//     }
//   }

//   // --- العرض والتصدير (كما هو) ---
//   Widget _buildSummaryCard(ItemMovementLoaded state) {
//     return Container(
//       color: Colors.indigo.shade50,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _summaryItem(
//               'الكمية', state.totalQuantity.toStringAsFixed(1), Colors.black87),
//           _summaryItem('القيمة', '${state.totalValue.toStringAsFixed(0)} \$',
//               Colors.green.shade800),
//           _summaryItem('العمليات', '${state.movements.length}', Colors.indigo),
//         ],
//       ),
//     );
//   }

//   Widget _summaryItem(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 15, fontWeight: FontWeight.bold, color: color)),
//       ],
//     );
//   }

//   Widget _buildMovementsTable(ItemMovementLoaded state) {
//     return ListView.separated(
//       itemCount: state.movements.length,
//       separatorBuilder: (c, i) => const Divider(height: 1),
//       itemBuilder: (context, index) {
//         final m = state.movements[index];
//         final isIn = m.transactionType.contains("مشتريات") ||
//             m.transactionType.contains("مرتجع مبيعات");
//         return ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//           leading: Icon(
//             isIn ? Icons.arrow_downward : Icons.arrow_upward,
//             color: isIn ? Colors.green : Colors.red,
//             size: 18,
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(m.transactionType,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(DateFormat('yyyy-MM-dd').format(m.date),
//                   style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             ],
//           ),
//           subtitle: Row(
//             children: [
//               Expanded(
//                   child: Text('${m.partnerName} (${m.invoiceNumber})',
//                       overflow: TextOverflow.ellipsis)),
//               Text('${m.quantity} ${m.unitName}',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.black87)),
//             ],
//           ),
//           trailing: Text('${m.total.toStringAsFixed(1)}\$',
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//         );
//       },
//     );
//   }

//   Widget _buildExportButtons(BuildContext context) {
//     return BlocBuilder<ItemMovementCubit, ItemMovementState>(
//       builder: (context, state) {
//         if (state is ItemMovementLoaded && state.movements.isNotEmpty) {
//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               FloatingActionButton.small(
//                 heroTag: 'pdf',
//                 backgroundColor: Colors.red.shade50,
//                 onPressed: () => _exportPdf(context, state),
//                 child: const Icon(Icons.picture_as_pdf, color: Colors.red),
//               ),
//               const SizedBox(width: 8),
//               FloatingActionButton.small(
//                 heroTag: 'excel',
//                 backgroundColor: Colors.green.shade50,
//                 onPressed: () => _exportExcel(context, state),
//                 child: const Icon(Icons.table_view, color: Colors.green),
//               ),
//             ],
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   Future<void> _exportPdf(
//       BuildContext context, ItemMovementLoaded state) async {
//     final pdfService = getIt<PdfReportService>();
//     final data = state.movements
//         .map((m) => [
//               DateFormat('yyyy-MM-dd').format(m.date),
//               m.transactionType,
//               m.invoiceNumber,
//               m.partnerName,
//               m.quantity,
//               m.price.toStringAsFixed(2),
//               m.total.toStringAsFixed(2)
//             ])
//         .toList();

//     String subtitle = 'كل الفترات';
//     if (_startDate != null)
//       subtitle =
//           '${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}';

//     await pdfService.generateTablePdf(
//       title: 'حركة صنف: ${state.selectedProduct.name}',
//       subtitle: subtitle,
//       columns: [
//         'التاريخ',
//         'الحركة',
//         'السند',
//         'الطرف',
//         'الكمية',
//         'السعر',
//         'الإجمالي'
//       ],
//       data: data,
//       summary: {
//         'الكمية': state.totalQuantity.toString(),
//         'القيمة': state.totalValue.toString()
//       },
//     );
//   }

//   Future<void> _exportExcel(
//       BuildContext context, ItemMovementLoaded state) async {
//     final excelService = getIt<ExcelReportService>();
//     final data = state.movements
//         .map((m) => [
//               DateFormat('yyyy-MM-dd').format(m.date),
//               m.transactionType,
//               m.invoiceNumber,
//               m.partnerName,
//               m.quantity,
//               m.price,
//               m.total
//             ])
//         .toList();
//     await excelService.generateExcel(
//       sheetName: 'Movement',
//       headers: ['Date', 'Type', 'Invoice', 'Partner', 'Qty', 'Price', 'Total'],
//       data: data,
//     );
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Excel Generated')));
//   }
// }
// [phase_2] final_version
// file: lib/features/reports/presentation/pages/item_movement_report_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/excel_report_service.dart';
import '../../../../core/services/pdf_report_service.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../manager/item_movement_cubit.dart';
import '../manager/item_movement_state.dart';

class ItemMovementReportPage extends StatelessWidget {
  const ItemMovementReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ItemMovementCubit>()..loadInitialData(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تقارير الأصناف والمخزون'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.history), text: 'حركة صنف (تفصيلي)'),
                Tab(icon: Icon(Icons.inventory), text: 'جرد المخزون (تجميعي)'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _ItemMovementTab(), // التبويب الأول (القديم)
              _InventoryStockTab(), // التبويب الثاني (الجديد)
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: حركة صنف (Original Logic)
// -----------------------------------------------------------------------------
class _ItemMovementTab extends StatefulWidget {
  const _ItemMovementTab();

  @override
  State<_ItemMovementTab> createState() => _ItemMovementTabState();
}

class _ItemMovementTabState extends State<_ItemMovementTab>
    with AutomaticKeepAliveClientMixin {
  ProductEntity? _selectedProduct;
  ClientSupplierEntity? _selectedPartner;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSupplierMode = false;

  final TextEditingController _productCtrl = TextEditingController();
  final TextEditingController _partnerCtrl = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _productCtrl.dispose();
    _partnerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                _buildProductAutocomplete(context),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDateFilter(context)),
                    const SizedBox(width: 8),
                    _buildPartnerTypeToggle(),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPartnerAutocomplete(context),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 2),
          Expanded(
            child: BlocBuilder<ItemMovementCubit, ItemMovementState>(
              builder: (context, state) {
                if (state is ItemMovementLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ItemMovementError) {
                  return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.red)));
                }
                if (state is ItemMovementLoaded) {
                  if (state.movements.isEmpty) {
                    return const Center(child: Text('لا توجد حركات مطابقة'));
                  }
                  return Column(
                    children: [
                      _buildSummaryCard(state),
                      Expanded(child: _buildMovementsTable(state)),
                    ],
                  );
                }
                return const Center(child: Text('اختر صنفاً لعرض التقرير'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildExportButtons(context),
    );
  }

  // --- Widgets (Tab 1) ---
  Widget _buildProductAutocomplete(BuildContext context) {
    return BlocBuilder<ItemMovementCubit, ItemMovementState>(
      builder: (context, state) {
        return Autocomplete<ProductEntity>(
          optionsBuilder: (textEditingValue) => context
              .read<ItemMovementCubit>()
              .searchProducts(textEditingValue.text),
          displayStringForOption: (option) => option.name,
          onSelected: (product) {
            setState(() => _selectedProduct = product);
            _productCtrl.text = product.name;
            FocusScope.of(context).unfocus();
            _refreshReport(context);
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            if (_productCtrl.text.isEmpty && controller.text.isNotEmpty) {}
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'اسم الصنف أو الباركود',
                prefixIcon: const Icon(Icons.inventory_2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: _selectedProduct != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() => _selectedProduct = null);
                          controller.clear();
                        })
                    : null,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                          title: Text(option.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Stock: ${option.stock}'),
                          onTap: () => onSelected(option));
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPartnerAutocomplete(BuildContext context) {
    return BlocBuilder<ItemMovementCubit, ItemMovementState>(
      builder: (context, state) {
        return Autocomplete<ClientSupplierEntity>(
          optionsBuilder: (textEditingValue) => context
              .read<ItemMovementCubit>()
              .searchPartners(textEditingValue.text,
                  isSupplier: _isSupplierMode),
          displayStringForOption: (option) => option.name,
          onSelected: (partner) {
            setState(() => _selectedPartner = partner);
            _partnerCtrl.text = partner.name;
            FocusScope.of(context).unfocus();
            _refreshReport(context);
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText:
                    _isSupplierMode ? 'بحث عن مورد...' : 'بحث عن عميل...',
                prefixIcon:
                    Icon(_isSupplierMode ? Icons.local_shipping : Icons.person),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: _selectedPartner != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() => _selectedPartner = null);
                          controller.clear();
                          _refreshReport(context);
                        })
                    : null,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                          leading: const Icon(Icons.account_circle,
                              color: Colors.indigo),
                          title: Text(option.name),
                          onTap: () => onSelected(option));
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          initialDateRange: _startDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
        );
        if (picked != null) {
          setState(() {
            _startDate = picked.start;
            _endDate = picked.end;
          });
          _refreshReport(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.indigo),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                    _startDate == null
                        ? 'كل الفترة'
                        : '${DateFormat('MM/dd').format(_startDate!)} - ${DateFormat('MM/dd').format(_endDate!)}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis)),
            if (_startDate != null)
              InkWell(
                  onTap: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                    });
                    _refreshReport(context);
                  },
                  child: const Icon(Icons.close, size: 16))
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerTypeToggle() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey)),
      child: Row(children: [
        _typeIcon(false, Icons.person),
        Container(width: 1, height: 20, color: Colors.grey),
        _typeIcon(true, Icons.local_shipping)
      ]),
    );
  }

  Widget _typeIcon(bool isSupplier, IconData icon) {
    final isSelected = _isSupplierMode == isSupplier;
    return InkWell(
        onTap: () {
          setState(() {
            _isSupplierMode = isSupplier;
            _selectedPartner = null;
          });
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: isSelected
                ? Colors.indigo.withOpacity(0.1)
                : Colors.transparent,
            child: Icon(icon,
                size: 20, color: isSelected ? Colors.indigo : Colors.grey)));
  }

  void _refreshReport(BuildContext context) {
    if (_selectedProduct != null) {
      context.read<ItemMovementCubit>().generateReportForProduct(
          _selectedProduct!,
          selectedPartner: _selectedPartner,
          startDate: _startDate,
          endDate: _endDate);
    }
  }

  Widget _buildSummaryCard(ItemMovementLoaded state) {
    return Container(
      color: Colors.indigo.shade50,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _summaryItem(
            'الكمية', state.totalQuantity.toStringAsFixed(1), Colors.black87),
        _summaryItem('القيمة', '${state.totalValue.toStringAsFixed(0)} \$',
            Colors.green.shade800),
        _summaryItem('العمليات', '${state.movements.length}', Colors.indigo),
      ]),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
      Text(value,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: color))
    ]);
  }

  Widget _buildMovementsTable(ItemMovementLoaded state) {
    return ListView.separated(
      itemCount: state.movements.length,
      separatorBuilder: (c, i) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final m = state.movements[index];
        final isIn = m.transactionType.contains("مشتريات") ||
            m.transactionType.contains("مرتجع مبيعات");
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Icon(isIn ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIn ? Colors.green : Colors.red, size: 18),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(m.transactionType,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(DateFormat('yyyy-MM-dd').format(m.date),
                style: const TextStyle(fontSize: 12, color: Colors.grey))
          ]),
          subtitle: Row(children: [
            Expanded(
                child: Text('${m.partnerName} (${m.invoiceNumber})',
                    overflow: TextOverflow.ellipsis)),
            Text('${m.quantity} ${m.unitName}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87))
          ]),
          trailing: Text('${m.total.toStringAsFixed(1)}\$',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  Widget _buildExportButtons(BuildContext context) {
    return BlocBuilder<ItemMovementCubit, ItemMovementState>(
      builder: (context, state) {
        if (state is ItemMovementLoaded && state.movements.isNotEmpty) {
          return Row(mainAxisSize: MainAxisSize.min, children: [
            FloatingActionButton.small(
                heroTag: 'pdf',
                backgroundColor: Colors.red.shade50,
                onPressed: () => _exportPdf(context, state),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red)),
            const SizedBox(width: 8),
            FloatingActionButton.small(
                heroTag: 'excel',
                backgroundColor: Colors.green.shade50,
                onPressed: () => _exportExcel(context, state),
                child: const Icon(Icons.table_view, color: Colors.green)),
          ]);
        }
        return const SizedBox();
      },
    );
  }

  Future<void> _exportPdf(
      BuildContext context, ItemMovementLoaded state) async {
    final pdfService = getIt<PdfReportService>();
    final data = state.movements
        .map((m) => [
              DateFormat('yyyy-MM-dd').format(m.date),
              m.transactionType,
              m.invoiceNumber,
              m.partnerName,
              m.quantity,
              m.price.toStringAsFixed(2),
              m.total.toStringAsFixed(2)
            ])
        .toList();
    await pdfService.generateTablePdf(
        title: 'حركة صنف: ${state.selectedProduct.name}',
        subtitle: 'تفصيلي',
        columns: [
          'التاريخ',
          'الحركة',
          'السند',
          'الطرف',
          'الكمية',
          'السعر',
          'الإجمالي'
        ],
        data: data,
        summary: {
          'الكمية': state.totalQuantity.toString(),
          'القيمة': state.totalValue.toString()
        });
  }

  Future<void> _exportExcel(
      BuildContext context, ItemMovementLoaded state) async {
    final excelService = getIt<ExcelReportService>();
    final data = state.movements
        .map((m) => [
              DateFormat('yyyy-MM-dd').format(m.date),
              m.transactionType,
              m.invoiceNumber,
              m.partnerName,
              m.quantity,
              m.price,
              m.total
            ])
        .toList();
    await excelService.generateExcel(
        sheetName: 'Movement',
        headers: [
          'Date',
          'Type',
          'Invoice',
          'Partner',
          'Qty',
          'Price',
          'Total'
        ],
        data: data);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Excel Generated')));
  }
}

// -----------------------------------------------------------------------------
// TAB 2: جرد المخزون (Inventory Stock Tab - COMPLETE)
// -----------------------------------------------------------------------------
class _InventoryStockTab extends StatefulWidget {
  const _InventoryStockTab();

  @override
  State<_InventoryStockTab> createState() => _InventoryStockTabState();
}

class _InventoryStockTabState extends State<_InventoryStockTab>
    with AutomaticKeepAliveClientMixin {
  List<ProductEntity> _selectedProducts = [];
  bool _isAllSelected = false;
  ClientSupplierEntity? _selectedPartner;
  final TextEditingController _partnerCtrl = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                _buildMultiSelectProduct(context),
                const SizedBox(height: 12),
                _buildPartnerAutocomplete(context),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 2),
          Expanded(
            child: BlocBuilder<ItemMovementCubit, ItemMovementState>(
              builder: (context, state) {
                if (state is ItemMovementLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is InventoryStockLoaded) {
                  return _buildStockTable(state);
                }
                return const Center(
                    child: Text('اضغط "توليد التقرير" لعرض المخزون'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ItemMovementCubit, ItemMovementState>(
            builder: (context, state) {
              if (state is InventoryStockLoaded &&
                  state.stockItems.isNotEmpty) {
                return FloatingActionButton.small(
                  heroTag: 'stock_pdf',
                  backgroundColor: Colors.red,
                  onPressed: () => _exportStockPdf(context, state),
                  child: const Icon(Icons.picture_as_pdf),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'generate_stock',
            onPressed: _generateReport,
            label: const Text('توليد التقرير'),
            icon: const Icon(Icons.analytics),
            backgroundColor: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectProduct(BuildContext context) {
    return ExpansionTile(
      title: Text('الأصناف المختارة (${_selectedProducts.length})'),
      leading: const Icon(Icons.checklist),
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      children: [
        ListTile(
          title: const Text('تحديد الكل'),
          trailing: Checkbox(
            value: _isAllSelected,
            onChanged: (val) {
              setState(() {
                _isAllSelected = val ?? false;
                if (_isAllSelected) {
                  // جلب كل المنتجات من الكيوبت (عن طريق البحث الفارغ)
                  _selectedProducts = List.from(
                      context.read<ItemMovementCubit>().searchProducts(''));
                } else {
                  _selectedProducts.clear();
                }
              });
            },
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount:
                context.read<ItemMovementCubit>().searchProducts('').length,
            itemBuilder: (context, index) {
              final product =
                  context.read<ItemMovementCubit>().searchProducts('')[index];
              final isSelected = _selectedProducts.contains(product);
              return CheckboxListTile(
                title: Text(product.name),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedProducts.add(product);
                    } else {
                      _selectedProducts.remove(product);
                    }
                    _isAllSelected = _selectedProducts.length ==
                        context
                            .read<ItemMovementCubit>()
                            .searchProducts('')
                            .length;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerAutocomplete(BuildContext context) {
    return Autocomplete<ClientSupplierEntity>(
      optionsBuilder: (textEditingValue) => context
          .read<ItemMovementCubit>()
          .searchPartners(textEditingValue.text), // Default search
      displayStringForOption: (option) => option.name,
      onSelected: (partner) {
        setState(() => _selectedPartner = partner);
        _partnerCtrl.text = partner.name;
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'فلترة حسب العميل/المورد (اختياري)',
            prefixIcon: const Icon(Icons.person_search),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: _selectedPartner != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() => _selectedPartner = null);
                      controller.clear();
                    })
                : null,
          ),
        );
      },
    );
  }

  Widget _buildStockTable(InventoryStockLoaded state) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('الصنف')),
            DataColumn(label: Text('الكلي (وارد)')),
            DataColumn(label: Text('المباع (صادر)')),
            DataColumn(label: Text('المتبقي'))
          ],
          rows: state.stockItems.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.productName)),
              DataCell(Text(item.totalQty.toStringAsFixed(1))),
              DataCell(Text(item.soldQty.toStringAsFixed(1))),
              DataCell(Text(item.remainingQty.toStringAsFixed(1),
                  style: TextStyle(
                      color: item.remainingQty < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold))),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _generateReport() {
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار صنف واحد على الأقل')));
      return;
    }
    context.read<ItemMovementCubit>().generateInventoryReport(
        products: _selectedProducts, partnerFilter: _selectedPartner);
  }

  Future<void> _exportStockPdf(
      BuildContext context, InventoryStockLoaded state) async {
    final pdfService = getIt<PdfReportService>();
    final data = state.stockItems
        .map((i) => [
              i.productName,
              i.totalQty.toStringAsFixed(1),
              i.soldQty.toStringAsFixed(1),
              i.remainingQty.toStringAsFixed(1)
            ])
        .toList();
    await pdfService.generateTablePdf(
      title: 'تقرير جرد المخزون التجميعي',
      subtitle: 'العدد: ${state.stockItems.length} صنف',
      columns: ['الصنف', 'الوارد (كلي)', 'الصادر (مباع)', 'المتبقي'],
      data: data,
      summary: {},
    );
  }
}
