// Ruta: lib/features/products/presentation/screens/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_bloc.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_event.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_state.dart';
import 'package:inyecdiesel_eco/features/products/presentation/widgets/product_card.dart';
import 'package:inyecdiesel_eco/features/products/presentation/widgets/product_grid_loading.dart';
import 'package:inyecdiesel_eco/core/widgets/search_bar_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ProductsBloc>()..add(LoadProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InyecDiesel Eco'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => context.push(RouteConstants.cart),
            ),
          ],
        ),
        body: Column(
          children: [
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
            // Categorías horizontales
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('Todos', onTap: () {
                    context.read<ProductsBloc>().add(LoadProducts());
                  }),
                  _buildCategoryChip('Bombas', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Bombas'));
                  }),
                  _buildCategoryChip('Inyectores', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Inyectores'));
                  }),
                  _buildCategoryChip('Sensores', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Sensores'));
                  }),
                  _buildCategoryChip('Válvulas', onTap: () {
                    context.read<ProductsBloc>().add(LoadProductsByCategory('Válvulas'));
                  }),
                ],
              ),
            ),
            // Contenido principal
            Expanded(
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const ProductGridLoading();
                  } else if (state is ProductsLoaded) {
                    return _buildProductsGrid(state.products);
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
                  // Estado inicial o cualquier otro
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildProductsGrid(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text('No se encontraron productos'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () {
            context.push('${RouteConstants.productDetails}/${product.id}');
          },
        );
      },
    );
  }
}

// Ruta: lib/features/products/presentation/screens/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:inyecdiesel_eco/features/cart/presentation/bloc/cart_event.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_product_by_id.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/product_detail_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ProductDetailBloc>()
        ..add(LoadProductDetail(
          Params(id: productId),
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de producto'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => context.push(RouteConstants.cart),
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailLoaded) {
              return _buildProductDetail(context, state.product);
            } else if (state is ProductDetailError) {
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
                        context.read<ProductDetailBloc>().add(
                          LoadProductDetail(Params(id: productId)),
                        );
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, ProductEntity product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Hero(
              tag: 'product_image_${product.id}',
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
          ),

          // Información del producto
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y precio
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // Categoría
                Chip(
                  label: Text(product.category),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),

                const SizedBox(height: 16),

                // Descripción
                Text(
                  'Descripción',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 16),

                // Disponibilidad
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined),
                    const SizedBox(width: 8),
                    Text(
                      product.stock > 0
                          ? 'Disponible: ${product.stock} unidades'
                          : 'No disponible',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: product.stock > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Etiquetas
                if (product.tags.isNotEmpty) ...[
                  Text(
                    'Etiquetas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: product.tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Botón de agregar al carrito
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: product.stock > 0
                        ? () {
                      context.read<CartBloc>().add(
                        AddItemToCart(
                          product: product,
                          quantity: 1,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.name} añadido al carrito',
                          ),
                          action: SnackBarAction(
                            label: 'Ver Carrito',
                            onPressed: () {
                              context.push(RouteConstants.cart);
                            },
                          ),
                        ),
                      );
                    }
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Agregar al carrito'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}