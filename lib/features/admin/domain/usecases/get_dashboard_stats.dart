// Ruta: lib/features/admin/domain/usecases/get_dashboard_stats.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/dashboard_stats_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';

class GetDashboardStats {
  final AdminRepository repository;

  GetDashboardStats(this.repository);

  Future<Either<Failure, DashboardStatsEntity>> call() {
    return repository.getDashboardStats();
  }
}

// Ruta: lib/features/admin/domain/usecases/get_analytics.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/analytics_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';

class GetAnalytics {
  final AdminRepository repository;

  GetAnalytics(this.repository);

  Future<Either<Failure, AnalyticsEntity>> call(Params params) {
    return repository.getAnalytics(params.period);
  }
}

class Params extends Equatable {
  final String period;

  const Params({required this.period});

  @override
  List<Object?> get props => [period];
}

// Ruta: lib/features/admin/domain/usecases/get_sales_report.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/sales_report_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';

class GetSalesReport {
  final AdminRepository repository;

  GetSalesReport(this.repository);

  Future<Either<Failure, SalesReportEntity>> call(Params params) {
    return repository.getSalesReport(params.startDate, params.endDate);
  }
}

class Params extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const Params({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

// Ruta: lib/features/admin/domain/usecases/get_inventory_alerts.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';

class GetInventoryAlerts {
  final AdminRepository repository;

  GetInventoryAlerts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getInventoryAlerts();
  }
}

// Ruta: lib/features/admin/domain/usecases/manage_product.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';

class ManageProduct {
  final AdminRepository repository;

  ManageProduct(this.repository);

  Future<Either<Failure, ProductEntity>> createProduct(ProductEntity product) {
    return repository.createProduct(product);
  }

  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product) {
    return repository.updateProduct(product);
  }

  Future<Either<Failure, bool>> deleteProduct(String id) {
    return repository.deleteProduct(id);
  }
}