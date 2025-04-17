// Ruta: lib/features/cart/domain/entities/cart_item_entity.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product.id, quantity];
}

// Ruta: lib/features/cart/domain/entities/cart_entity.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({required this.items});

  double get totalAmount => items.fold(
    0.0,
        (sum, item) => sum + item.totalPrice,
  );

  int get totalItems => items.fold(
    0,
        (sum, item) => sum + item.quantity,
  );

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items];
}

// Ruta: lib/features/cart/data/models/cart_item_model.dart

import 'dart:convert';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';
import 'package:inyecdiesel_eco/features/products/data/models/product_model.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.product,
    required super.quantity,
  });

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product as ProductModel,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': (product as ProductModel).toMap(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) => CartItemModel.fromMap(json.decode(source));
}

// Ruta: lib/features/cart/data/models/cart_model.dart

import 'dart:convert';
import 'package:inyecdiesel_eco/features/cart/data/models/cart_item_model.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({required super.items});

  CartModel copyWith({
    List<CartItemModel>? items,
  }) {
    return CartModel(
      items: items ?? this.items.map((e) => e as CartItemModel).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => (item as CartItemModel).toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      items: List<CartItemModel>.from(
        map['items']?.map((x) => CartItemModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  // Constructor vacío
  factory CartModel.empty() => const CartModel(items: []);
}

// Ruta: lib/features/cart/domain/repositories/cart_repository.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> addItem(ProductEntity product, int quantity);
  Future<Either<Failure, CartEntity>> updateItemQuantity(String productId, int quantity);
  Future<Either<Failure, CartEntity>> removeItem(String productId);
  Future<Either<Failure, CartEntity>> clearCart();
  Future<Either<Failure, bool>> checkoutCart(List<CartItemEntity> items);
}

// Ruta: lib/features/cart/data/repositories/cart_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';
import 'package:inyecdiesel_eco/features/cart/domain/repositories/cart_repository.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';