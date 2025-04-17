// Ruta: lib/features/products/presentation/bloc/product_detail_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/usecases/get_product_by_id.dart';

// Eventos
abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final Params params;

  LoadProductDetail(this.params);

  @override
  List<Object?> get props => [params];
}

// Estados
abstract class ProductDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductEntity product;

  ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductById getProductById;

  ProductDetailBloc({required this.getProductById}) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  Future<void> _onLoadProductDetail(
      LoadProductDetail event,
      Emitter<ProductDetailState> emit,
      ) async {
    emit(ProductDetailLoading());
    final result = await getProductById(event.params);

    result.fold(
          (failure) => emit(ProductDetailError('No se pudo cargar el detalle del producto')),
          (product) => emit(ProductDetailLoaded(product)),
    );
  }
}