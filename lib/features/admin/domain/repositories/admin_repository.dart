// Ruta: lib/features/admin/domain/repositories/admin_repository.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/dashboard_stats_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/analytics_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/sales_report_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

abstract class AdminRepository {
  /// Obtener estadísticas para el dashboard
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats();

  /// Obtener analíticas por período
  Future<Either<Failure, AnalyticsEntity>> getAnalytics(String period);

  /// Obtener reporte de ventas para un rango de fechas
  Future<Either<Failure, SalesReportEntity>> getSalesReport(
      DateTime startDate,
      DateTime endDate,
      );

  /// Obtener productos con bajo inventario
  Future<Either<Failure, List<ProductEntity>>> getInventoryAlerts();

  /// Crear un nuevo producto
  Future<Either<Failure, ProductEntity>> createProduct(ProductEntity product);

  /// Actualizar un producto existente
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product);

  /// Eliminar un producto
  Future<Either<Failure, bool>> deleteProduct(String id);
}