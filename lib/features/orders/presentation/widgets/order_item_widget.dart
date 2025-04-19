// Ruta: lib/features/orders/presentation/widgets/order_item_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderItemWidget({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: Número de orden y fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Orden #${order.id}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(order.date),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              const Divider(),

              // Resumen de productos
              Text(
                'Productos:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),

              ...order.items.take(2).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.product.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )),

              // Mostrar indicador de más productos si hay más de 2
              if (order.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+ ${order.items.length - 2} productos más...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

              const Divider(),

              // Pie: Total y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),

              // Información de envío si está disponible
              if (order.trackingNumber != null && order.shippingCarrier != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Envío: ${order.shippingCarrier} - Rastreo: ${order.trackingNumber}',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, OrderStatus status) {
    // Definir color y texto según el estado
    Color chipColor;
    String statusText;

    switch (status) {
      case OrderStatus.pending:
        chipColor = Colors.orange;
        statusText = 'Pendiente';
        break;
      case OrderStatus.confirmed:
        chipColor = Colors.blue;
        statusText = 'Confirmado';
        break;
      case OrderStatus.processing:
        chipColor = Colors.purple;
        statusText = 'En proceso';
        break;
      case OrderStatus.shipped:
        chipColor = Colors.indigo;
        statusText = 'Enviado';
        break;
      case OrderStatus.delivered:
        chipColor = Colors.green;
        statusText = 'Entregado';
        break;
      case OrderStatus.cancelled:
        chipColor = Colors.red;
        statusText = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// Ruta: lib/features/orders/presentation/widgets/empty_orders.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';

class EmptyOrders extends StatelessWidget {
  const EmptyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono o ilustración
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),

            // Título
            Text(
              'No tienes pedidos',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Mensaje
            Text(
              'Aún no has realizado ningún pedido. Explora nuestro catálogo y encuentra los productos que necesitas.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Botón para explorar productos
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.home),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Explorar Productos'),
            ),
          ],
        ),
      ),
    );
  }
}