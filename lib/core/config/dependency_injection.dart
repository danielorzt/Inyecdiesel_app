import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:inyecdiesel_eco/core/config/app_router.dart';
import 'package:inyecdiesel_eco/core/network/dio_client.dart';
import 'package:inyecdiesel_eco/core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  _initAuthDependencies();
  _initProductDependencies();
  _initCartDependencies();
  _initOrderDependencies();
  _initAdminDependencies();
  _initShippingDependencies();
}

void _initAuthDependencies() {
  // Will be implemented as we develop this feature
}

void _initProductDependencies() {
  // Will be implemented as we develop this feature
}

void _initCartDependencies() {
  // Will be implemented as we develop this feature
}

void _initOrderDependencies() {
  // Will be implemented as we develop this feature
}

void _initAdminDependencies() {
  // Will be implemented as we develop this feature
}

void _initShippingDependencies() {
  // Will be implemented as we develop this feature
}