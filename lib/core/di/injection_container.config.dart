// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/presentation/manager/auth_bloc/auth_bloc.dart'
    as _i215;
import '../../features/auth/presentation/manager/login_cubit.dart' as _i841;
import '../../features/clients_suppliers/data/datasources/client_supplier_remote_data_source.dart'
    as _i669;
import '../../features/clients_suppliers/data/repositories/client_supplier_repository_impl.dart'
    as _i215;
import '../../features/clients_suppliers/domain/repositories/client_supplier_repository.dart'
    as _i162;
import '../../features/clients_suppliers/domain/usecases/add_client_supplier_usecase.dart'
    as _i941;
import '../../features/clients_suppliers/domain/usecases/get_clients_suppliers_usecase.dart'
    as _i39;
import '../../features/clients_suppliers/presentation/manager/client_supplier_cubit.dart'
    as _i586;
import '../../features/dashboard/presentation/manager/dashboard_cubit.dart'
    as _i629;
import '../../features/inventory/data/datasources/inventory_remote_data_source.dart'
    as _i248;
import '../../features/inventory/data/datasources/product_remote_data_source.dart'
    as _i365;
import '../../features/inventory/data/repositories/inventory_repository_impl.dart'
    as _i572;
import '../../features/inventory/data/repositories/product_repository_impl.dart'
    as _i777;
import '../../features/inventory/domain/repositories/inventory_repository.dart'
    as _i422;
import '../../features/inventory/domain/repositories/product_repository.dart'
    as _i437;
import '../../features/inventory/domain/usecases/add_category_usecase.dart'
    as _i811;
import '../../features/inventory/domain/usecases/add_product_usecase.dart'
    as _i234;
import '../../features/inventory/domain/usecases/add_unit_usecase.dart'
    as _i415;
import '../../features/inventory/domain/usecases/delete_category_usecase.dart'
    as _i723;
import '../../features/inventory/domain/usecases/delete_product_usecase.dart'
    as _i789;
import '../../features/inventory/domain/usecases/delete_unit_usecase.dart'
    as _i630;
import '../../features/inventory/domain/usecases/get_categories_usecase.dart'
    as _i815;
import '../../features/inventory/domain/usecases/get_products_usecase.dart'
    as _i340;
import '../../features/inventory/domain/usecases/get_units_usecase.dart'
    as _i935;
import '../../features/inventory/domain/usecases/update_category_usecase.dart'
    as _i351;
import '../../features/inventory/domain/usecases/update_product_usecase.dart'
    as _i855;
import '../../features/inventory/domain/usecases/update_unit_usecase.dart'
    as _i457;
import '../../features/inventory/presentation/manager/inventory_settings_cubit.dart'
    as _i506;
import '../../features/inventory/presentation/manager/product_cubit.dart'
    as _i445;
import '../../features/sales/data/datasources/sales_remote_data_source.dart'
    as _i37;
import '../../features/sales/data/repositories/sales_repository_impl.dart'
    as _i779;
import '../../features/sales/domain/repositories/sales_repository.dart'
    as _i434;
import '../../features/sales/domain/usecases/add_invoice_usecase.dart' as _i61;
import '../../features/sales/domain/usecases/delete_invoice_usecase.dart'
    as _i661;
import '../../features/sales/domain/usecases/get_invoices_usecase.dart'
    as _i163;
import '../../features/sales/domain/usecases/update_invoice_usecase.dart'
    as _i1014;
import '../../features/sales/presentation/manager/invoices_list_cubit.dart'
    as _i1069;
import '../../features/sales/presentation/manager/sales_cubit.dart' as _i740;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i248.InventoryRemoteDataSource>(
      () => _i248.InventoryRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i365.ProductRemoteDataSource>(
      () => _i365.ProductRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i669.ClientSupplierRemoteDataSource>(
      () => _i669.ClientSupplierRemoteDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i37.SalesRemoteDataSource>(
      () => _i37.SalesRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i162.ClientSupplierRepository>(
      () => _i215.ClientSupplierRepositoryImpl(
        gh<_i669.ClientSupplierRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i437.ProductRepository>(
      () => _i777.ProductRepositoryImpl(gh<_i365.ProductRemoteDataSource>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i941.AddClientSupplierUseCase>(
      () =>
          _i941.AddClientSupplierUseCase(gh<_i162.ClientSupplierRepository>()),
    );
    gh.lazySingleton<_i39.GetClientsSuppliersUseCase>(
      () =>
          _i39.GetClientsSuppliersUseCase(gh<_i162.ClientSupplierRepository>()),
    );
    gh.lazySingleton<_i422.InventoryRepository>(
      () =>
          _i572.InventoryRepositoryImpl(gh<_i248.InventoryRemoteDataSource>()),
    );
    gh.lazySingleton<_i811.AddCategoryUseCase>(
      () => _i811.AddCategoryUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i415.AddUnitUseCase>(
      () => _i415.AddUnitUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i723.DeleteCategoryUseCase>(
      () => _i723.DeleteCategoryUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i630.DeleteUnitUseCase>(
      () => _i630.DeleteUnitUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i815.GetCategoriesUseCase>(
      () => _i815.GetCategoriesUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i935.GetUnitsUseCase>(
      () => _i935.GetUnitsUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i351.UpdateCategoryUseCase>(
      () => _i351.UpdateCategoryUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i457.UpdateUnitUseCase>(
      () => _i457.UpdateUnitUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i586.ClientSupplierCubit>(
      () => _i586.ClientSupplierCubit(
        gh<_i39.GetClientsSuppliersUseCase>(),
        gh<_i941.AddClientSupplierUseCase>(),
      ),
    );
    gh.factory<_i506.InventorySettingsCubit>(
      () => _i506.InventorySettingsCubit(
        gh<_i815.GetCategoriesUseCase>(),
        gh<_i811.AddCategoryUseCase>(),
        gh<_i723.DeleteCategoryUseCase>(),
        gh<_i935.GetUnitsUseCase>(),
        gh<_i415.AddUnitUseCase>(),
        gh<_i630.DeleteUnitUseCase>(),
        gh<_i351.UpdateCategoryUseCase>(),
        gh<_i457.UpdateUnitUseCase>(),
      ),
    );
    gh.lazySingleton<_i234.AddProductUseCase>(
      () => _i234.AddProductUseCase(gh<_i437.ProductRepository>()),
    );
    gh.lazySingleton<_i789.DeleteProductUseCase>(
      () => _i789.DeleteProductUseCase(gh<_i437.ProductRepository>()),
    );
    gh.lazySingleton<_i340.GetProductsUseCase>(
      () => _i340.GetProductsUseCase(gh<_i437.ProductRepository>()),
    );
    gh.lazySingleton<_i855.UpdateProductUseCase>(
      () => _i855.UpdateProductUseCase(gh<_i437.ProductRepository>()),
    );
    gh.lazySingleton<_i434.SalesRepository>(
      () => _i779.SalesRepositoryImpl(gh<_i37.SalesRemoteDataSource>()),
    );
    gh.factory<_i445.ProductCubit>(
      () => _i445.ProductCubit(
        gh<_i340.GetProductsUseCase>(),
        gh<_i234.AddProductUseCase>(),
        gh<_i855.UpdateProductUseCase>(),
        gh<_i789.DeleteProductUseCase>(),
      ),
    );
    gh.factory<_i629.DashboardCubit>(
      () => _i629.DashboardCubit(
        gh<_i434.SalesRepository>(),
        gh<_i437.ProductRepository>(),
        gh<_i162.ClientSupplierRepository>(),
      ),
    );
    gh.factory<_i841.LoginCubit>(
      () => _i841.LoginCubit(gh<_i188.LoginUseCase>()),
    );
    gh.lazySingleton<_i215.AuthBloc>(
      () => _i215.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i61.AddInvoiceUseCase>(
      () => _i61.AddInvoiceUseCase(gh<_i434.SalesRepository>()),
    );
    gh.lazySingleton<_i661.DeleteInvoiceUseCase>(
      () => _i661.DeleteInvoiceUseCase(gh<_i434.SalesRepository>()),
    );
    gh.lazySingleton<_i163.GetInvoicesUseCase>(
      () => _i163.GetInvoicesUseCase(gh<_i434.SalesRepository>()),
    );
    gh.lazySingleton<_i1014.UpdateInvoiceUseCase>(
      () => _i1014.UpdateInvoiceUseCase(gh<_i434.SalesRepository>()),
    );
    gh.factory<_i1069.InvoicesListCubit>(
      () => _i1069.InvoicesListCubit(
        gh<_i163.GetInvoicesUseCase>(),
        gh<_i661.DeleteInvoiceUseCase>(),
      ),
    );
    gh.factory<_i740.SalesCubit>(
      () => _i740.SalesCubit(
        gh<_i61.AddInvoiceUseCase>(),
        gh<_i1014.UpdateInvoiceUseCase>(),
        gh<_i340.GetProductsUseCase>(),
        gh<_i39.GetClientsSuppliersUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
