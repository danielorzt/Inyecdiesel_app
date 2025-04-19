// Ruta: lib/features/shipping/domain/usecases/get_shippings.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';

class GetShippings {
  final ShippingRepository repository;

  GetShippings(this.repository);

  Future<Either<Failure, List<ShippingEntity>>> call() {
    return repository.getShippings();
  }
}

// Ruta: lib/features/shipping/domain/repositories/shipping_repository.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';

abstract class ShippingRepository {
  /// Obtener todos los envíos
  Future<Either<Failure, List<ShippingEntity>>> getShippings();

  /// Obtener un envío específico por ID
  Future<Either<Failure, ShippingEntity>> getShippingById(String id);

  /// Crear un nuevo envío
  Future<Either<Failure, ShippingEntity>> createShipping(ShippingEntity shipping);

  /// Actualizar un envío existente
  Future<Either<Failure, ShippingEntity>> updateShipping(ShippingEntity shipping);

  /// Actualizar el estado de un envío
  Future<Either<Failure, ShippingEntity>> updateShippingStatus(String id, ShippingStatus status);
}

// Ruta: lib/features/shipping/data/repositories/shipping_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/core/network/network_info.dart';
import 'package:inyecdiesel_eco/features/shipping/data/datasources/shipping_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/shipping/data/datasources/shipping_local_data_source.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/repositories/shipping_repository.dart';

class ShippingRepositoryImpl implements ShippingRepository {
  final ShippingRemoteDataSource remoteDataSource;
  final ShippingLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ShippingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ShippingEntity>>> getShippings() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteShippings = await remoteDataSource.getShippings();
        localDataSource.cacheShippings(remoteShippings);
        return Right(remoteShippings);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localShippings = await localDataSource.getLastShippings();
        return Right(localShippings);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ShippingEntity>> getShippingById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteShipping = await remoteDataSource.getShippingById(id);
        localDataSource.cacheShipping(remoteShipping);
        return Right(remoteShipping);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localShipping = await localDataSource.getShippingById(id);
        return Right(localShipping);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ShippingEntity>> createShipping(ShippingEntity shipping) async {
    if (await networkInfo.isConnected) {
      try {
        final createdShipping = await remoteDataSource.createShipping(shipping);
        localDataSource.cacheShipping(createdShipping);
        return Right(createdShipping);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ShippingEntity>> updateShipping(ShippingEntity shipping) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedShipping = await remoteDataSource.updateShipping(shipping);
        localDataSource.cacheShipping(updatedShipping);
        return Right(updatedShipping);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ShippingEntity>> updateShippingStatus(String id, ShippingStatus status) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedShipping = await remoteDataSource.updateShippingStatus(id, status);
        localDataSource.cacheShipping(updatedShipping);
        return Right(updatedShipping);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}