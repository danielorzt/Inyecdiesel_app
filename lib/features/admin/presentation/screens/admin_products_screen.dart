// Ruta: lib/features/admin/presentation/screens/admin_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_bloc.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_event.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_state.dart';
import 'package:inyecdiesel_eco/core/widgets/search_bar_widget.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ProductsBloc>()..add(LoadProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Productos'),
        ),
        drawer: const AdminDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navegar a la pantalla de creación de producto
            // context.push(RouteConstants.adminProductCreate);
            _showNotImplementedSnackBar(context, 'Crear nuevo producto');
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(
                onSearch: (query) {
                  if (query.isNotEmpty) {
                    context.read<ProductsBloc>().add(SearchProductsEvent(query));
                  } else {
                    context.read<ProductsBloc>().add(LoadProducts());
                  }
                },
              ),
            ),

            // Filtros de categoría
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip(context, 'Todos', onTap: () {
                    context.read<ProductsBloc>().add(LoadProducts());
                  }),
                  _buildCategoryChip(context, 'Bombas', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Bombas'));
                  }),
                  _buildCategoryChip(context, 'Inyectores', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Inyectores'));
                  }),
                  _buildCategoryChip(context, 'Sensores', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Sensores'));
                  }),
                  _buildCategoryChip(context, 'Válvulas', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Válvulas'));
                  }),
                ],
              ),
            ),

            // Lista de productos
            Expanded(
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ProductsLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron productos'),
                      );
                    }
                    return _buildProductsList(context, state.products);
                  } else if (state is ProductsError) {
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
                              context.read<ProductsBloc>().add(LoadProducts());
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

  Widget _buildCategoryChip(BuildContext context, String label, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List<ProductEntity> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categoría: ${product.category}'),
                Row(
                  children: [
                    Text('Stock: ${product.stock}'),
                    const SizedBox(width: 12),
                    Text('\$${product.price.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implementar edición de producto
                    _showNotImplementedSnackBar(context, 'Editar producto');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    // Mostrar diálogo de confirmación
                    _showDeleteConfirmationDialog(context, product);
                  },
                ),
              ],
            ),
            onTap: () {
              // Navegar al detalle del producto
              // context.push('${RouteConstants.adminProductDetail}/${product.id}');
              _showNotImplementedSnackBar(context, 'Ver detalles de producto');
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar el producto "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar eliminación de producto
              _showNotImplementedSnackBar(context, 'Eliminar producto');
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
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