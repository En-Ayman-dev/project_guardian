// [phase_2] modification
// file: lib/features/sales/presentation/pages/invoices_list_page.dart

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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // نلغي الـ AppBar التقليدي ونستبدله بتصميم مخصص داخل الـ Body
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'سجل العمليات',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              _searchCtrl.clear();
              context.read<InvoicesListCubit>().loadInvoices(refresh: true);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. الخلفية الملونة العلوية (نفس ستايل الداشبورد)
          Container(
            height: 100, // ارتفاع أقل لأننا لا نعرض إحصائيات ضخمة هنا
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. المحتوى الرئيسي
          Column(
            children: [
              // منطقة البحث (عائمة)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'بحث برقم الفاتورة أو اسم العميل...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _searchCtrl.clear();
                                });
                                context
                                    .read<InvoicesListCubit>()
                                    .searchInvoices('');
                                FocusScope.of(context).unfocus();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {}); // لتحديث أيقونة المسح
                      context.read<InvoicesListCubit>().searchInvoices(value);
                    },
                  ),
                ),
              ),

              // تبويبات الفلترة
              const _ModernFilterTabs(),

              // قائمة الفواتير
              Expanded(
                child: BlocBuilder<InvoicesListCubit, InvoicesListState>(
                  builder: (context, state) {
                    if (state.isLoading &&
                        state.allInvoices.isEmpty &&
                        state.searchResults.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.filteredInvoices.isEmpty) {
                      String msg = 'لا توجد فواتير في هذا القسم';
                      if (state.isSearching) msg = 'لا توجد نتائج للبحث';
                      if (state.allInvoices.isEmpty) msg = 'سجل العمليات فارغ';

                      return _buildEmptyState(msg);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _searchCtrl.clear();
                        await context.read<InvoicesListCubit>().loadInvoices(
                          refresh: true,
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: state.filteredInvoices.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.filteredInvoices.length) {
                            return _buildLoadMoreButton(context, state);
                          }
                          final invoice = state.filteredInvoices[index];
                          return _ModernInvoiceCard(invoice: invoice);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, InvoicesListState state) {
    if (state.isSearching) return const SizedBox.shrink();

    if (state.hasReachedMax) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Text(
                "نهاية القائمة",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isMoreLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: () {
            context.read<InvoicesListCubit>().loadInvoices();
          },
          icon: const Icon(Icons.arrow_downward_rounded, size: 18),
          label: const Text("تحميل المزيد"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// مكونات UI الجديدة والمحسنة
// -----------------------------------------------------------------------------

class _ModernFilterTabs extends StatelessWidget {
  const _ModernFilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesListCubit, InvoicesListState>(
      builder: (context, state) {
        return SizedBox(
          height: 60, // ارتفاع مناسب للتبويبات
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [
              _buildModernTab(
                context,
                'المبيعات',
                InvoiceType.sales,
                state.filterType == InvoiceType.sales,
                const Color(0xFF1A73E8), // أزرق
                Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: 10),
              _buildModernTab(
                context,
                'مرتجع بيع',
                InvoiceType.salesReturn,
                state.filterType == InvoiceType.salesReturn,
                const Color(0xFFF57C00), // برتقالي
                Icons.replay_rounded,
              ),
              const SizedBox(width: 10),
              _buildModernTab(
                context,
                'المشتريات',
                InvoiceType.purchase,
                state.filterType == InvoiceType.purchase,
                const Color(0xFF34A853), // أخضر
                Icons.arrow_downward_rounded,
              ),
              const SizedBox(width: 10),
              _buildModernTab(
                context,
                'مرتجع شراء',
                InvoiceType.purchaseReturn,
                state.filterType == InvoiceType.purchaseReturn,
                const Color(0xFFD32F2F), // أحمر
                Icons.replay_circle_filled_rounded,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernTab(
    BuildContext context,
    String title,
    InvoiceType type,
    bool isSelected,
    Color color,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => context.read<InvoicesListCubit>().changeFilter(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : color.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernInvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;

  const _ModernInvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    Color themeColor;
    String typeName;

    // تحديد الألوان والنصوص بناءً على النوع
    switch (invoice.type) {
      case InvoiceType.sales:
        themeColor = const Color(0xFF1A73E8);
        typeName = 'مبيعات';
        break;
      case InvoiceType.salesReturn:
        themeColor = const Color(0xFFF57C00);
        typeName = 'مرتجع مبيعات';
        break;
      case InvoiceType.purchase:
        themeColor = const Color(0xFF34A853);
        typeName = 'مشتريات';
        break;
      case InvoiceType.purchaseReturn:
        themeColor = const Color(0xFFD32F2F);
        typeName = 'مرتجع مشتريات';
        break;
    }

    final isReturn = invoice.isReturn;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصف العلوي: الأيقونة + الاسم + المبلغ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // أيقونة النوع داخل دائرة
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isReturn ? Icons.replay : Icons.receipt_long_rounded,
                        color: themeColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // اسم العميل ورقم الفاتورة
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.clientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '#${invoice.invoiceNumber}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        'Courier', // خط مونو لتبدو كرقم كود
                                  ),
                                ),
                              ),
                              if (invoice.originalInvoiceNumber != null) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.link_rounded,
                                  size: 14,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  invoice.originalInvoiceNumber!,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // المبلغ والتاريخ
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${invoice.totalAmount.toStringAsFixed(2)} \$',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: themeColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('yyyy-MM-dd', 'en').format(invoice.date),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 0.5),
                ),

                // الصف السفلي: التفاصيل والأزرار
                Row(
                  children: [
                    // عدد الأصناف
                    Icon(
                      Icons.layers_outlined,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${invoice.items.length} أصناف',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),

                    const Spacer(),

                    // أزرار الإجراءات السريعة (مصغرة وأنيقة)
                    Row(
                      children: [
                        _ActionButton(
                          icon: Icons.print_rounded,
                          color: Colors.grey.shade600,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('الطباعة قيد التطوير'),
                              ),
                            );
                          },
                        ),
                        if (!isReturn) ...[
                          const SizedBox(width: 8),
                          _ActionButton(
                            icon: Icons.replay_rounded,
                            color: Colors.purple.shade400,
                            tooltip: 'مرتجع',
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => PosPage(
                                        originalInvoiceForReturn: invoice,
                                      ),
                                    ),
                                  )
                                  .then(
                                    (_) => context
                                        .read<InvoicesListCubit>()
                                        .loadInvoices(),
                                  );
                            },
                          ),
                        ],
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: Icons.edit_rounded,
                          color: Colors.blue.shade600,
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PosPage(invoiceToEdit: invoice),
                                  ),
                                )
                                .then(
                                  (_) => context
                                      .read<InvoicesListCubit>()
                                      .loadInvoices(),
                                );
                          },
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: Icons.delete_outline_rounded,
                          color: Colors.red.shade400,
                          onTap: () => _confirmDelete(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تأكيد الحذف'),
        content: const Text(
          'هل أنت متأكد من حذف هذه العملية؟\nسيتم عكس تأثير المخزون والمالية تلقائياً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InvoicesListCubit>().deleteInvoice(invoice);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('حذف نهائي'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
