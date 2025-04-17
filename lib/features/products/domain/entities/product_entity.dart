// Ruta: lib/features/products/domain/entities/product_entity.dart

import 'package:equatable/equatable.dart';

/// Entidad de producto
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final List<String> tags;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, name, price, category];
}