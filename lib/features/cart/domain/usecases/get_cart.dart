// Ruta: lib/features/cart/domain/usecases/get_cart.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<Either<Failure, CartEntity>> call() {
    return repository.getCart();
  }
}

// Ruta: lib/features/cart/domain/usecases/add_to_cart.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, CartEntity>> call(Params params) {
    return repository.addItem(params.product, params.quantity);
  }
}

class Params extends Equatable {
  final ProductEntity product;
  final int quantity;

  const Params({
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [product.id, quantity];
}

// Ruta: lib/features/cart/domain/usecases/update_cart_item.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  Future<Either<Failure, CartEntity>> call(Params params) {
    return repository.updateItemQuantity(params.productId, params.quantity);
  }
}

class Params extends Equatable {
  final String productId;
  final int quantity;

  const Params({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

// Ruta: lib/features/cart/domain/usecases/remove_cart_item.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';

class RemoveCartItem {
  final CartRepository repository;

  RemoveCartItem(this.repository);

  Future<Either<Failure, CartEntity>> call(Params params) {
    return repository.removeItem(params.productId);
  }
}

class Params extends Equatable {
  final String productId;

  const Params({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Ruta: lib/features/cart/domain/usecases/clear_cart.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';

class ClearCart {
  final CartRepository repository;

  ClearCart(this.repository);

  Future<Either<Failure, CartEntity>> call() {
    return repository.clearCart();
  }
}

// Ruta: lib/features/cart/domain/usecases/checkout_cart.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';

class CheckoutCart {
  final CartRepository repository;

  CheckoutCart(this.repository);

  Future<Either<Failure, bool>> call(Params params) {
    return repository.checkoutCart(params.items);
  }
}

class Params extends Equatable {
  final List<CartItemEntity> items;

  const Params({required this.items});

  @override
  List<Object?> get props => [items];
}