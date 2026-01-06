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
      create: (context) =>
          getIt<InvoicesListCubit>()..loadInvoices(refresh: true),
      child: const _InvoicesListView(),
    );
  }
}

class _InvoicesListView extends StatefulWidget {
  const _InvoicesListView();

  @override
  State<_InvoicesListView> createState() => _InvoicesListViewState();
}

class _InvoicesListViewState extends State<_InvoicesListView> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'بحث برقم الفاتورة أو اسم العميل...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<InvoicesListCubit>().searchInvoices('');
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: (value) {
                // استخدام debounce (تأخير) بسيط هنا سيكون مثالياً، لكن للتبسيط نستدعي مباشرة
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
                // حالة التحميل الأولي (فقط إذا كانت القائمة فارغة)
                if (state.isLoading &&
                    state.allInvoices.isEmpty &&
                    state.searchResults.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.filteredInvoices.isEmpty) {
                  // إذا كنا نبحث ولا توجد نتائج
                  if (state.isSearching) {
                    return _buildCenterMessage('لا توجد نتائج مطابقة للبحث');
                  }
                  // إذا كانت القائمة فارغة تماماً
                  if (state.allInvoices.isEmpty) {
                    return _buildCenterMessage('لا توجد فواتير لعرضها');
                  }
                  // إذا كانت الفلترة الحالية فارغة (مثلاً لا يوجد مرتجعات)
                  return _buildCenterMessage('لا توجد فواتير في هذا القسم');
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _searchCtrl.clear();
                    await context.read<InvoicesListCubit>().loadInvoices(
                      refresh: true,
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    // نضيف 1 للعنصر الإضافي (زر التحميل)
                    itemCount: state.filteredInvoices.length + 1,
                    itemBuilder: (context, index) {
                      // إذا وصلنا لآخر عنصر
                      if (index >= state.filteredInvoices.length) {
                        return _buildLoadMoreButton(context, state);
                      }

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

  Widget _buildLoadMoreButton(BuildContext context, InvoicesListState state) {
    // 1. لا نعرض الزر إذا كنا في وضع البحث
    if (state.isSearching) return const SizedBox.shrink();

    // 2. لا نعرض الزر إذا وصلنا للنهاية
    if (state.hasReachedMax) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            "تم عرض جميع الفواتير",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // 3. عرض مؤشر تحميل إذا كان جاري جلب المزيد
    if (state.isMoreLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 4. عرض الزر
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton.icon(
        onPressed: () {
          context.read<InvoicesListCubit>().loadInvoices();
        },
        icon: const Icon(Icons.arrow_downward),
        label: const Text("عرض المزيد"),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildCenterMessage(String msg) {
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
          Text(msg, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// --- المكونات الأخرى (_FilterTabs و _InvoiceCard) تبقى كما هي في الكود السابق ---
// يرجى التأكد من نسخ كلاس _FilterTabs و _InvoiceCard من الإجابة السابقة
// ووضعهما هنا في نفس الملف لإكمال الكود.
// لن أكررهما هنا لتوفير المساحة، لكنهما ضروريان.

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'طباعة',
                    icon: const Icon(Icons.print, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الطباعة قيد التطوير')),
                      );
                    },
                  ),
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
