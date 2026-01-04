// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/enums/client_type.dart';
import '../manager/client_supplier_cubit.dart';
import '../manager/client_supplier_state.dart';
import '../widgets/client_supplier_tile.dart';

class ClientsSuppliersPage extends StatelessWidget {
  const ClientsSuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ClientSupplierCubit>()..getList(ClientType.client),
      child: const _ClientsSuppliersView(),
    );
  }
}

class _ClientsSuppliersView extends StatefulWidget {
  const _ClientsSuppliersView();

  @override
  State<_ClientsSuppliersView> createState() => _ClientsSuppliersViewState();
}

class _ClientsSuppliersViewState extends State<_ClientsSuppliersView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final type = _tabController.index == 0 ? ClientType.client : ClientType.supplier;
    context.read<ClientSupplierCubit>().getList(type);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients & Suppliers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Clients', icon: Icon(Icons.people)),
            Tab(text: 'Suppliers', icon: Icon(Icons.local_shipping)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final type = _tabController.index == 0 ? ClientType.client : ClientType.supplier;
          // ننتظر عودة المستخدم من صفحة الإضافة لتحديث القائمة
          final result = await context.push('/clients-suppliers/add', extra: type);
          if (result == true && mounted) {
            context.read<ClientSupplierCubit>().getList(type);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ClientSupplierCubit, ClientSupplierState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text(msg, style: const TextStyle(color: Colors.red))),
            success: (list) {
              if (list.isEmpty) {
                return const Center(child: Text('No Data Found'));
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ClientSupplierTile(entity: list[index]);
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}