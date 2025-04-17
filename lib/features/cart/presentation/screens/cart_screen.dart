// Ruta: lib/features/cart/presentation/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inyecdiesel_eco/core/utils/whatsapp_service.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_entity.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_event.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_state.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/widgets/checkout_button.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/widgets/empty_cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CartBloc>()..add(LoadCart()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Carrito de Compras'),
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded && state.cart.items.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () {
                      _showClearCartDialog(context);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartCheckoutSuccess) {
              _showCheckoutSuccessDialog(context);
            } else if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is CartCheckoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartLoaded) {
              if (state.cart.isEmpty) {
                return const EmptyCart();
              }
              return _buildCartContent(context, state.cart);
            } else if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(LoadCart());
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartEntity cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return CartItemWidget(
                item: item,
                onUpdateQuantity: (quantity) {
                  context.read<CartBloc>().add(
                    UpdateCartItemQuantity(
                      productId: item.product.id,
                      quantity: quantity,
                    ),
                  );
                },
                onRemove: () {
                  context.read<CartBloc>().add(
                    RemoveCartItem(productId: item.product.id),
                  );
                },
              );
            },
          ),
        ),
        _buildCartSummary(context, cart),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartEntity cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productos',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${cart.totalItems} ${cart.totalItems == 1 ? 'item' : 'items'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckoutButton(
            onPressed: () {
              _processCheckout(context, cart);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _processCheckout(BuildContext context, CartEntity cart) async {
    final whatsappService = GetIt.instance<WhatsAppService>();

    // Preparar el mensaje para WhatsApp
    final message = _prepareWhatsAppMessage(cart);

    // Intentar abrir WhatsApp
    final success = await whatsappService.openWhatsApp(message);

    if (success) {
      // Si se abrió WhatsApp correctamente, limpiar el carrito
      if (context.mounted) {
        context.read<CartBloc>().add(CheckoutCartEvent());
      }
    } else {
      // Si no se pudo abrir WhatsApp, mostrar un error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp. Por favor, inténtalo de nuevo.'),
          ),
        );
      }
    }
  }

  String _prepareWhatsAppMessage(CartEntity cart) {
    final buffer = StringBuffer();

    buffer.writeln('*Nuevo Pedido - InyecDiesel Eco*');
    buffer.writeln('--------------------------------');
    buffer.writeln('*Productos:*');

    for (final item in cart.items) {
      buffer.writeln('• ${item.quantity}x ${item.product.name} - \$${item.product.price.toStringAsFixed(2)} c/u');
    }

    buffer.writeln('--------------------------------');
    buffer.writeln('*Subtotal:* \$${cart.totalAmount.toStringAsFixed(2)}');
    buffer.writeln('*Total Items:* ${cart.totalItems}');
    buffer.writeln('--------------------------------');
    buffer.writeln('Por favor confirme mi pedido. Gracias!');