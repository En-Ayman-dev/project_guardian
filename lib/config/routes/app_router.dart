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
import '../../features/sales/presentation/pages/pos_page.dart';
import '../../features/sales/presentation/pages/invoices_list_page.dart';
// استيراد صفحات المحاسبة
import '../../features/accounting/presentation/pages/voucher_form_page.dart';
import '../../features/accounting/presentation/pages/vouchers_list_page.dart'; // [NEW]

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

    // --- المحاسبة والسندات [NEW] ---
    GoRoute(
      path: '/vouchers',
      builder: (context, state) => const VouchersListPage(),
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
            // الحالة 1: تعديل سند موجود
            if (state.extra is VoucherEntity) {
              final voucher = state.extra as VoucherEntity;
              // نقوم بإنشاء كيان عميل "مؤقت" فقط لغرض العرض في الواجهة (الاسم والنوع)
              // لأن صفحة الفورم تتطلب كائن عميل
              final mockClient = ClientSupplierEntity(
                id: voucher.clientSupplierId,
                name: voucher.clientSupplierName,
                // استنتاج النوع من نوع السند
                type: voucher.type == VoucherType.receipt ? ClientType.client : ClientType.supplier,
                phone: '', // بيانات غير ضرورية للتعديل
                email: '',
                address: '',
                taxNumber: '',
                createdAt: DateTime.now(),
                balance: 0.0,
              );
              return VoucherFormPage(clientSupplier: mockClient, voucherToEdit: voucher);
            }
            
            // الحالة 2: إنشاء سند جديد
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
