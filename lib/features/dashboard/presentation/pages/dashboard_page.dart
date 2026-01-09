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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: const _DashboardView(),
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Colors.grey[50];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'نظام جارديان (ERP)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<DashboardCubit>().loadStats(),
          ),
        ],
      ),
      drawer: const _ModernDrawer(),
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadStats(),
            color: primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _WelcomeHeader(),
                  const SizedBox(height: 20),

                  BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ModernStatCard(
                                  title: 'إجمالي المبيعات',
                                  value:
                                      '${state.totalSales.toStringAsFixed(2)} \$',
                                  icon: Icons.attach_money,
                                  color1: const Color(0xFF11998e),
                                  color2: const Color(0xFF38ef7d),
                                  isCurrency: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ModernStatCard(
                                  title: 'عدد الفواتير',
                                  value: state.invoiceCount.toString(),
                                  icon: Icons.receipt_long_rounded,
                                  color1: const Color(0xFF2193b0),
                                  color2: const Color(0xFF6dd5ed),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ModernStatCard(
                                  title: 'العملاء والموردين',
                                  value: state.clientsCount.toString(),
                                  icon: Icons.people_alt_rounded,
                                  color1: const Color(0xFFff9966),
                                  color2: const Color(0xFFff5e62),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ModernStatCard(
                                  title: 'نواقص المخزون',
                                  value: state.lowStockCount.toString(),
                                  icon: Icons.warning_amber_rounded,
                                  color1: const Color(0xFFeb3349),
                                  color2: const Color(0xFFf45c43),
                                  isAlert: state.lowStockCount > 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      "الوصول السريع",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _QuickActionTile(
                        icon: Icons.point_of_sale_rounded,
                        label: "نقطة بيع",
                        color: Colors.blue.shade700,
                        onTap: () {
                          context.push('/pos').then((_) {
                            if (context.mounted) {
                              context.read<DashboardCubit>().loadStats();
                            }
                          });
                        },
                      ),
                      _QuickActionTile(
                        icon: Icons.receipt_rounded,
                        label: "الفواتير",
                        color: Colors.indigo,
                        onTap: () => context.push('/invoices'),
                      ),
                      _QuickActionTile(
                        icon: Icons.account_balance_wallet_rounded,
                        label: "السندات المالية",
                        color: Colors.teal,
                        onTap: () => context.push('/vouchers'),
                      ),
                      _QuickActionTile(
                        icon: Icons.people_rounded,
                        label: "العملاء",
                        color: Colors.orange.shade800,
                        onTap: () => context.push('/clients-suppliers'),
                      ),
                      _QuickActionTile(
                        icon: Icons.inventory_2_rounded,
                        label: "المنتجات",
                        color: Colors.purple,
                        onTap: () => context.push('/products'),
                      ),
                      // [NEW] زر التقارير الجديد
                      _QuickActionTile(
                        icon: Icons.bar_chart_rounded, // أيقونة معبرة
                        label: "التقارير",
                        color: const Color(0xFF607D8B), // Blue Grey
                        onTap: () => context.push('/reports'),
                      ),
                      _QuickActionTile(
                        icon: Icons.settings_rounded,
                        label: "الإعدادات",
                        color: Colors.grey.shade700,
                        onTap: () => context.push('/inventory-settings'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Widgets مساعدة بتصميم عصري (تم إصلاح الأخطاء هنا)
// -----------------------------------------------------------------------------

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => bloc.state.mapOrNull(authenticated: (s) => s.user),
    );

    // [FIX] التعامل الآمن مع الاسم الفارغ لتجنب RangeError
    String displayName = 'مسؤول النظام';
    String firstChar = 'م';

    if (user?.name != null && user!.name.trim().isNotEmpty) {
      displayName = user.name;
      firstChar = displayName.substring(0, 1).toUpperCase();
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Text(
            firstChar,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "مرحباً بك،",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color1;
  final Color color2;
  final bool isCurrency;
  final bool isAlert;

  const _ModernStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color1,
    required this.color2,
    this.isCurrency = false,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color1.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 80,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isAlert)
                      const Icon(
                        Icons.circle,
                        color: Colors.yellowAccent,
                        size: 10,
                      ),
                  ],
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernDrawer extends StatelessWidget {
  const _ModernDrawer();

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => bloc.state.mapOrNull(authenticated: (s) => s.user),
    );

    // [FIX] التعامل الآمن مع البريد الإلكتروني الفارغ
    String emailChar = 'A';
    if (user?.email != null && user!.email.isNotEmpty) {
      emailChar = user.email.substring(0, 1).toUpperCase();
    }

    return NavigationDrawer(
      backgroundColor: Colors.white,
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Colors.blueAccent],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          accountName: Text(
            user?.name ?? 'مدير النظام',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          accountEmail: Text(user?.email ?? ''),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              emailChar,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _DrawerSectionTitle('الرئيسية'),
              _DrawerItem(
                icon: Icons.dashboard_rounded,
                title: 'لوحة التحكم',
                onTap: () => Navigator.pop(context),
                isSelected: true,
              ),
              _DrawerItem(
                icon: Icons.point_of_sale_rounded,
                title: 'نقطة البيع (POS)',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/pos');
                },
              ),
              _DrawerItem(
                icon: Icons.receipt_long_rounded,
                title: 'سجل الفواتير',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/invoices');
                },
              ),

              const Divider(height: 30),
              _DrawerSectionTitle('الإدارة المالية'),
              _DrawerItem(
                icon: Icons.account_balance_wallet_rounded,
                title: 'السندات المالية',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/vouchers');
                },
              ),

              const Divider(height: 30),
              _DrawerSectionTitle('المخزون والشركاء'),
              _DrawerItem(
                icon: Icons.inventory_2_rounded,
                title: 'المنتجات',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/products');
                },
              ),
              _DrawerItem(
                icon: Icons.category_rounded,
                title: 'التصنيفات والوحدات',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/inventory-settings');
                },
              ),
              _DrawerItem(
                icon: Icons.people_alt_rounded,
                title: 'العملاء والموردين',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/clients-suppliers');
                },
              ),

              const Divider(height: 30),
              _DrawerItem(
                icon: Icons.logout_rounded,
                title: 'تسجيل الخروج',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(const AuthEvent.signedOut());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String title;
  const _DrawerSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.red
        : (isSelected ? Theme.of(context).primaryColor : Colors.black87);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
