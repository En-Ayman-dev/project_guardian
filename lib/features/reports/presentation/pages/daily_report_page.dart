import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../manager/daily_report_cubit.dart';

class DailyReportPage extends StatelessWidget {
  const DailyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DailyReportCubit>()..loadInitialData(),
      child: const _DailyReportView(),
    );
  }
}

class _DailyReportView extends StatefulWidget {
  const _DailyReportView();

  @override
  State<_DailyReportView> createState() => _DailyReportViewState();
}

class _DailyReportViewState extends State<_DailyReportView> {
  DateTime _selectedDate = DateTime.now();
  List<ProductEntity> _selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقرير يومي مفصل')),
      body: BlocBuilder<DailyReportCubit, DailyReportState>(
        builder: (context, state) {
          if (state is DailyReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is DailyReportDataLoaded) {
            final allProducts = state.allProducts;
            
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. اختيار التاريخ
                  ListTile(
                    title: const Text('تاريخ التقرير'),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.grey)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  const Text('اختر الأصناف للعرض في التقرير:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // 2. اختيار المنتجات (Multi Select)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                        itemCount: allProducts.length,
                        itemBuilder: (context, index) {
                          final product = allProducts[index];
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
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. زر الطباعة
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('توليد التقرير PDF'),
                    onPressed: _selectedProducts.isEmpty 
                      ? null // تعطيل الزر إذا لم يتم اختيار منتجات
                      : () {
                          context.read<DailyReportCubit>().generateReport(
                            date: _selectedDate,
                            selectedProducts: _selectedProducts,
                          );
                        },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('جاري تحميل البيانات...'));
        },
      ),
    );
  }
}