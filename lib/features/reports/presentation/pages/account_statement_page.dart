// [phase_3] correction - Full File
// file: lib/features/reports/presentation/pages/account_statement_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../domain/entities/statement_line_entity.dart';
import '../manager/reports_cubit.dart';
import '../manager/reports_state.dart';

class AccountStatementPage extends StatelessWidget {
  final ClientSupplierEntity clientSupplier;

  const AccountStatementPage({super.key, required this.clientSupplier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ReportsCubit>()
            ..getAccountStatement(clientSupplierId: clientSupplier.id),
      child: _StatementView(clientSupplier: clientSupplier),
    );
  }
}

class _StatementView extends StatefulWidget {
  final ClientSupplierEntity clientSupplier;

  const _StatementView({required this.clientSupplier});

  @override
  State<_StatementView> createState() => _StatementViewState();
}

class _StatementViewState extends State<_StatementView> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    // استخدام MaterialColor للوصول إلى التدرجات (shades)
    const primaryColor = Colors.indigo;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'كشف حساب: ${widget.clientSupplier.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // زر الطباعة / التصدير
          BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              final isLoaded = state.maybeWhen(
                statementLoaded: (_) => true,
                orElse: () => false,
              );

              return IconButton(
                icon: const Icon(Icons.print_rounded),
                tooltip: 'تصدير PDF',
                onPressed: isLoaded
                    ? () {
                        final lines = state.maybeWhen(
                          statementLoaded: (l) => l,
                          orElse: () => <StatementLineEntity>[],
                        );

                        if (lines.isNotEmpty) {
                          context.read<ReportsCubit>().exportStatementToPdf(
                            widget.clientSupplier,
                            lines,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('لا توجد بيانات للطباعة'),
                            ),
                          );
                        }
                      }
                    : null,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Header Background
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor.shade800, primaryColor.shade500],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // --- Date Filters ---
                _buildDateFilters(context),

                const SizedBox(height: 10),

                // --- Report Body ---
                Expanded(
                  child: BlocBuilder<ReportsCubit, ReportsState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        error: (msg) => Center(
                          child: Text(
                            msg,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        statementLoaded: (lines) {
                          // حساب ملخص الحركات (باستثناء الرصيد الافتتاحي لعرض حركة الفترة بدقة)
                          final periodLines = lines.where(
                            (l) => l.description != 'رصيد سابق / افتتاحي',
                          );

                          final totalDebit = periodLines.fold(
                            0.0,
                            (sum, line) => sum + line.debit,
                          );
                          final totalCredit = periodLines.fold(
                            0.0,
                            (sum, line) => sum + line.credit,
                          );

                          // الرصيد النهائي هو رصيد آخر عملية (يشمل الافتتاحي + الحركات)
                          final finalBalance = lines.isNotEmpty
                              ? lines.last.balance
                              : 0.0;

                          return Column(
                            children: [
                              // Summary Card
                              _buildSummaryCard(
                                totalDebit,
                                totalCredit,
                                finalBalance,
                              ),

                              const SizedBox(height: 16),

                              // Transactions List
                              Expanded(
                                child: lines.isEmpty
                                    ? _buildEmptyState()
                                    : ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          20,
                                        ),
                                        itemCount: lines.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 8),
                                        itemBuilder: (context, index) {
                                          return _StatementLineTile(
                                            line: lines[index],
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
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _datePickerButton(
              context,
              label: _startDate == null
                  ? 'من تاريخ'
                  : DateFormat('yyyy-MM-dd').format(_startDate!),
              icon: Icons.calendar_today,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                // استخدام mounted للتحقق قبل استخدام context بعد الـ await
                if (date != null && context.mounted) {
                  setState(() => _startDate = date);
                  _refreshReport(context);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _datePickerButton(
              context,
              label: _endDate == null
                  ? 'إلى تاريخ'
                  : DateFormat('yyyy-MM-dd').format(_endDate!),
              icon: Icons.event,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null && context.mounted) {
                  setState(() => _endDate = date);
                  _refreshReport(context);
                }
              },
            ),
          ),
          if (_startDate != null || _endDate != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                });
                _refreshReport(context);
              },
              // استبدال withOpacity بـ withValues
              icon: Icon(
                Icons.clear,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              tooltip: 'مسح الفلتر',
            ),
        ],
      ),
    );
  }

  Widget _datePickerButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshReport(BuildContext context) {
    context.read<ReportsCubit>().getAccountStatement(
      clientSupplierId: widget.clientSupplier.id,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Widget _buildSummaryCard(double debit, double credit, double balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryItem('إجمالي مدين (فترة)', debit, Colors.black87),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            _buildSummaryItem('إجمالي دائن (فترة)', credit, Colors.black87),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            _buildSummaryItem(
              'الرصيد النهائي',
              balance,
              balance >= 0 ? Colors.green.shade700 : Colors.red.shade700,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    double value,
    Color color, {
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            color: color,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد حركات في هذه الفترة',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _StatementLineTile extends StatelessWidget {
  final StatementLineEntity line;

  const _StatementLineTile({required this.line});

  @override
  Widget build(BuildContext context) {
    // 1. التحقق مما إذا كان السطر هو "رصيد افتتاحي" لعرضه بشكل مميز
    if (line.description == 'رصيد سابق / افتتاحي') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade50, // خلفية صفراء فاتحة للتمييز
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_edu_rounded,
                    color: Colors.amber.shade900,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'رصيد سابق (افتتاحي)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
              Text(
                '${line.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. العرض القياسي للحركات العادية
    final bool isDebit = line.debit > 0;
    final amount = isDebit ? line.debit : line.credit;
    final amountColor = isDebit
        ? Colors.orange.shade800
        : Colors.green.shade700;
    final icon = isDebit
        ? Icons.arrow_outward_rounded
        : Icons.arrow_downward_rounded;
    final iconBg = isDebit ? Colors.orange.shade50 : Colors.green.shade50;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  DateFormat('dd').format(line.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('MM/yy').format(line.date),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: amountColor, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    line.refNumber,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: amountColor,
                  ),
                ),
                Text(
                  'رصيد: ${line.balance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
