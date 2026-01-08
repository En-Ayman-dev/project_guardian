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
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل السندات المالية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AccountingCubit>().fetchVouchers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showClientSelector(context),
        label: const Text('سند جديد'),
        icon: const Icon(Icons.add),
      ),
      body: BlocBuilder<AccountingCubit, AccountingState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(
              child: Text(msg, style: const TextStyle(color: Colors.red)),
            ),
            loaded: (vouchers) {
              if (vouchers.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text('لا توجد سندات مسجلة بعد'),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: vouchers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _VoucherTile(voucher: vouchers[index]);
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _showClientSelector(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ClientSelectorSheet(parentContext: parentContext),
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

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'اختر الطرف الثاني (عميل / مورد)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SegmentedButton<ClientType>(
                segments: const [
                  ButtonSegment(
                    value: ClientType.client,
                    label: Text('العملاء'),
                    icon: Icon(Icons.people),
                  ),
                  ButtonSegment(
                    value: ClientType.supplier,
                    label: Text('الموردين'),
                    icon: Icon(Icons.local_shipping),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<ClientType> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                  cubit.getList(_selectedType);
                },
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث بالاسم أو الرقم...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (query) {
                  cubit.search(query);
                },
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: BlocBuilder<ClientSupplierCubit, cs.ClientSupplierState>(
                bloc: cubit,
                builder: (context, state) {
                  return state.maybeWhen(
                    success: (list) {
                      if (list.isEmpty) {
                        return const Center(child: Text('لا توجد نتائج'));
                      }
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final entity = list[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                entity.name.isNotEmpty
                                    ? entity.name[0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(entity.name),
                            subtitle: Text(entity.phone),
                            onTap: () async {
                              Navigator.pop(context);
                              final result = await widget.parentContext.push(
                                '/clients-suppliers/voucher',
                                extra: entity,
                              );
                              if (result == true) {
                                if (widget.parentContext.mounted) {
                                  widget.parentContext
                                      .read<AccountingCubit>()
                                      .fetchVouchers();
                                }
                              }
                            },
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
      ),
    );
  }
}

class _VoucherTile extends StatelessWidget {
  final VoucherEntity voucher;

  const _VoucherTile({required this.voucher});

  @override
  Widget build(BuildContext context) {
    final isReceipt = voucher.type == VoucherType.receipt;
    final color = isReceipt ? Colors.green : Colors.red;
    final icon = isReceipt ? Icons.download : Icons.upload;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // [NEW] تفعيل النقر للتعديل
        onTap: () async {
          // نمرر السند نفسه، والراوتر سيتولى تجهيز صفحة التعديل
          final result = await context.push(
            '/clients-suppliers/voucher',
            extra: voucher,
          );
          if (result == true) {
            // تحديث القائمة في حال تم التعديل أو الحذف
            if (context.mounted) {
              context.read<AccountingCubit>().fetchVouchers();
            }
          }
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                voucher.clientSupplierName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              voucher.amount.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  isReceipt ? 'سند قبض' : 'سند صرف',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(voucher.date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            if (voucher.note.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                voucher.note,
                style: TextStyle(color: Colors.grey[800], fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
