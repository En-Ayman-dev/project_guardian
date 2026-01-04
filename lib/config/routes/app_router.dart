import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart'; // للوصول لـ getIt
import '../../core/utils/go_router_refresh_stream.dart'; // الكلاس الجديد
import '../../features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/clients_suppliers/domain/entities/enums/client_type.dart';
import '../../features/clients_suppliers/presentation/pages/client_supplier_form_page.dart';
import '../../features/clients_suppliers/presentation/pages/clients_suppliers_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/domain/entities/product_entity.dart';
import '../../features/inventory/presentation/pages/inventory_settings_page.dart';
import '../../features/inventory/presentation/pages/product_form_page.dart';
import '../../features/inventory/presentation/pages/products_page.dart';
import '../../features/sales/presentation/pages/pos_page.dart';

final goRouter = GoRouter(
  initialLocation: '/home',

  // 1. الاستماع لتغيرات البلوك لإعادة التوجيه التلقائي
  refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),

  redirect: (context, state) {
    // 2. قراءة الحالة الحالية من البلوك المحقون
    final authState = getIt<AuthBloc>().state;

    // 3. التحقق من حالة "الانتظار" (Initial)
    // إذا كانت الحالة مبدئية، لا نتخذ أي قرار (ننتظر Firebase)
    final bool isInitializing = authState.maybeWhen(
      initial: () => true,
      orElse: () => false,
    );
    if (isInitializing) return null;

    // 4. التحقق من حالة تسجيل الدخول
    final bool isLoggedIn = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );

    final bool isLoggingIn = state.matchedLocation == '/login';

    // المنطق: إذا لم يكن مسجلاً ولا يحاول الدخول -> اذهب للدخول
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }

    // المنطق: إذا كان مسجلاً ويحاول الدخول -> ارجعه للرئيسية
    if (isLoggedIn && isLoggingIn) {
      return '/home';
    }

    return null; // لا تغيير
  },

  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const DashboardPage()),
    GoRoute(
      path: '/clients-suppliers',
      builder: (context, state) => const ClientsSuppliersPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) {
            final type = state.extra as ClientType? ?? ClientType.client;
            return ClientSupplierFormPage(type: type);
          },
        ),
      ],
    ),
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
    GoRoute(path: '/pos', builder: (context, state) => const PosPage()),
  ],
);
