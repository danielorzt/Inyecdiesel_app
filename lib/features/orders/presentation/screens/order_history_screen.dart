// Ruta: lib/features/orders/presentation/screens/order_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_event.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_state.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/widgets/order_item_widget.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/widgets/empty_orders.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<OrdersBloc>()..add(LoadOrders()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historial de Pedidos'),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const EmptyOrders();
              }
              return _buildOrdersList(state.orders);
            } else if (state is OrdersError) {
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
                        context.read<OrdersBloc>().add(LoadOrders());
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

  Widget _buildOrdersList(List<OrderEntity> orders) {
    // Ordenar por fecha, más recientes primero
    final sortedOrders = List<OrderEntity>.from(orders)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedOrders.length,
      itemBuilder: (context, index) {
        final order = sortedOrders[index];
        return OrderItemWidget(
          order: order,
          onTap: () {
            // Aquí se navegaría al detalle del pedido
            // context.push('${RouteConstants.orderDetails}/${order.id}');
          },
        );
      },
    );
  }
}