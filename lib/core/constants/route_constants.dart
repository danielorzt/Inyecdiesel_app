// Ruta: lib/core/constants/route_constants.dart

/// Constantes para las rutas de la aplicación
class RouteConstants {
  // Rutas de autenticación y splash
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Rutas del cliente
  static const String home = '/home';
  static const String productDetails = '/product';
  static const String cart = '/cart';
  static const String orderHistory = '/orders';
  static const String profile = '/profile';

  // Rutas del administrador
  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminProductDetail = '/admin/products/detail';
  static const String adminProductEdit = '/admin/products/edit';
  static const String adminProductCreate = '/admin/products/create';
  static const String adminOrders = '/admin/orders';
  static const String adminOrderDetail = '/admin/orders/detail';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminUsers = '/admin/users';

  // Rutas del empleado
  static const String shipping = '/shipping';
  static const String shippingDetail = '/shipping/detail';
}