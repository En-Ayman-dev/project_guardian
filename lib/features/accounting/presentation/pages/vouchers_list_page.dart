// [phase_2] modification
// file: lib/features/accounting/presentation/pages/vouchers_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../../../clients_suppliers/presentation/manager/client_supplier_cubit.dart';
import '../../../clients_suppliers/presentation/manager/client_supplier_state.dart'
    as cs;
import '../../domain/entities/voucher_entity.dart';
import '../manager/accounting_cubit.dart';
import '../manager/accounting_state.dart';

class VouchersListPage extends StatelessWidget {
  const VouchersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AccountingCubit>()..fetchVouchers(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<ClientSupplierCubit>()..getList(ClientType.client),
        ),
      ],
      child: const _VouchersListView(),
    );
  }
}

class _VouchersListView extends StatelessWidget {
  const _VouchersListView();

  @override
  Widget build(BuildContext context) {
    // لون الهوية للمحاسبة (Teal)
    const primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'السندات المالية',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => context.read<AccountingCubit>().fetchVouchers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showClientSelector(context),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'سند جديد',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 4,
      ),
      body: Stack(
        children: [
          // 1. Header Background
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor.shade700, primaryColor.shade400],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: BlocBuilder<AccountingCubit, AccountingState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (msg) => _buildErrorState(msg, context),
                  loaded: (vouchers) {
                    if (vouchers.isEmpty) {
                      return _buildEmptyState();
                    }

                    // حساب الملخص المالي
                    final totalReceipts = vouchers
                        .where((v) => v.type == VoucherType.receipt)
                        .fold(0.0, (sum, v) => sum + v.amount);
                    final totalPayments = vouchers
                        .where((v) => v.type == VoucherType.payment)
                        .fold(0.0, (sum, v) => sum + v.amount);

                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        // بطاقة الملخص المالي
                        _buildFinancialSummary(totalReceipts, totalPayments),

                        const SizedBox(height: 16),

                        // القائمة
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                            itemCount: vouchers.length,
                            itemBuilder: (context, index) {
                              return _ModernVoucherTile(
                                voucher: vouchers[index],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(double receipts, double payments) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'مقبوضات',
              amount: receipts,
              icon: Icons.arrow_downward_rounded,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'مدفوعات',
              amount: payments,
              icon: Icons.arrow_upward_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 18,
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد سندات مسجلة بعد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String msg, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Text(msg, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<AccountingCubit>().fetchVouchers(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showClientSelector(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // لتمكين الزوايا الدائرية
      builder: (context) => _ClientSelectorSheet(parentContext: parentContext),
    );
  }
}

// -----------------------------------------------------------------------------
// مكونات UI الحديثة
// -----------------------------------------------------------------------------

class _ModernVoucherTile extends StatelessWidget {
  final VoucherEntity voucher;

  const _ModernVoucherTile({required this.voucher});

  @override
  Widget build(BuildContext context) {
    final isReceipt = voucher.type == VoucherType.receipt;
    final color = isReceipt ? Colors.green.shade700 : Colors.red.shade700;
    final bgColor = isReceipt ? Colors.green.shade50 : Colors.red.shade50;
    final icon = isReceipt ? Icons.download_rounded : Icons.upload_rounded;
    final label = isReceipt ? 'قبض' : 'صرف';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final result = await context.push(
              '/clients-suppliers/voucher',
              extra: voucher,
            );
            if (result == true && context.mounted) {
              context.read<AccountingCubit>().fetchVouchers();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.clientSupplierName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        voucher.voucherNumber,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontFamily: 'Courier',
                        ),
                      ),
                      if (voucher.note.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.notes_rounded,
                              size: 12,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                voucher.note,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Amount & Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      voucher.amount.toStringAsFixed(2),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MM/dd HH:mm').format(voucher.date),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
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
}

class _ClientSelectorSheet extends StatefulWidget {
  final BuildContext parentContext;
  const _ClientSelectorSheet({required this.parentContext});

  @override
  State<_ClientSelectorSheet> createState() => _ClientSelectorSheetState();
}

class _ClientSelectorSheetState extends State<_ClientSelectorSheet> {
  ClientType _selectedType = ClientType.client;

  @override
  Widget build(BuildContext context) {
    final cubit = widget.parentContext.read<ClientSupplierCubit>();
    final primaryColor = Colors.teal;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Handle Bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'اختيار الطرف الثاني',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Tabs
                Row(
                  children: [
                    Expanded(
                      child: _buildTab(
                        'العملاء',
                        ClientType.client,
                        Icons.people,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTab(
                        'الموردين',
                        ClientType.supplier,
                        Icons.local_shipping,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Search
                TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث بالاسم...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (query) {
                    cubit.search(query);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: BlocBuilder<ClientSupplierCubit, cs.ClientSupplierState>(
              bloc: cubit,
              builder: (context, state) {
                return state.maybeWhen(
                  success: (list) {
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد نتائج',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final entity = list[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: primaryColor.withOpacity(0.1),
                              child: Text(
                                entity.name.isNotEmpty
                                    ? entity.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              entity.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              entity.phone,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              final result = await widget.parentContext.push(
                                '/clients-suppliers/voucher',
                                extra: entity,
                              );
                              if (result == true &&
                                  widget.parentContext.mounted) {
                                widget.parentContext
                                    .read<AccountingCubit>()
                                    .fetchVouchers();
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (msg) => Center(child: Text(msg)),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, ClientType type, IconData icon) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        widget.parentContext.read<ClientSupplierCubit>().getList(type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
