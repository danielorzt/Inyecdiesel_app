// Ruta: lib/features/products/data/datasources/product_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/core/network/dio_client.dart';
import 'package:inyecdiesel_eco/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get('/products');

      if (response.statusCode == 200) {
        final List<dynamic> productsList = response.data['data'];
        return productsList
            .map((json) => ProductModel.fromMap(json))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await client.get('/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromMap(response.data['data']);
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await client.get(
        '/products',
        queryParameters: {'category': category},
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsList = response.data['data'];
        return productsList
            .map((json) => ProductModel.fromMap(json))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await client.get(
        '/products/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsList = response.data['data'];
        return productsList
            .map((json) => ProductModel.fromMap(json))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }
}

// Ruta: lib/features/products/data/datasources/product_local_data_source.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inyecdiesel_eco/core/errors/exceptions.dart';
import 'package:inyecdiesel_eco/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  /// Obtener todos los productos cacheados
  Future<List<ProductModel>> getLastProducts();

  /// Obtener un producto específico por ID
  Future<ProductModel> getProductById(String id);

  /// Obtener productos por categoría
  Future<List<ProductModel>> getProductsByCategory(String category);

  /// Buscar productos
  Future<List<ProductModel>> searchProducts(String query);

  /// Guardar productos en cache
  Future<void> cacheProducts(List<ProductModel> products);

  /// Guardar un producto específico en cache
  Future<void> cacheProduct(ProductModel product);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCTS');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => ProductModel.fromMap(item)).toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final allProducts = await getLastProducts();
    final product = allProducts.firstWhere(
          (product) => product.id == id,
      orElse: () => throw CacheException(),
    );
    return product;
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final allProducts = await getLastProducts();
    final filteredProducts = allProducts.where(
            (product) => product.category == category
    ).toList();

    if (filteredProducts.isEmpty) {
      throw CacheException();
    }

    return filteredProducts;
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final allProducts = await getLastProducts();
    final lowercaseQuery = query.toLowerCase();

    final filteredProducts = allProducts.where((product) =>
    product.name.toLowerCase().contains(lowercaseQuery) ||
        product.description.toLowerCase().contains(lowercaseQuery) ||
        product.category.toLowerCase().contains(lowercaseQuery) ||
        product.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();

    return filteredProducts;
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final List<Map<String, dynamic>> jsonList =
    products.map((product) => product.toMap()).toList();
    await sharedPreferences.setString(
      'CACHED_PRODUCTS',
      json.encode(jsonList),
    );
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final currentProducts = await getLastProducts();
      final index = currentProducts.indexWhere((p) => p.id == product.id);

      if (index >= 0) {
        currentProducts[index] = product;
      } else {
        currentProducts.add(product);
      }

      await cacheProducts(currentProducts);
    } on CacheException {
      await cacheProducts([product]);
    }
  }
}