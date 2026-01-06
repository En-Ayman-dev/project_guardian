import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/manager/auth_bloc/auth_bloc.dart';
import '../manager/dashboard_cubit.dart';
import '../manager/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DashboardCubit>()..loadStats()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(unauthenticated: () => context.go('/login'));
        },
        child: const _DashboardView(),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian ERP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardCubit>().loadStats(),
          ),
        ],
      ),
      drawer: const _DashboardDrawer(),
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardCubit>().loadStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Overview",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 1. Stats Grid
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: LinearProgressIndicator());
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        title: 'Total Sales',
                        value: state.totalSales.toStringAsFixed(2),
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: 'Invoices',
                        value: state.invoiceCount.toString(),
                        icon: Icons.receipt_long,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: 'Clients',
                        value: state.clientsCount.toString(),
                        icon: Icons.people,
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: 'Low Stock',
                        value: state.lowStockCount.toString(),
                        icon: Icons.warning_amber_rounded,
                        color: Colors.red,
                        isAlert: state.lowStockCount > 0,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),
              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 2. Quick Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.point_of_sale, size: 28),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("New Sale"),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                      ),
                      onPressed: () {
                        context.push('/pos').then((_) {
                          if (context.mounted) {
                            context.read<DashboardCubit>().loadStats();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16), // مسافة بين الزرين
                  // --- الزر الجديد: سجل الفواتير ---
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.history, size: 28),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Invoices"),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        elevation: 2,
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ), // إطار ملون
                      ),
                      onPressed: () {
                        context.push('/invoices');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isAlert;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isAlert
            ? const BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 30),
                if (isAlert)
                  const Icon(Icons.error, color: Colors.red, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isAlert ? Colors.red : Colors.black87,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer();

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => bloc.state.mapOrNull(authenticated: (s) => s.user),
    );

    return NavigationDrawer(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(user?.name ?? 'Admin'),
          accountEmail: Text(user?.email ?? ''),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              (user?.email ?? "A").substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Main',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.point_of_sale),
          title: const Text('POS & Sales'),
          onTap: () {
            Navigator.pop(context);
            context.push('/pos');
          },
        ),

        // --- الرابط الجديد في القائمة ---
        ListTile(
          leading: const Icon(Icons.receipt_long), // أيقونة الفواتير
          title: const Text('Invoices History'),
          onTap: () {
            Navigator.pop(context);
            context.push('/invoices'); // الذهاب للصفحة الجديدة
          },
        ),

        // ------------------------------
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Inventory',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.inventory_2),
          title: const Text('Products'),
          onTap: () {
            Navigator.pop(context);
            context.push('/products');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_input_component),
          title: const Text('Categories & Units'),
          onTap: () {
            Navigator.pop(context);
            context.push('/inventory-settings');
          },
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'People',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Clients & Suppliers'),
          onTap: () {
            Navigator.pop(context);
            context.push('/clients-suppliers');
          },
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.pop(context);
            context.read<AuthBloc>().add(const AuthEvent.signedOut());
          },
        ),
      ],
    );
  }
}
