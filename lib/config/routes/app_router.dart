// [phase_2] modification
// file: lib/config/routes/app_router.dart

import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/go_router_refresh_stream.dart';
import '../../features/accounting/domain/entities/voucher_entity.dart';
import '../../features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../features/clients_suppliers/domain/entities/enums/client_type.dart';
import '../../features/clients_suppliers/presentation/pages/client_supplier_details_page.dart';
import '../../features/clients_suppliers/presentation/pages/client_supplier_form_page.dart';
import '../../features/clients_suppliers/presentation/pages/clients_suppliers_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/domain/entities/product_entity.dart';
import '../../features/inventory/presentation/pages/inventory_settings_page.dart';
import '../../features/inventory/presentation/pages/product_form_page.dart';
import '../../features/inventory/presentation/pages/products_page.dart';
import '../../features/reports/presentation/pages/daily_report_page.dart';
import '../../features/reports/presentation/pages/general_balances_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/sales/presentation/pages/pos_page.dart';
import '../../features/sales/presentation/pages/invoices_list_page.dart';
import '../../features/accounting/presentation/pages/voucher_form_page.dart';
import '../../features/accounting/presentation/pages/vouchers_list_page.dart';
import '../../features/reports/presentation/pages/account_statement_page.dart';
// [NEW] استيراد صفحة تقرير حركة الأصناف
import '../../features/reports/presentation/pages/item_movement_report_page.dart';

final goRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
  redirect: (context, state) {
    final authState = getIt<AuthBloc>().state;
    final bool isInitializing = authState.maybeWhen(
      initial: () => true,
      orElse: () => false,
    );
    if (isInitializing) return null;

    final bool isLoggedIn = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    final bool isLoggingIn = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoggingIn) return '/login';
    if (isLoggedIn && isLoggingIn) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const DashboardPage()),

    // --- المبيعات والفواتير ---
    GoRoute(
      path: '/invoices',
      builder: (context, state) => const InvoicesListPage(),
    ),
    GoRoute(path: '/pos', builder: (context, state) => const PosPage()),

    // --- المحاسبة والسندات ---
    GoRoute(
      path: '/vouchers',
      builder: (context, state) => const VouchersListPage(),
    ),

    // --- التقارير ---
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsPage(),
    ),
    GoRoute(
      path: '/reports/general-balances',
      builder: (context, state) => const GeneralBalancesPage(),
    ),
    GoRoute(
      path: '/reports/statement',
      builder: (context, state) {
        // [UPDATED] لا ننتظر أي معامل، الصفحة تدير نفسها بنفسها
        return const AccountStatementPage();
      },
    ),
    GoRoute(
      path: '/reports/daily-sales',
      builder: (context, state) => const DailyReportPage(),
    ),
    // [NEW] مسار تقرير حركة الأصناف
    GoRoute(
      path: '/reports/item-movement',
      builder: (context, state) => const ItemMovementReportPage(),
    ),

    // --- العملاء والموردين ---
    GoRoute(
      path: '/clients-suppliers',
      builder: (context, state) => const ClientsSuppliersPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) {
            if (state.extra is ClientSupplierEntity) {
              final entity = state.extra as ClientSupplierEntity;
              return ClientSupplierFormPage(
                type: entity.type,
                clientToEdit: entity,
              );
            }
            final type = state.extra as ClientType? ?? ClientType.client;
            return ClientSupplierFormPage(type: type);
          },
        ),
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final entity = state.extra as ClientSupplierEntity;
            return ClientSupplierDetailsPage(entity: entity);
          },
        ),
        GoRoute(
          path: 'voucher',
          builder: (context, state) {
            if (state.extra is VoucherEntity) {
              final voucher = state.extra as VoucherEntity;
              final mockClient = ClientSupplierEntity(
                id: voucher.clientSupplierId,
                name: voucher.clientSupplierName,
                type: voucher.type == VoucherType.receipt
                    ? ClientType.client
                    : ClientType.supplier,
                phone: '',
                email: '',
                address: '',
                taxNumber: '',
                createdAt: DateTime.now(),
                balance: 0.0,
              );
              return VoucherFormPage(
                clientSupplier: mockClient,
                voucherToEdit: voucher,
              );
            }
            final entity = state.extra as ClientSupplierEntity;
            return VoucherFormPage(clientSupplier: entity);
          },
        ),
      ],
    ),

    // --- المخزون ---
    GoRoute(
      path: '/inventory-settings',
      builder: (context, state) => const InventorySettingsPage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) {
            final productToEdit = state.extra as ProductEntity?;
            return ProductFormPage(productToEdit: productToEdit);
          },
        ),
      ],
    ),
  ],
);
