import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/invoice_entity.dart';
import '../manager/invoices_list_cubit.dart';
import '../manager/invoices_list_state.dart';
import 'pos_page.dart';

class InvoicesListPage extends StatelessWidget {
  const InvoicesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InvoicesListCubit>()..loadInvoices(),
      child: const _InvoicesListView(),
    );
  }
}

class _InvoicesListView extends StatelessWidget {
  const _InvoicesListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل العمليات'), centerTitle: true),
      body: Column(
        children: [
          // 1. Filter Section (Tabs)
          const _FilterTabs(),

          // 2. Invoices List
          Expanded(
            child: BlocBuilder<InvoicesListCubit, InvoicesListState>(
              builder: (context, state) {
                if (state.isLoading && state.allInvoices.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.filteredInvoices.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<InvoicesListCubit>().loadInvoices(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = state.filteredInvoices[index];
                      return _InvoiceCard(invoice: invoice);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد فواتير لعرضها',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesListCubit, InvoicesListState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildTab(
                context,
                'المبيعات',
                InvoiceType.sales,
                state.filterType == InvoiceType.sales,
                Colors.blue,
              ),
              _buildTab(
                context,
                'المشتريات',
                InvoiceType.purchase,
                state.filterType == InvoiceType.purchase,
                Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context,
    String title,
    InvoiceType type,
    bool isSelected,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<InvoicesListCubit>().changeFilter(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final isSale = invoice.type == InvoiceType.sales;
    final themeColor = isSale ? Colors.blue.shade700 : Colors.orange.shade700;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${invoice.invoiceNumber}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSale ? 'مبيعات' : 'مشتريات',
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  Icons.calendar_today,
                  DateFormat('yyyy-MM-dd').format(invoice.date),
                ),
                _buildInfoColumn(
                  Icons.attach_money,
                  '${invoice.totalAmount.toStringAsFixed(2)}',
                ),
                _buildInfoColumn(
                  Icons.production_quantity_limits,
                  '${invoice.items.length} أصناف',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.print, color: Colors.grey),
                  onPressed: () {
                    // TODO: Implement Printing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الطباعة قيد التطوير')),
                    );
                  },
                ),

                // --- إضافة زر الإرجاع (Linked Return) ---
                if (invoice.type == InvoiceType.sales ||
                    invoice.type == InvoiceType.purchase)
                  IconButton(
                    tooltip: 'إنشاء مرتجع',
                    icon: const Icon(
                      Icons.replay_circle_filled_rounded,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PosPage(originalInvoiceForReturn: invoice),
                            ),
                          )
                          .then((_) {
                            // تحديث القائمة عند العودة (لأن المخزون قد تغير)
                            context.read<InvoicesListCubit>().loadInvoices();
                          });
                    },
                  ),

                // ----------------------------------------
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PosPage(invoiceToEdit: invoice),
                          ),
                        )
                        .then((_) {
                          context.read<InvoicesListCubit>().loadInvoices();
                        });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
          'هل أنت متأكد من حذف هذه الفاتورة؟\nسيتم عكس تأثير المخزون تلقائياً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<InvoicesListCubit>().deleteInvoice(invoice);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
