// Ruta: lib/features/admin/presentation/widgets/recent_orders_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';

class RecentOrdersWidget extends StatelessWidget {
  const RecentOrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data para recientes pedidos
    final recentOrders = [
      OrderEntity(
        id: '1001',
        items: [],
        date: DateTime.now().subtract(const Duration(hours: 2)),
        totalAmount: 1250.00,
        status: OrderStatus.pending,
      ),
      OrderEntity(
        id: '1000',
        items: [],
        date: DateTime.now().subtract(const Duration(hours: 5)),
        totalAmount: 750.50,
        status: OrderStatus.confirmed,
      ),
      OrderEntity(
        id: '999',
        items: [],
        date: DateTime.now().subtract(const Duration(hours: 8)),
        totalAmount: 1875.20,
        status: OrderStatus.processing,
      ),
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Listado de pedidos recientes
            ...recentOrders.map((order) => _buildOrderItem(context, order)),

            // Botón para ver todos
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  // Aquí se implementaría la navegación a la lista completa
                },
                child: const Text('Ver todos los pedidos'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderEntity order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador de estado
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4, right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStatusColor(order.status),
            ),
          ),

          // Información del pedido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pedido #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getStatusText(order.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(order.status),
                      ),
                    ),
                    Text(
                      _getFormattedDate(order.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.confirmed:
        return 'Confirmado';
      case OrderStatus.processing:
        return 'En proceso';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Hace un momento';
    }
  }
}

// Ruta: lib/features/admin/presentation/widgets/inventory_alert_widget.dart

import 'package:flutter/material.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

class InventoryAlertWidget extends StatelessWidget {
  const InventoryAlertWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data para productos con bajo inventario
    final lowStockProducts = [
      ProductEntity(
        id: '1',
        name: 'Inyector Diesel Common Rail',
        description: '',
        price: 860.00,
        imageUrl: 'https://example.com/image1.jpg',
        category: 'Inyectores',
        stock: 2,
        tags: [],
      ),
      ProductEntity(
        id: '2',
        name: 'Bomba de Alta Presión',
        description: '',
        price: 1250.50,
        imageUrl: 'https://example.com/image2.jpg',
        category: 'Bombas',
        stock: 3,
        tags: [],
      ),
      ProductEntity(
        id: '3',
        name: 'Sensor de Presión de Riel',
        description: '',
        price: 420.75,
        imageUrl: 'https://example.com/image3.jpg',
        category: 'Sensores',
        stock: 1,
        tags: [],
      ),
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Listado de productos con bajo inventario
            ...lowStockProducts.map((product) => _buildProductItem(context, product)),

            // Botón para ver todos
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  // Aquí se implementaría la navegación a la lista completa
                },
                child: const Text('Ver todos los productos'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductEntity product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen del producto
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
              color: Colors.grey[200],
            ),
            child: product.imageUrl.isEmpty
                ? const Icon(Icons.image_not_supported, size: 20)
                : null,
          ),
          const SizedBox(width: 12),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 14,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Stock: ${product.stock}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: product.stock <= 1 ? Colors.red : Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Ruta: lib/features/admin/presentation/widgets/top_products_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inyecdiesel_eco/core/config/app_theme.dart';

class TopProductsWidget extends StatelessWidget {
  const TopProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para los productos más vendidos
    final topProducts = [
      {'name': 'Inyector Common Rail', 'sales': 42, 'revenue': 36120.00},
      {'name': 'Bomba de Alta Presión', 'sales': 28, 'revenue': 35000.00},
      {'name': 'Sensor de Presión', 'sales': 23, 'revenue': 9660.00},
      {'name': 'Válvula Reguladora', 'sales': 18, 'revenue': 5940.00},
      {'name': 'Kit de Reparación', 'sales': 15, 'revenue': 3750.00},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gráfico de barras
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${topProducts[groupIndex]['name']}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '${rod.toY.toInt()} ventas',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Nombres abreviados para el eje X
                          final String text = topProducts[value.toInt()]['name']
                              .toString()
                              .split(' ')[0];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              text,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: topProducts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final sales = data['sales'] as int;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: sales.toDouble(),
                          color: AppTheme.primaryRed,
                          width: 22,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tabla de productos más vendidos
            const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Producto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Ventas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Ingresos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),

            const Divider(),

            // Lista de productos
            ...topProducts.map((product) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      product['name'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      product['sales'].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\${(product['revenue'] as double).toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}