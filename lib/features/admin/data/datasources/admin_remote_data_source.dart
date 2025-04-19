// Ruta: lib/features/admin/data/datasources/admin_remote_data_source.dart

import 'package:inyecdiesel_eco/core/network/dio_client.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/features/admin/data/models/dashboard_stats_model.dart';
import 'package:inyecdiesel_eco/features/admin/data/models/analytics_model.dart';
import 'package:inyecdiesel_eco/features/admin/data/models/sales_report_model.dart';
import 'package:inyecdiesel_eco/features/products/data/models/product_model.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

abstract class AdminRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<AnalyticsModel> getAnalytics(String period);
  Future<SalesReportModel> getSalesReport(DateTime startDate, DateTime endDate);
  Future<List<ProductModel>> getInventoryAlerts();
  Future<ProductModel> createProduct(ProductEntity product);
  Future<ProductModel> updateProduct(ProductEntity product);
  Future<bool> deleteProduct(String id);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final DioClient client;

  AdminRemoteDataSourceImpl({required this.client});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await client.get('/admin/dashboard');

      if (response.statusCode == 200) {
        return DashboardStatsModel.fromMap(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<AnalyticsModel> getAnalytics(String period) async {
    try {
      final response = await client.get(
        '/admin/analytics',
        queryParameters: {'period': period},
      );

      if (response.statusCode == 200) {
        return AnalyticsModel.fromMap(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<SalesReportModel> getSalesReport(DateTime startDate, DateTime endDate) async {
    try {
      final response = await client.get(
        '/admin/reports/sales',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        return SalesReportModel.fromMap(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getInventoryAlerts() async {
    try {
      final response = await client.get('/admin/inventory/alerts');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['data'];
        return productsJson.map((json) => ProductModel.fromMap(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProduct(ProductEntity product) async {
    try {
      final productModel = product as ProductModel;
      final response = await client.post(
        '/admin/products',
        data: productModel.toMap(),
      );

      if (response.statusCode == 201) {
        return ProductModel.fromMap(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductEntity product) async {
    try {
      final productModel = product as ProductModel;
      final response = await client.put(
        '/admin/products/${product.id}',
        data: productModel.toMap(),
      );

      if (response.statusCode == 200) {
        return ProductModel.fromMap(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await client.delete('/admin/products/$id');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

// Ruta: lib/features/admin/data/datasources/admin_local_data_source.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/features/admin/data/models/dashboard_stats_model.dart';
import 'package:inyecdiesel_eco/features/admin/data/models/analytics_model.dart';
import 'package:inyecdiesel_eco/features/admin/data/models/sales_report_model.dart';
import 'package:inyecdiesel_eco/features/products/data/models/product_model.dart';

abstract class AdminLocalDataSource {
  Future<DashboardStatsModel> getLastDashboardStats();
  Future<AnalyticsModel> getLastAnalytics(String period);
  Future<SalesReportModel> getLastSalesReport();
  Future<List<ProductModel>> getLastInventoryAlerts();

  Future<void> cacheDashboardStats(DashboardStatsModel stats);
  Future<void> cacheAnalytics(AnalyticsModel analytics, String period);
  Future<void> cacheSalesReport(SalesReportModel report);
  Future<void> cacheInventoryAlerts(List<ProductModel> products);
}

class AdminLocalDataSourceImpl implements AdminLocalDataSource {
  final SharedPreferences sharedPreferences;

  AdminLocalDataSourceImpl({required this.sharedPreferences});

  // Claves para SharedPreferences
  static const cachedDashboardStats = 'CACHED_DASHBOARD_STATS';
  static const cachedAnalyticsPrefix = 'CACHED_ANALYTICS_';
  static const cachedSalesReport = 'CACHED_SALES_REPORT';
  static const cachedInventoryAlerts = 'CACHED_INVENTORY_ALERTS';

  @override
  Future<DashboardStatsModel> getLastDashboardStats() async {
    final jsonString = sharedPreferences.getString(cachedDashboardStats);
    if (jsonString != null) {
      return DashboardStatsModel.fromJson(jsonString);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<AnalyticsModel> getLastAnalytics(String period) async {
    final jsonString = sharedPreferences.getString('$cachedAnalyticsPrefix$period');
    if (jsonString != null) {
      return AnalyticsModel.fromJson(jsonString);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<SalesReportModel> getLastSalesReport() async {
    final jsonString = sharedPreferences.getString(cachedSalesReport);
    if (jsonString != null) {
      return SalesReportModel.fromJson(jsonString);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<ProductModel>> getLastInventoryAlerts() async {
    final jsonString = sharedPreferences.getString(cachedInventoryAlerts);
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((item) => ProductModel.fromMap(item)).toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheDashboardStats(DashboardStatsModel stats) async {
    await sharedPreferences.setString(
      cachedDashboardStats,
      stats.toJson(),
    );
  }

  @override
  Future<void> cacheAnalytics(AnalyticsModel analytics, String period) async {
    await sharedPreferences.setString(
      '$cachedAnalyticsPrefix$period',
      analytics.toJson(),
    );
  }

  @override
  Future<void> cacheSalesReport(SalesReportModel report) async {
    await sharedPreferences.setString(
      cachedSalesReport,
      report.toJson(),
    );
  }

  @override
  Future<void> cacheInventoryAlerts(List<ProductModel> products) async {
    final jsonList = products.map((product) => product.toMap()).toList();
    await sharedPreferences.setString(
      cachedInventoryAlerts,
      json.encode(jsonList),
    );
  }
}