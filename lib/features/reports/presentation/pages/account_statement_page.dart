import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/pdf_report_service.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../../../clients_suppliers/presentation/manager/client_supplier_cubit.dart';
import '../../../clients_suppliers/presentation/manager/client_supplier_state.dart';
import '../manager/account_statement_cubit.dart';
import '../manager/account_statement_state.dart';

class AccountStatementPage extends StatelessWidget {
  const AccountStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AccountStatementCubit>()),
        BlocProvider(
            create: (context) =>
                getIt<ClientSupplierCubit>()..getList(ClientType.client)),
      ],
      child: const _AccountStatementView(),
    );
  }
}

class _AccountStatementView extends StatefulWidget {
  const _AccountStatementView();

  @override
  State<_AccountStatementView> createState() => _AccountStatementViewState();
}

class _AccountStatementViewState extends State<_AccountStatementView> {
  ClientSupplierEntity? _selectedClient;
  final TextEditingController _searchCtrl = TextEditingController();
  ClientType _searchType = ClientType.client;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onClientSelected(ClientSupplierEntity client) {
    setState(() {
      _selectedClient = client;
      _searchCtrl.text = client.name;
    });
    FocusScope.of(context).unfocus();
    context.read<AccountStatementCubit>().generateStatement(client);
  }

  // [NEW] دالة الطباعة
  Future<void> _printPdf(AccountStatementLoaded state) async {
    if (_selectedClient == null) return;

    final pdfService = getIt<PdfReportService>();
    await pdfService.generateAccountStatementPdf(
      clientName: _selectedClient!.name,
      clientPhone: _selectedClient!.phone,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      rows: state.rows,
      totalDebit: state.totalDebit,
      totalCredit: state.totalCredit,
      finalBalance: state.finalBalance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف حساب تفصيلي'),
        actions: [
          // زر الطباعة
          BlocBuilder<AccountStatementCubit, AccountStatementState>(
            builder: (context, state) {
              if (state is AccountStatementLoaded && _selectedClient != null) {
                return IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () => _printPdf(state),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(context),
          const Divider(height: 1, thickness: 2),
          if (_selectedClient != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.blue.shade50,
              child: Text(
                'العميل: ${_selectedClient!.name} | الهاتف: ${_selectedClient!.phone}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          Expanded(
            child: BlocBuilder<AccountStatementCubit, AccountStatementState>(
              builder: (context, state) {
                if (_selectedClient == null) {
                  return const Center(child: Text('اختر عميلاً لعرض الكشف'));
                }
                if (state is AccountStatementLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AccountStatementError) {
                  return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.red)));
                }
                if (state is AccountStatementLoaded) {
                  if (state.rows.isEmpty) {
                    return const Center(child: Text('لا توجد حركات'));
                  }
                  return _buildDataTable(state);
                }
                return const SizedBox();
              },
            ),
          ),
          BlocBuilder<AccountStatementCubit, AccountStatementState>(
            builder: (context, state) {
              if (state is AccountStatementLoaded && _selectedClient != null) {
                return _buildSummaryFooter(state);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(children: [
            Expanded(child: _buildTypeButton('عملاء', ClientType.client)),
            const SizedBox(width: 10),
            Expanded(child: _buildTypeButton('موردين', ClientType.supplier)),
          ]),
          const SizedBox(height: 12),
          BlocBuilder<ClientSupplierCubit, ClientSupplierState>(
            builder: (context, state) {
              List<ClientSupplierEntity> list = [];
              state.maybeWhen(
                  success: (l) => list = l, orElse: () => list = []);
              return Autocomplete<ClientSupplierEntity>(
                optionsBuilder: (v) {
                  if (v.text.isEmpty) return list;
                  return list.where((c) =>
                      c.name.toLowerCase().contains(v.text.toLowerCase()));
                },
                displayStringForOption: (opt) => opt.name,
                onSelected: _onClientSelected,
                fieldViewBuilder: (ctx, ctrl, focus, submit) {
                  if (_searchCtrl.text != ctrl.text) {
                    ctrl.text = _searchCtrl.text;
                  }
                  return TextField(
                    controller: ctrl,
                    focusNode: focus,
                    decoration: InputDecoration(
                      labelText: 'بحث بالاسم...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: _selectedClient != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _selectedClient = null;
                                  _searchCtrl.clear();
                                  ctrl.clear();
                                });
                              })
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, ClientType type) {
    final isSelected = _searchType == type;
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _searchType = type;
          _selectedClient = null;
          _searchCtrl.clear();
        });
        context.read<ClientSupplierCubit>().getList(type);
      },
      icon: Icon(
          type == ClientType.client ? Icons.person : Icons.local_shipping,
          color: isSelected ? Colors.white : Colors.grey),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.indigo : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildDataTable(AccountStatementLoaded state) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
          columnSpacing: 20,
          border: TableBorder.all(color: Colors.grey.shade300),
          columns: const [
            DataColumn(
                label: Text('التاريخ',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('رقم المستند',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('البيان',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('مدين (+)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green))),
            DataColumn(
                label: Text('دائن (-)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))),
            DataColumn(
                label: Text('الرصيد',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue))),
          ],
          rows: state.rows.map((row) {
            return DataRow(
              cells: [
                DataCell(Text(DateFormat('yyyy-MM-dd').format(row.date))),
                DataCell(Text(row.documentNumber)),
                DataCell(Text(row.description)),
                DataCell(Text(row.debit > 0 ? row.debit.toStringAsFixed(2) : '',
                    style: const TextStyle(color: Colors.green))),
                DataCell(Text(
                    row.credit > 0 ? row.credit.toStringAsFixed(2) : '',
                    style: const TextStyle(color: Colors.red))),
                DataCell(Text(row.balance.toStringAsFixed(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: row.balance >= 0 ? Colors.blue : Colors.red))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryFooter(AccountStatementLoaded state) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem('إجمالي مدين', state.totalDebit, Colors.green),
              _summaryItem('إجمالي دائن', state.totalCredit, Colors.red),
              _summaryItem('الرصيد النهائي', state.finalBalance, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, double value, Color color) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        const SizedBox(height: 4),
        Text(value.toStringAsFixed(2),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
