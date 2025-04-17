// Ruta: lib/features/cart/presentation/bloc/cart_event.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final ProductEntity product;
  final int quantity;

  AddItemToCart({
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [product.id, quantity];
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;

  UpdateCartItemQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveCartItem extends CartEvent {
  final String productId;

  RemoveCartItem({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {}

class CheckoutCartEvent extends CartEvent {}

// Ruta: lib/features/cart/presentation/bloc/cart_state.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartEntity cart;

  CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartCheckoutSuccess extends CartState {}

class CartCheckoutError extends CartState {
  final String message;

  CartCheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

// Ruta: lib/features/cart/presentation/bloc/cart_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/add_to_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/clear_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/get_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/checkout_cart.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:inyecdiesel_eco/features/cart/domain/usecases/update_cart_item.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_event.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final UpdateCartItem updateCartItem;
  final RemoveCartItem removeCartItem;
  final ClearCart clearCart;
  final CheckoutCart checkoutCart;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.updateCartItem,
    required this.removeCartItem,
    required this.clearCart,
    required this.checkoutCart,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
    on<CheckoutCartEvent>(_onCheckoutCart);
  }

  Future<void> _onLoadCart(
      LoadCart event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());
    final result = await getCart();
    result.fold(
          (failure) => emit(CartError('No se pudo cargar el carrito')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAddItemToCart(
      AddItemToCart event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());
    final result = await addToCart(
      AddToCart.Params(
        product: event.product,
        quantity: event.quantity,
      ),
    );
    result.fold(
          (failure) => emit(CartError('No se pudo añadir el producto al carrito')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onUpdateCartItemQuantity(
      UpdateCartItemQuantity event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());
    final result = await updateCartItem(
      UpdateCartItem.Params(
        productId: event.productId,
        quantity: event.quantity,
      ),
    );
    result.fold(
          (failure) => emit(CartError('No se pudo actualizar la cantidad')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onRemoveCartItem(
      RemoveCartItem event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());
    final result = await removeCartItem(
      RemoveCartItem.Params(productId: event.productId),
    );
    result.fold(
          (failure) => emit(CartError('No se pudo eliminar el producto del carrito')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onClearCart(
      ClearCartEvent event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());
    final result = await clearCart();
    result.fold(
          (failure) => emit(CartError('No se pudo vaciar el carrito')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onCheckoutCart(
      CheckoutCartEvent event,
      Emitter<CartState> emit,
      ) async {
    // Primero obtenemos el carrito actual
    final cartResult = await getCart();

    await cartResult.fold(
          (failure) async {
        emit(CartError('No se pudo acceder al carrito para el checkout'));
      },
          (cart) async {
        if (cart.items.isEmpty) {
          emit(CartError('El carrito está vacío'));
          return;
        }

        emit(CartLoading());

        final checkoutResult = await checkoutCart(
          CheckoutCart.Params(items: cart.items),
        );

        checkoutResult.fold(
              (failure) => emit(CartCheckoutError('Error al finalizar la compra')),
              (success) {
            emit(CartCheckoutSuccess());
            // Después del checkout exitoso, cargamos el carrito vacío
            add(LoadCart());
          },
        );
      },
    );
  }
}