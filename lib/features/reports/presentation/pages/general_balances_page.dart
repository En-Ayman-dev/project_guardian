// [phase_2] creation
// file: lib/features/reports/presentation/pages/general_balances_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../manager/general_balances_cubit.dart';
import '../manager/general_balances_state.dart';

class GeneralBalancesPage extends StatelessWidget {
  const GeneralBalancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GeneralBalancesCubit>()..loadBalances(),
      child: const _GeneralBalancesView(),
    );
  }
}

class _GeneralBalancesView extends StatelessWidget {
  const _GeneralBalancesView();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('الأرصدة العامة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          BlocBuilder<GeneralBalancesCubit, GeneralBalancesState>(
            builder: (context, state) {
              final isLoaded = state.maybeWhen(loaded: (_, __, ___, ____) => true, orElse: () => false);
              return IconButton(
                icon: const Icon(Icons.print_rounded, color: Colors.white),
                onPressed: isLoaded ? () => context.read<GeneralBalancesCubit>().exportToPdf() : null,
                tooltip: 'طباعة التقرير',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor.shade800, primaryColor.shade400],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Summary Cards
                BlocBuilder<GeneralBalancesCubit, GeneralBalancesState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (_, __, receivable, payable) => _buildSummaryRow(receivable, payable),
                      orElse: () => const SizedBox(height: 100), // Placeholder
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Search & Filter
                _buildSearchBar(context),

                const SizedBox(height: 10),

                // List
                Expanded(
                  child: BlocBuilder<GeneralBalancesCubit, GeneralBalancesState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                        error: (msg) => Center(child: Text(msg, style: const TextStyle(color: Colors.red))),
                        loaded: (_, filtered, __, ___) {
                          if (filtered.isEmpty) {
                            return _buildEmptyState();
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: filtered.length,
                              separatorBuilder: (ctx, i) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                return _BalanceTile(entity: filtered[index]);
                              },
                            ),
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(double receivable, double payable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'لنا (مديونيات)',
              receivable,
              Colors.green,
              Icons.arrow_circle_down_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'علينا (التزامات)',
              payable,
              Colors.red,
              Icons.arrow_circle_up_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (val) => context.read<GeneralBalancesCubit>().search(val),
        decoration: InputDecoration(
          hintText: 'بحث عن عميل أو مورد...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final ClientSupplierEntity entity;

  const _BalanceTile({required this.entity});

  @override
  Widget build(BuildContext context) {
    final isClient = entity.type == ClientType.client;
    // تحديد لون الرصيد وحالته
    Color balanceColor;
    String statusLabel;
    
    if (entity.balance == 0) {
      balanceColor = Colors.grey;
      statusLabel = 'متزن';
    } else {
      // إذا عميل وموجب (لنا) -> أخضر، سالب (له) -> أحمر
      // إذا مورد وموجب (عليه/لنا) -> أخضر، سالب (له/علينا) -> أحمر
      // (حسب المنطق الموحد في الكيوبت: موجب = لنا، سالب = علينا)
      if (isClient) {
         balanceColor = entity.balance > 0 ? Colors.green.shade700 : Colors.red.shade700;
         statusLabel = entity.balance > 0 ? 'مدين' : 'دائن';
      } else {
         // المورد عكس العميل عادة في التسمية لكن كرقم في النظام:
         // اذا موجب (دين علينا) -> أحمر
         balanceColor = entity.balance > 0 ? Colors.red.shade700 : Colors.green.shade700;
         statusLabel = entity.balance > 0 ? 'دائن' : 'مدين';
      }
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isClient ? Colors.blue.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        child: Icon(
          isClient ? Icons.person : Icons.local_shipping,
          color: isClient ? Colors.blue : Colors.orange,
          size: 20,
        ),
      ),
      title: Text(entity.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        entity.phone.isNotEmpty ? entity.phone : 'لا يوجد هاتف',
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            entity.balance.abs().toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: balanceColor,
            ),
          ),
          Text(
            statusLabel,
            style: TextStyle(fontSize: 10, color: balanceColor.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}