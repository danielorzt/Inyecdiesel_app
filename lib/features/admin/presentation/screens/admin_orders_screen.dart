// Ruta: lib/features/admin/presentation/screens/admin_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_event.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_state.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _filterOrdersByTab(_tabController.index);
      }
    });
  }

  void _filterOrdersByTab(int tabIndex) {
    // Obtener el bloc
    final ordersBloc = context.read<OrdersBloc>();

    switch (tabIndex) {
      case 0: // Todos
        ordersBloc.add(LoadOrders());
        break;
      case 1: // Pendientes
        ordersBloc.add(FilterOrdersByStatus(OrderStatus.pending));
        break;
      case 2: // En proceso
        ordersBloc.add(FilterOrdersByStatus(OrderStatus.processing));
        break;
      case 3: // Entregados
        ordersBloc.add(FilterOrdersByStatus(OrderStatus.delivered));
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<OrdersBloc>()..add(LoadOrders()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Pedidos'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Todos'),
              Tab(text: 'Pendientes'),
              Tab(text: 'En Proceso'),
              Tab(text: 'Entregados'),
            ],
          ),
        ),
        drawer: const AdminDrawer(),
        body: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar pedidos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<OrdersBloc>().add(LoadOrders());
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<OrdersBloc>().add(SearchOrders(value));
                  } else {
                    context.read<OrdersBloc>().add(LoadOrders());
                  }
                },
              ),
            ),

            // Lista de pedidos
            Expanded(
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is OrdersLoaded) {
                    if (state.orders.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron pedidos'),
                      );
                    }
                    return _buildOrdersList(context, state.orders);
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
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderEntity> orders) {
    // Ordenar por fecha, más recientes primero
    final sortedOrders = List<OrderEntity>.from(orders)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedOrders.length,
      itemBuilder: (context, index) {
        final order = sortedOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado: ID del pedido y fecha
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
                      DateFormat('dd/MM/yyyy HH:mm').format(order.date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Productos
                Text(
                  '${order.totalItems} productos - \${order.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const Divider(),

                // Lista resumida de productos
                ...order.items.take(2).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.product.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('\${item.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                )),

                // Indicador de más productos
                if (order.items.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(
                      '+ ${order.items.length - 2} productos más...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),

                const Divider(),

                // Acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Estado del pedido
                    _buildStatusChip(context, order.status),

                    // Botones de acción
                    Row(
                      children: [
                        // Ver detalles
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // Implementar ver detalles
                            _showNotImplementedSnackBar(context, 'Ver detalles del pedido');
                          },
                        ),

                        // Actualizar estado
                        IconButton(
                          icon: const Icon(Icons.edit_note),
                          onPressed: () {
                            _showStatusUpdateDialog(context, order);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStatusUpdateDialog(BuildContext context, OrderEntity order) {
    OrderStatus? selectedStatus = order.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar Estado'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Selecciona el nuevo estado del pedido:'),
                const SizedBox(height: 16),
                ...OrderStatus.values.map((status) => RadioListTile<OrderStatus>(
                  title: Text(_getStatusText(status)),
                  value: status,
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                )),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar actualización de estado
              _showNotImplementedSnackBar(
                context,
                'Actualizar estado a ${_getStatusText(selectedStatus!)}',
              );
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, OrderStatus status) {
    // Definir color y texto según el estado
    Color chipColor;
    String statusText = _getStatusText(status);

    switch (status) {
      case OrderStatus.pending:
        chipColor = Colors.orange;
        break;
      case OrderStatus.confirmed:
        chipColor = Colors.blue;
        break;
      case OrderStatus.processing:
        chipColor = Colors.purple;
        break;
      case OrderStatus.shipped:
        chipColor = Colors.indigo;
        break;
      case OrderStatus.delivered:
        chipColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        chipColor = Colors.red;
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

  void _showNotImplementedSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidad de "$feature" no implementada aún'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}