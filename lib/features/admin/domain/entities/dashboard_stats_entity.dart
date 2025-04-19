// Ruta: lib/features/admin/domain/entities/dashboard_stats_entity.dart

import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final int pendingOrders;
  final double totalSales;
  final int totalProducts;
  final int lowStockProducts;
  final List<RecentOrderEntity> recentOrders;

  const DashboardStatsEntity({
    required this.pendingOrders,
    required this.totalSales,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.recentOrders,
  });

  @override
  List<Object?> get props => [
    pendingOrders,
    totalSales,
    totalProducts,
    lowStockProducts,
    recentOrders,
  ];
}

class RecentOrderEntity extends Equatable {
  final String id;
  final DateTime date;
  final double amount;
  final String status;

  const RecentOrderEntity({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => [id, date, amount, status];
}

// Ruta: lib/features/admin/domain/entities/analytics_entity.dart

import 'package:equatable/equatable.dart';

class AnalyticsEntity extends Equatable {
  final double totalRevenue;
  final double previousPeriodRevenue;
  final int totalOrders;
  final int previousPeriodOrders;
  final List<MonthlySalesData> monthlySales;
  final List<CategorySalesData> categorySales;
  final List<TopProductData> topProducts;

  const AnalyticsEntity({
    required this.totalRevenue,
    required this.previousPeriodRevenue,
    required this.totalOrders,
    required this.previousPeriodOrders,
    required this.monthlySales,
    required this.categorySales,
    required this.topProducts,
  });

  double get revenueGrowth {
    if (previousPeriodRevenue == 0) return 0;
    return ((totalRevenue - previousPeriodRevenue) / previousPeriodRevenue) * 100;
  }

  double get ordersGrowth {
    if (previousPeriodOrders == 0) return 0;
    return ((totalOrders - previousPeriodOrders) / previousPeriodOrders) * 100;
  }

  @override
  List<Object?> get props => [
    totalRevenue,
    previousPeriodRevenue,
    totalOrders,
    previousPeriodOrders,
    monthlySales,
    categorySales,
    topProducts,
  ];
}

class MonthlySalesData extends Equatable {
  final String month;
  final double revenue;

  const MonthlySalesData({
    required this.month,
    required this.revenue,
  });

  @override
  List<Object?> get props => [month, revenue];
}

class CategorySalesData extends Equatable {
  final String category;
  final double revenue;
  final double percentage;

  const CategorySalesData({
    required this.category,
    required this.revenue,
    required this.percentage,
  });

  @override
  List<Object?> get props => [category, revenue, percentage];
}

class TopProductData extends Equatable {
  final String id;
  final String name;
  final int sales;
  final double revenue;

  const TopProductData({
    required this.id,
    required this.name,
    required this.sales,
    required this.revenue,
  });

  @override
  List<Object?> get props => [id, name, sales, revenue];
}

// Ruta: lib/features/admin/domain/entities/sales_report_entity.dart

import 'package:equatable/equatable.dart';

class SalesReportEntity extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final List<DailySalesData> dailySales;

  const SalesReportEntity({
    required this.startDate,
    required this.endDate,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.dailySales,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    totalRevenue,
    totalOrders,
    averageOrderValue,
    dailySales,
  ];
}

class DailySalesData extends Equatable {
  final DateTime date;
  final double revenue;
  final int orders;

  const DailySalesData({
    required this.date,
    required this.revenue,
    required this.orders,
  });

  @override
  List<Object?> get props => [date, revenue, orders];
}