// Ruta: lib/features/cart/data/repositories/cart_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cartModel = await localDataSource.getCart();
      return Right(cartModel);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addItem(ProductEntity product, int quantity) async {
    try {
      final updatedCart = await localDataSource.addItem(product, quantity);
      return Right(updatedCart);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateItemQuantity(String productId, int quantity) async {
    try {
      final updatedCart = await localDataSource.updateItemQuantity(productId, quantity);
      return Right(updatedCart);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeItem(String productId) async {
    try {
      final updatedCart = await localDataSource.removeItem(productId);
      return Right(updatedCart);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart() async {
    try {
      final emptyCart = await localDataSource.clearCart();
      return Right(emptyCart);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkoutCart(List<CartItemEntity> items) async {
    try {
      // Esta función simularía el envío de una orden o redirección a WhatsApp
      // Por ahora solo limpiamos el carrito
      await localDataSource.clearCart();
      return const Right(true);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}