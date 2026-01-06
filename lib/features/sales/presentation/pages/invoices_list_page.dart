import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/invoice_entity.dart';
import '../manager/invoices_list_cubit.dart';
import '../manager/invoices_list_state.dart';
import 'pos_page.dart';
import 'invoice_details_page.dart';

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
      appBar: AppBar(
        title: const Text('سجل العمليات'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث برقم الفاتورة أو اسم العميل...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: (value) {
                context.read<InvoicesListCubit>().searchInvoices(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const _FilterTabs(),
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
          height: 50,
          margin: const EdgeInsets.all(12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTab(
                context,
                'المبيعات',
                InvoiceType.sales,
                state.filterType == InvoiceType.sales,
                Colors.blue,
              ),
              const SizedBox(width: 8),
              _buildTab(
                context,
                'مرتجع مبيعات',
                InvoiceType.salesReturn,
                state.filterType == InvoiceType.salesReturn,
                Colors.orange,
              ),
              const SizedBox(width: 8),
              _buildTab(
                context,
                'المشتريات',
                InvoiceType.purchase,
                state.filterType == InvoiceType.purchase,
                Colors.green,
              ),
              const SizedBox(width: 8),
              _buildTab(
                context,
                'مرتجع مشتريات',
                InvoiceType.purchaseReturn,
                state.filterType == InvoiceType.purchaseReturn,
                Colors.red,
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
    return GestureDetector(
      onTap: () => context.read<InvoicesListCubit>().changeFilter(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade700,
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
    Color themeColor;
    String typeName;
    IconData typeIcon;

    switch (invoice.type) {
      case InvoiceType.sales:
        themeColor = Colors.blue.shade700;
        typeName = 'مبيعات';
        typeIcon = Icons.arrow_upward;
        break;
      case InvoiceType.salesReturn:
        themeColor = Colors.orange.shade700;
        typeName = 'مرتجع مبيعات';
        typeIcon = Icons.replay;
        break;
      case InvoiceType.purchase:
        themeColor = Colors.green.shade700;
        typeName = 'مشتريات';
        typeIcon = Icons.arrow_downward;
        break;
      case InvoiceType.purchaseReturn:
        themeColor = Colors.red.shade700;
        typeName = 'مرتجع مشتريات';
        typeIcon = Icons.replay_circle_filled;
        break;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: themeColor.withOpacity(0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // فتح التفاصيل عند الضغط على الكارت
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceDetailsPage(invoice: invoice),
            ),
          ).then((_) {
            context.read<InvoicesListCubit>().loadInvoices();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${invoice.invoiceNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: themeColor,
                            ),
                          ),
                          if (invoice.originalInvoiceNumber != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.link,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'أصل: ${invoice.originalInvoiceNumber}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
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
                    child: Row(
                      children: [
                        Icon(typeIcon, size: 14, color: themeColor),
                        const SizedBox(width: 4),
                        Text(
                          typeName,
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              // --- Info ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    Icons.calendar_today,
                    DateFormat('yyyy-MM-dd').format(invoice.date),
                  ),
                  _buildInfoColumn(
                    Icons.attach_money,
                    invoice.totalAmount.toStringAsFixed(2),
                  ),
                  _buildInfoColumn(
                    Icons.production_quantity_limits,
                    '${invoice.items.length} أصناف',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- Actions Buttons (تمت إعادتها بناءً على طلبك) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 1. زر الطباعة
                  IconButton(
                    tooltip: 'طباعة',
                    icon: const Icon(Icons.print, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الطباعة قيد التطوير')),
                      );
                    },
                  ),

                  // 2. زر إنشاء مرتجع (فقط للفواتير الأصلية)
                  if (!invoice.isReturn)
                    IconButton(
                      tooltip: 'إنشاء مرتجع',
                      icon: const Icon(Icons.replay, color: Colors.purple),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PosPage(originalInvoiceForReturn: invoice),
                              ),
                            )
                            .then((_) {
                              context.read<InvoicesListCubit>().loadInvoices();
                            });
                      },
                    ),

                  // 3. زر التعديل
                  IconButton(
                    tooltip: 'تعديل',
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

                  // 4. زر الحذف
                  IconButton(
                    tooltip: 'حذف',
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
            ],
          ),
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
          'هل أنت متأكد من حذف هذه العملية؟\nسيتم عكس تأثير المخزون والمالية تلقائياً.',
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
