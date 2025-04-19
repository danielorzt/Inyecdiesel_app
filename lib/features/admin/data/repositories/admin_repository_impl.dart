// Ruta: lib/features/admin/data/repositories/admin_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/core/network/network_info.dart';
import 'package:inyecdiesel_eco/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/admin/data/datasources/admin_local_data_source.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/dashboard_stats_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/analytics_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/sales_report_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/repositories/admin_repository.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  final AdminLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AdminRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats() async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getDashboardStats();
        localDataSource.cacheDashboardStats(stats);
        return Right(stats);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final stats = await localDataSource.getLastDashboardStats();
        return Right(stats);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, AnalyticsEntity>> getAnalytics(String period) async {
    if (await networkInfo.isConnected) {
      try {
        final analytics = await remoteDataSource.getAnalytics(period);
        localDataSource.cacheAnalytics(analytics, period);
        return Right(analytics);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final analytics = await localDataSource.getLastAnalytics(period);
        return Right(analytics);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, SalesReportEntity>> getSalesReport(
      DateTime startDate,
      DateTime endDate,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final report = await remoteDataSource.getSalesReport(startDate, endDate);
        localDataSource.cacheSalesReport(report);
        return Right(report);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final report = await localDataSource.getLastSalesReport();
        return Right(report);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getInventoryAlerts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getInventoryAlerts();
        localDataSource.cacheInventoryAlerts(products);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final products = await localDataSource.getLastInventoryAlerts();
        return Right(products);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(ProductEntity product) async {
    if (await networkInfo.isConnected) {
      try {
        final createdProduct = await remoteDataSource.createProduct(product);
        return Right(createdProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProduct = await remoteDataSource.updateProduct(product);
        return Right(updatedProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteProduct(id);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}