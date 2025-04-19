import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:inyecdiesel_eco/core/config/app_router.dart';
import 'package:inyecdiesel_eco/core/network/dio_client.dart';
import 'package:inyecdiesel_eco/core/network/network_info.dart';
import 'package:inyecdiesel_eco/core/utils/whatsapp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports para Auth
import 'package:inyecdiesel_eco/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:inyecdiesel_eco/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:inyecdiesel_eco/features/auth/domain/repositories/auth_repository.dart';
import 'package:inyecdiesel_eco/features/auth/domain/usecases/login.dart';
import 'package:inyecdiesel_eco/features/auth/domain/usecases/logout.dart';
import 'package:inyecdiesel_eco/features/auth/domain/usecases/check_auth.dart';
import 'package:inyecdiesel_eco/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inyecdiesel_eco/features/auth/presentation/bloc/login_form_bloc.dart';

// Imports para Products
import 'package:inyecdiesel_eco/features/products/data/datasources/product_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/products/data/datasources/product_local_data_source.dart';
import 'package:inyecdiesel_eco/features/products/data/repositories/product_repository_impl.dart';
import 'package:inyecdiesel_eco/features/products/domain/repositories/product_repository.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_products.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_product_by_id.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_products_by_category.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/search_products.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_bloc.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/product_detail_bloc.dart';

// Imports para Cart
import 'package:inyecdiesel_eco/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:inyecdiesel_eco/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/get_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/add_to_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/update_cart_item.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/clear_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/checkout_cart.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_bloc.dart';

// Imports para Orders
import 'package:inyecdiesel_eco/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/orders/data/datasources/order_local_data_source.dart';
import 'package:inyecdiesel_eco/features/orders/data/repositories/order_repository_impl.dart';
import 'package:inyecdiesel_eco/features/orders/domain/repositories/order_repository.dart';
import 'package:inyecdiesel_eco/features/orders/domain/usecases/get_orders.dart';
import 'package:inyecdiesel_eco/features/orders/domain/usecases/get_order_by_id.dart';
import 'package:inyecdiesel_eco/features/orders/domain/usecases/cancel_order.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/order_detail_bloc.dart';

// Imports para Shipping
import 'package:inyecdiesel_eco/features/shipping/data/datasources/shipping_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/shipping/data/datasources/shipping_local_data_source.dart';
import 'package:inyecdiesel_eco/features/shipping/data/repositories/shipping_repository_impl.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/get_shippings.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/get_shipping_by_id.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/create_shipping.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/update_shipping.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/update_shipping_status.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_bloc.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_detail_bloc.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_form_bloc.dart';

// Imports para Admin
import 'package:inyecdiesel_eco/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/admin/data/datasources/admin_local_data_source.dart';
import 'package:inyecdiesel_eco/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/get_dashboard_stats.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/get_analytics.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/get_sales_report.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/get_inventory_alerts.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/manage_product.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/bloc/admin_analytics_bloc.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/bloc/admin_products_bloc.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/bloc/admin_orders_bloc.dart';

final getIt = GetIt.instance;

/// Initialize app dependencies
Future<void> initDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
  getIt.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Dio client
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt()));

  // Repositories
  initAuthDependencies();
  initProductDependencies();
  initCartDependencies();
  initOrderDependencies();
  initAdminDependencies();
  initShippingDependencies();
  void initAdminDependencies() {
    // Data sources
    getIt.registerLazySingleton<AdminRemoteDataSource>(
            () => AdminRemoteDataSourceImpl(client: getIt<DioClient>())
    );

    getIt.registerLazySingleton<AdminLocalDataSource>(
            () => AdminLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>())
    );

    // Repository
    getIt.registerLazySingleton<AdminRepository>(
            () => AdminRepositoryImpl(
          remoteDataSource: getIt<AdminRemoteDataSource>(),
          localDataSource: getIt<AdminLocalDataSource>(),
          networkInfo: getIt<NetworkInfo>(),
        )
    );

    // Use cases
    getIt.registerLazySingleton<GetDashboardStats>(
            () => GetDashboardStats(getIt<AdminRepository>())
    );

    getIt.registerLazySingleton<GetAnalytics>(
            () => GetAnalytics(getIt<AdminRepository>())
    );

    getIt.registerLazySingleton<GetSalesReport>(
            () => GetSalesReport(getIt<AdminRepository>())
    );

    getIt.registerLazySingleton<GetInventoryAlerts>(
            () => GetInventoryAlerts(getIt<AdminRepository>())
    );

    getIt.registerLazySingleton<ManageProduct>(
            () => ManageProduct(getIt<AdminRepository>())
    );

    // BLoCs
    getIt.registerFactory<AdminDashboardBloc>(
            () => AdminDashboardBloc(
          getDashboardStats: getIt<GetDashboardStats>(),
          getInventoryAlerts: getIt<GetInventoryAlerts>(),
        )
    );

    getIt.registerFactory<AdminAnalyticsBloc>(
            () => AdminAnalyticsBloc(
          getAnalytics: getIt<GetAnalytics>(),
          getSalesReport: getIt<GetSalesReport>(),
        )
    );

    getIt.registerFactory<AdminProductsBloc>(
            () => AdminProductsBloc(
          getProducts: getIt<GetProducts>(),
          manageProduct: getIt<ManageProduct>(),
        )
    );

    getIt.registerFactory<AdminOrdersBloc>(
            () => AdminOrdersBloc(
          getOrders: getIt<GetOrders>(),
        )
    );
    void initShippingDependencies() {
      // Data sources
      getIt.registerLazySingleton<ShippingRemoteDataSource>(
              () => ShippingRemoteDataSourceImpl(client: getIt<DioClient>())
      );

      getIt.registerLazySingleton<ShippingLocalDataSource>(
              () => ShippingLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>())
      );

      // Repository
      getIt.registerLazySingleton<ShippingRepository>(
              () => ShippingRepositoryImpl(
            remoteDataSource: getIt<ShippingRemoteDataSource>(),
            localDataSource: getIt<ShippingLocalDataSource>(),
            networkInfo: getIt<NetworkInfo>(),
          )
      );

      // Use cases
      getIt.registerLazySingleton<GetShippings>(
              () => GetShippings(getIt<ShippingRepository>())
      );

      getIt.registerLazySingleton<GetShippingById>(
              () => GetShippingById(getIt<ShippingRepository>())
      );

      getIt.registerLazySingleton<CreateShipping>(
              () => CreateShipping(getIt<ShippingRepository>())
      );

      getIt.registerLazySingleton<UpdateShipping>(
              () => UpdateShipping(getIt<ShippingRepository>())
      );

      getIt.registerLazySingleton<UpdateShippingStatus>(
              () => UpdateShippingStatus(getIt<ShippingRepository>())
      );

      // BLoC
      getIt.registerFactory<ShippingBloc>(
              () => ShippingBloc(
            getShippings: getIt<GetShippings>(),
          )
      );

      getIt.registerFactory<ShippingDetailBloc>(
              () => ShippingDetailBloc(
            getShippingById: getIt<GetShippingById>(),
            updateShippingStatus: getIt<UpdateShippingStatus>(),
          )
      );

      getIt.registerFactory<ShippingFormBloc>(
              () => ShippingFormBloc(
            createShipping: getIt<CreateShipping>(),
            updateShipping: getIt<UpdateShipping>(),
          )
      );
    }

    void initAuthDependencies() {
      // Data sources
      getIt.registerLazySingleton<AuthRemoteDataSource>(
              () => AuthRemoteDataSourceImpl(client: getIt<DioClient>())
      );

      getIt.registerLazySingleton<AuthLocalDataSource>(
              () => AuthLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>())
      );

      // Repository
      getIt.registerLazySingleton<AuthRepository>(
              () => AuthRepositoryImpl(
            remoteDataSource: getIt<AuthRemoteDataSource>(),
            localDataSource: getIt<AuthLocalDataSource>(),
            networkInfo: getIt<NetworkInfo>(),
          )
      );

      // Use cases
      getIt.registerLazySingleton<Login>(
              () => Login(getIt<AuthRepository>())
      );

      getIt.registerLazySingleton<Logout>(
              () => Logout(getIt<AuthRepository>())
      );

      getIt.registerLazySingleton<CheckAuth>(
              () => CheckAuth(getIt<AuthRepository>())
      );

      // BLoC
      getIt.registerFactory<AuthBloc>(
              () => AuthBloc(
            login: getIt<Login>(),
            logout: getIt<Logout>(),
            checkAuth: getIt<CheckAuth>(),
          )
      );

      getIt.registerFactory<LoginFormBloc>(
              () => LoginFormBloc(
            login: getIt<Login>(),
          )
      );
    }

    void initProductDependencies() {
      // Data sources
      getIt.registerLazySingleton<ProductRemoteDataSource>(
              () => ProductRemoteDataSourceImpl(client: getIt<DioClient>())
      );

      getIt.registerLazySingleton<ProductLocalDataSource>(
              () => ProductLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>())
      );

      // Repository
      getIt.registerLazySingleton<ProductRepository>(
              () => ProductRepositoryImpl(
            remoteDataSource: getIt<ProductRemoteDataSource>(),
            localDataSource: getIt<ProductLocalDataSource>(),
            networkInfo: getIt<NetworkInfo>(),
          )
      );

      // Use cases
      getIt.registerLazySingleton<GetProducts>(
              () => GetProducts(getIt<ProductRepository>())
      );

      getIt.registerLazySingleton<GetProductById>(
              () => GetProductById(getIt<ProductRepository>())
      );

      getIt.registerLazySingleton<GetProductsByCategory>(
              () => GetProductsByCategory(getIt<ProductRepository>())
      );

      getIt.registerLazySingleton<SearchProducts>(
              () => SearchProducts(getIt<ProductRepository>())
      );

      // BLoCs
      getIt.registerFactory<ProductsBloc>(
              () => ProductsBloc(
            getProducts: getIt<GetProducts>(),
            getProductsByCategory: getIt<GetProductsByCategory>(),
            searchProducts: getIt<SearchProducts>(),
          )
      );

      getIt.registerFactory<ProductDetailBloc>(
              () => ProductDetailBloc(
            getProductById: getIt<GetProductById>(),
          )
      );
    }

    void initCartDependencies() {
      // Services
      getIt.registerLazySingleton<WhatsAppService>(
              () => WhatsAppService(phoneNumber: '5219876543210') // Reemplazar con el número real de la empresa
      );

      // Data sources
      getIt.registerLazySingleton<CartLocalDataSource>(
              () => CartLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>())
      );

      // Repository
      getIt.registerLazySingleton<CartRepository>(
              () => CartRepositoryImpl(localDataSource: getIt<CartLocalDataSource>())
      );

      // Use cases
      getIt.registerLazySingleton<GetCart>(
              () => GetCart(getIt<CartRepository>())
      );

      getIt.registerLazySingleton<AddToCart>(
              () => AddToCart(getIt<CartRepository>())
      );

      getIt.registerLazySingleton<UpdateCartItem>(
              () => UpdateCartItem(getIt<CartRepository>())
      );

      getIt.registerLazySingleton<RemoveCartItem>(
              () => RemoveCartItem(getIt<CartRepository>())
      );

      getIt.registerLazySingleton<ClearCart>(
              () => ClearCart(getIt<CartRepository>())
      );

      getIt.registerLazySingleton<CheckoutCart>(
              () => CheckoutCart(getIt<CartRepository>())
      );

      // BLoC
      getIt.registerFactory<CartBloc>(
              () => CartBloc(
            getCart: getIt<GetCart>(),
            addToCart: getIt<AddToCart>(),
            updateCartItem: getIt<UpdateCartItem>(),
            removeCartItem: getIt<RemoveCartItem>(),
            clearCart: getIt<ClearCart>(),
            checkoutCart: getIt<CheckoutCart>(),
          )
      );
    }

    void initOrderDependencies() {
      // Data sources
      getIt.registerLazySingleton<OrderRemoteDataSource>(
              () => OrderRemoteDataSourceImpl(client: getIt<DioClient>())
      );

      getIt.registerLazySingleton<OrderLocalDataSource>(
              () => OrderLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>())
      );

      // Repository
      getIt.registerLazySingleton<OrderRepository>(
              () => OrderRepositoryImpl(
            remoteDataSource: getIt<OrderRemoteDataSource>(),
            localDataSource: getIt<OrderLocalDataSource>(),
            networkInfo: getIt<NetworkInfo>(),
          )
      );

      // Use cases
      getIt.registerLazySingleton<GetOrders>(
              () => GetOrders(getIt<OrderRepository>())
      );

      getIt.registerLazySingleton<GetOrderById>(
              () => GetOrderById(getIt<OrderRepository>())
      );

      getIt.registerLazySingleton<CancelOrder>(
              () => CancelOrder(getIt<OrderRepository>())
      );

      // BLoC
      getIt.registerFactory<OrdersBloc>(
              () => OrdersBloc(
            getOrders: getIt<GetOrders>(),
          )
      );

      getIt.registerFactory<OrderDetailBloc>(
              () => OrderDetailBloc(
            getOrderById: getIt<GetOrderById>(),
            cancelOrder: getIt<CancelOrder>(),
          )
      );
    }