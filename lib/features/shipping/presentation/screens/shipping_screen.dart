// Ruta: lib/features/shipping/presentation/screens/shipping_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_bloc.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_event.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_state.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/widgets/shipping_form.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/widgets/shipping_status_chip.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _filterShippingsByTab(_tabController.index);
      }
    });
  }

  void _filterShippingsByTab(int tabIndex) {
    // Obtener el bloc
    final shippingBloc = context.read<ShippingBloc>();

    switch (tabIndex) {
      case 0: // Todos
        shippingBloc.add(LoadShippings());
        break;
      case 1: // Pendientes
        shippingBloc.add(FilterShippingsByStatus(ShippingStatus.pending));
        break;
      case 2: // En tránsito
        shippingBloc.add(FilterShippingsByStatus(ShippingStatus.inTransit));
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
      create: (_) => GetIt.instance<ShippingBloc>()..add(LoadShippings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Envíos'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Todos'),
              Tab(text: 'Pendientes'),
              Tab(text: 'En Tránsito'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por orden o número de guía...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ShippingBloc>().add(LoadShippings());
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
                    context.read<ShippingBloc>().add(SearchShippings(value));
                  } else {
                    context.read<ShippingBloc>().add(LoadShippings());
                  }
                },
              ),
            ),

            // Lista de envíos
            Expanded(
              child: BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  if (state is ShippingLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ShippingLoaded) {
                    if (state.shippings.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron envíos'),
                      );
                    }
                    return _buildShippingsList(context, state.shippings);
                  } else if (state is ShippingError) {
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
                              context.read<ShippingBloc>().add(LoadShippings());
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
        // Botón para crear un nuevo envío
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateShippingDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildShippingsList(BuildContext context, List<ShippingEntity> shippings) {
    // Ordenar por fecha, más recientes primero
    final sortedShippings = List<ShippingEntity>.from(shippings)
      ..sort((a, b) => b.shippingDate.compareTo(a.shippingDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedShippings.length,
      itemBuilder: (context, index) {
        final shipping = sortedShippings[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado: ID de orden y fecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Orden #${shipping.orderId}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(shipping.shippingDate),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Información de envío
                Row(
                  children: [
                    const Icon(Icons.local_shipping, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      shipping.carrier,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.numbers, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Guía: ${shipping.trackingNumber}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                if (shipping.receiverName != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Receptor: ${shipping.receiverName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                // Estado y acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShippingStatusChip(status: shipping.status),

                    Row(
                      children: [
                        // Botón para editar
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditShippingDialog(context, shipping);
                          },
                        ),

                        // Botón para actualizar estado
                        IconButton(
                          icon: const Icon(Icons.update),
                          onPressed: () {
                            _showUpdateStatusDialog(context, shipping);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                // Notas si existen
                if (shipping.notes != null && shipping.notes!.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    'Notas:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    shipping.notes!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateShippingDialog(BuildContext context) {
    // Mostrar un diálogo con el formulario para asignar guía de envío
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asignar Guía de Envío'),
        content: ShippingForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showEditShippingDialog(BuildContext context, ShippingEntity shipping) {
    // Mostrar un diálogo con el formulario para editar un envío
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Envío'),
        content: ShippingForm(shipping: shipping),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, ShippingEntity shipping) {
    ShippingStatus? selectedStatus = shipping.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar Estado'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Selecciona el nuevo estado del envío:'),
                const SizedBox(height: 16),
                ...ShippingStatus.values.map((status) => RadioListTile<ShippingStatus>(
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
              // Aquí se llamaría al bloc para actualizar el estado
              _showNotImplementedSnackBar(context, 'Actualizar estado');
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(ShippingStatus status) {
    switch (status) {
      case ShippingStatus.pending:
        return 'Pendiente';
      case ShippingStatus.inTransit:
        return 'En tránsito';
      case ShippingStatus.delivered:
        return 'Entregado';
      case ShippingStatus.returned:
        return 'Devuelto';
      case ShippingStatus.lost:
        return 'Perdido';
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