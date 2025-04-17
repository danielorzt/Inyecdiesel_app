// Ruta: lib/features/products/domain/repositories/product_repository.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

/// Repositorio abstracto para productos
abstract class ProductRepository {
  /// Obtener todos los productos
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Obtener un producto por ID
  Future<Either<Failure, ProductEntity>> getProductById(String id);

  /// Obtener productos por categoría
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category);

  /// Buscar productos
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}

// Ruta: lib/features/products/data/repositories/product_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/core/network/network_info.dart';
import 'package:inyecdiesel_eco/features/products/data/datasources/product_remote_data_source.dart';
import 'package:inyecdiesel_eco/features/products/data/datasources/product_local_data_source.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/repositories/product_repository.dart';

/// Implementación del repositorio de productos
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getLastProducts();
        return Right(localProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProductById(id);
        localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProduct = await localDataSource.getProductById(id);
        return Right(localProduct);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProductsByCategory(category);
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getProductsByCategory(category);
        return Right(localProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.searchProducts(query);
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.searchProducts(query);
        return Right(localProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}