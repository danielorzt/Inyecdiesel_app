// Ruta: lib/features/orders/domain/usecases/get_orders.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';
import 'package:inyecdiesel_eco/features/orders/domain/repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return repository.getOrders();
  }
}

// Ruta: lib/features/orders/domain/repositories/order_repository.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  /// Obtener todos los pedidos del usuario actual
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  /// Obtener un pedido específico por ID
  Future<Either<Failure, OrderEntity>> getOrderById(String id);

  /// Cancelar un pedido
  Future<Either<Failure, bool>> cancelOrder(String id);
}

// Ruta: lib/features/orders/data/repositories/order_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/core/network/network_info.dart';
import 'package:inyecdiesel_eco/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/orders/data/datasources/order_local_data_source.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';
import 'package:inyecdiesel_eco/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getOrders();
        localDataSource.cacheOrders(remoteOrders);
        return Right(remoteOrders);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localOrders = await localDataSource.getLastOrders();
        return Right(localOrders);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrder = await remoteDataSource.getOrderById(id);
        localDataSource.cacheOrder(remoteOrder);
        return Right(remoteOrder);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localOrder = await localDataSource.getOrderById(id);
        return Right(localOrder);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOrder(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.cancelOrder(id);
        if (result) {
          // Actualizar también en caché
          try {
            await localDataSource.updateOrderStatus(id, OrderStatus.cancelled);
          } catch (_) {
            // Si falla la actualización en caché, no es crítico
          }
        }
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}