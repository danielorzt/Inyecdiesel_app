// Ruta: lib/features/products/presentation/bloc/products_event.dart

import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {}

class LoadProductsByCategory extends ProductsEvent {
  final String category;

  LoadProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchProductsEvent extends ProductsEvent {
  final String query;

  SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// Ruta: lib/features/products/presentation/bloc/products_state.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;

  ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Ruta: lib/features/products/presentation/bloc/products_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_products.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_products_by_category.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/search_products.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_event.dart';
import 'package:inyecdiesel_eco/features/products/presentation/bloc/products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;
  final GetProductsByCategory getProductsByCategory;
  final SearchProducts searchProducts;

  ProductsBloc({
    required this.getProducts,
    required this.getProductsByCategory,
    required this.searchProducts,
  }) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductsState> emit,
      ) async {
    emit(ProductsLoading());
    final result = await getProducts();
    result.fold(
          (failure) => emit(ProductsError('No se pudieron cargar los productos')),
          (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onLoadProductsByCategory(
      LoadProductsByCategory event,
      Emitter<ProductsState> emit,
      ) async {
    emit(ProductsLoading());
    final result = await getProductsByCategory(
      GetProductsByCategory.Params(category: event.category),
    );
    result.fold(
          (failure) => emit(ProductsError('No se pudieron cargar los productos de esta categoría')),
          (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onSearchProducts(
      SearchProductsEvent event,
      Emitter<ProductsState> emit,
      ) async {
    emit(ProductsLoading());
    final result = await searchProducts(
      SearchProducts.Params(query: event.query),
    );
    result.fold(
          (failure) => emit(ProductsError('No se pudieron buscar los productos')),
          (products) => emit(ProductsLoaded(products)),
    );
  }
}