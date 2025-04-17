// Ruta: lib/features/products/domain/usecases/get_products.dart

import 'package:dartz/dartz.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/repositories/product_repository.dart';

/// Caso de uso para obtener todos los productos
class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}

// Ruta: lib/features/products/domain/usecases/get_product_by_id.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/repositories/product_repository.dart';

/// Caso de uso para obtener un producto por ID
class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<Either<Failure, ProductEntity>> call(Params params) {
    return repository.getProductById(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object?> get props => [id];
}

// Ruta: lib/features/products/domain/usecases/get_products_by_category.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/repositories/product_repository.dart';

/// Caso de uso para obtener productos por categoría
class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(Params params) {
    return repository.getProductsByCategory(params.category);
  }
}

class Params extends Equatable {
  final String category;

  const Params({required this.category});

  @override
  List<Object?> get props => [category];
}

// Ruta: lib/features/products/domain/usecases/search_products.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/core/errors/failure.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';
import 'package:inyecdiesel_eco/features/products/domain/repositories/product_repository.dart';

/// Caso de uso para buscar productos
class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(Params params) {
    return repository.searchProducts(params.query);
  }
}

class Params extends Equatable {
  final String query;

  const Params({required this.query});

  @override
  List<Object?> get props => [query];
}