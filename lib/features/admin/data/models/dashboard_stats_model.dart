// Ruta: lib/features/admin/data/models/dashboard_stats_model.dart

import 'dart:convert';
import 'package:inyecdiesel_eco/features/admin/domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.pendingOrders,
    required super.totalSales,
    required super.totalProducts,
    required super.lowStockProducts,
    required super.recentOrders,
  });

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      pendingOrders: map['pending_orders'] ?? 0,
      totalSales: map['total_sales']?.toDouble() ?? 0.0,
      totalProducts: map['total_products'] ?? 0,
      lowStockProducts: map['low_stock_products'] ?? 0,
      recentOrders: List<RecentOrderModel>.from(
        map['recent_orders']?.map((x) => RecentOrderModel.fromMap(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pending_orders': pendingOrders,
      'total_sales': totalSales,
      'total_products': totalProducts,
      'low_stock_products': lowStockProducts,
      'recent_orders': recentOrders
          .map((x) => (x as RecentOrderModel).toMap())
          .toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory DashboardStatsModel.fromJson(String source) =>
      DashboardStatsModel.fromMap(json.decode(source));
}

class RecentOrderModel extends RecentOrderEntity {
  const RecentOrderModel({
    required super.id,
    required super.date,
    required super.amount,
    required super.status,
  });

  factory RecentOrderModel.fromMap(Map<String, dynamic> map) {
    return RecentOrderModel(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      amount: map['amount']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'status': status,
    };
  }
}

// Ruta: lib/features/admin/data/models/analytics_model.dart

import 'dart:convert';
import 'package:inyecdiesel_eco/features/admin/domain/entities/analytics_entity.dart';

class AnalyticsModel extends AnalyticsEntity {
  const AnalyticsModel({
    required super.totalRevenue,
    required super.previousPeriodRevenue,
    required super.totalOrders,
    required super.previousPeriodOrders,
    required super.monthlySales,
    required super.categorySales,
    required super.topProducts,
  });

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    return AnalyticsModel(
      totalRevenue: map['total_revenue']?.toDouble() ?? 0.0,
      previousPeriodRevenue: map['previous_period_revenue']?.toDouble() ?? 0.0,
      totalOrders: map['total_orders'] ?? 0,
      previousPeriodOrders: map['previous_period_orders'] ?? 0,
      monthlySales: List<MonthlySalesDataModel>.from(
        map['monthly_sales']?.map((x) => MonthlySalesDataModel.fromMap(x)) ?? [],
      ),
      categorySales: List<CategorySalesDataModel>.from(
        map['category_sales']?.map((x) => CategorySalesDataModel.fromMap(x)) ?? [],
      ),
      topProducts: List<TopProductDataModel>.from(
        map['top_products']?.map((x) => TopProductDataModel.fromMap(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_revenue': totalRevenue,
      'previous_period_revenue': previousPeriodRevenue,
      'total_orders': totalOrders,
      'previous_period_orders': previousPeriodOrders,
      'monthly_sales': monthlySales
          .map((x) => (x as MonthlySalesDataModel).toMap())
          .toList(),
      'category_sales': categorySales
          .map((x) => (x as CategorySalesDataModel).toMap())
          .toList(),
      'top_products': topProducts
          .map((x) => (x as TopProductDataModel).toMap())
          .toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory AnalyticsModel.fromJson(String source) =>
      AnalyticsModel.fromMap(json.decode(source));
}

class MonthlySalesDataModel extends MonthlySalesData {
  const MonthlySalesDataModel({
    required super.month,
    required super.revenue,
  });

  factory MonthlySalesDataModel.fromMap(Map<String, dynamic> map) {
    return MonthlySalesDataModel(
      month: map['month'] ?? '',
      revenue: map['revenue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'revenue': revenue,
    };
  }
}

class CategorySalesDataModel extends CategorySalesData {
  const CategorySalesDataModel({
    required super.category,
    required super.revenue,
    required super.percentage,
  });

  factory CategorySalesDataModel.fromMap(Map<String, dynamic> map) {
    return CategorySalesDataModel(
      category: map['category'] ?? '',
      revenue: map['revenue']?.toDouble() ?? 0.0,
      percentage: map['percentage']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'revenue': revenue,
      'percentage': percentage,
    };
  }
}

class TopProductDataModel extends TopProductData {
  const TopProductDataModel({
    required super.id,
    required super.name,
    required super.sales,
    required super.revenue,
  });

  factory TopProductDataModel.fromMap(Map<String, dynamic> map) {
    return TopProductDataModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sales: map['sales'] ?? 0,
      revenue: map['revenue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sales': sales,
      'revenue': revenue,
    };
  }
}

// Ruta: lib/features/admin/data/models/sales_report_model.dart

import 'dart:convert';
import 'package:inyecdiesel_eco/features/admin/domain/entities/sales_report_entity.dart';

class SalesReportModel extends SalesReportEntity {
  const SalesReportModel({
    required super.startDate,
    required super.endDate,
    required super.totalRevenue,
    required super.totalOrders,
    required super.averageOrderValue,
    required super.dailySales,
  });

  factory SalesReportModel.fromMap(Map<String, dynamic> map) {
    return SalesReportModel(
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      totalRevenue: map['total_revenue']?.toDouble() ?? 0.0,
      totalOrders: map['total_orders'] ?? 0,
      averageOrderValue: map['average_order_value']?.toDouble() ?? 0.0,
      dailySales: List<DailySalesDataModel>.from(
        map['daily_sales']?.map((x) => DailySalesDataModel.fromMap(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_revenue': totalRevenue,
      'total_orders': totalOrders,
      'average_order_value': averageOrderValue,
      'daily_sales': dailySales
          .map((x) => (x as DailySalesDataModel).toMap())
          .toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory SalesReportModel.fromJson(String source) =>
      SalesReportModel.fromMap(json.decode(source));
}

class DailySalesDataModel extends DailySalesData {
  const DailySalesDataModel({
    required super.date,
    required super.revenue,
    required super.orders,
  });

  factory DailySalesDataModel.fromMap(Map<String, dynamic> map) {
    return DailySalesDataModel(
      date: DateTime.parse(map['date']),
      revenue: map['revenue']?.toDouble() ?? 0.0,
      orders: map['orders'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'revenue': revenue,
      'orders': orders,
    };
  }
}