// Ruta: lib/features/cart/data/datasources/cart_local_data_source.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/features/cart/data/models/cart_item_model.dart';
import 'package:inyecdiesel_eco/features/cart/data/models/cart_model.dart';
import 'package:inyecdiesel_eco/features/products/data/models/product_model.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

abstract class CartLocalDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addItem(ProductEntity product, int quantity);
  Future<CartModel> updateItemQuantity(String productId, int quantity);
  Future<CartModel> removeItem(String productId);
  Future<CartModel> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  static const String cartKey = 'CART_DATA';

  @override
  Future<CartModel> getCart() async {
    final jsonString = sharedPreferences.getString(cartKey);
    if (jsonString != null) {
      try {
        return CartModel.fromJson(jsonString);
      } catch (e) {
        throw CacheException();
      }
    } else {
      // Si no hay carrito guardado, devolver uno vacío
      return CartModel.empty();
    }
  }

  @override
  Future<CartModel> addItem(ProductEntity product, int quantity) async {
    final currentCart = await getCart();
    final productModel = product as ProductModel;

    // Verificar si el producto ya está en el carrito
    final existingItemIndex = currentCart.items.indexWhere(
            (item) => item.product.id == product.id
    );

    if (existingItemIndex >= 0) {
      // Si el producto ya está en el carrito, actualizar la cantidad
      final currentItems = [...currentCart.items];
      final existingItem = currentItems[existingItemIndex] as CartItemModel;

      currentItems[existingItemIndex] = CartItemModel(
        product: existingItem.product,
        quantity: existingItem.quantity + quantity,
      );

      final updatedCart = CartModel(
        items: currentItems,
      );

      await _saveCart(updatedCart);
      return updatedCart;
    } else {
      // Si el producto no está en el carrito, añadirlo
      final newItem = CartItemModel(
        product: productModel,
        quantity: quantity,
      );

      final updatedCart = CartModel(
        items: [...currentCart.items, newItem],
      );

      await _saveCart(updatedCart);
      return updatedCart;
    }
  }

  @override
  Future<CartModel> updateItemQuantity(String productId, int quantity) async {
    final currentCart = await getCart();

    if (quantity <= 0) {
      // Si la cantidad es 0 o menos, eliminar el producto
      return removeItem(productId);
    }

    final updatedItems = currentCart.items.map((item) {
      if (item.product.id == productId) {
        return CartItemModel(
          product: item.product as ProductModel,
          quantity: quantity,
        );
      }
      return item;
    }).toList();

    final updatedCart = CartModel(
      items: updatedItems,
    );

    await _saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartModel> removeItem(String productId) async {
    final currentCart = await getCart();

    final updatedItems = currentCart.items.where(
            (item) => item.product.id != productId
    ).toList();

    final updatedCart = CartModel(
      items: updatedItems,
    );

    await _saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartModel> clearCart() async {
    final emptyCart = CartModel.empty();
    await _saveCart(emptyCart);
    return emptyCart;
  }

  // Método privado para guardar el carrito en SharedPreferences
  Future<void> _saveCart(CartModel cart) async {
    await sharedPreferences.setString(
      cartKey,
      json.encode(cart.toMap()),
    );
  }
}