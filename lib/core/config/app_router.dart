import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';
import 'package:inyecdiesel_eco/features/auth/presentation/screens/login_screen.dart';
import 'package:inyecdiesel_eco/features/auth/presentation/screens/splash_screen.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/screens/admin_products_screen.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/screens/admin_orders_screen.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/screens/admin_analytics_screen.dart';
import 'package:inyecdiesel_eco/features/products/presentation/screens/product_list_screen.dart';
import 'package:inyecdiesel_eco/features/products/presentation/screens/product_details_screen.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/screens/cart_screen.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/screens/order_history_screen.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/screens/shipping_screen.dart';

/// App router configuration
class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    routes: [
      // Splash and Auth
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Customer Routes
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '${RouteConstants.productDetails}/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: productId);
        },
      ),
      GoRoute(
        path: RouteConstants.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RouteConstants.orderHistory,
        builder: (context, state) => const OrderHistoryScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: RouteConstants.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'products',
            builder: (context, state) => const AdminProductsScreen(),
          ),
          GoRoute(
            path: 'orders',
            builder: (context, state) => const AdminOrdersScreen(),
          ),
          GoRoute(
            path: 'analytics',
            builder: (context, state) => const AdminAnalyticsScreen(),
          ),
        ],
      ),

      // Employee Routes
      GoRoute(
        path: RouteConstants.shipping,
        builder: (context, state) => const ShippingScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('No route found for ${state.location}'),
      ),
    ),
  );
}