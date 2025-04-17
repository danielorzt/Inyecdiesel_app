// Ruta: lib/features/products/data/models/product_model.dart

import 'dart:convert';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

/// Modelo de producto que extiende de la entidad
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    required super.tags,
  });

  /// Crear una copia con datos actualizados
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    int? stock,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
    );
  }

  /// Convertir a mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'tags': tags,
    };
  }

  /// Crear modelo desde un mapa (deserialización)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is int) ? (map['price'] as int).toDouble() : map['price'] ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  /// Convertir a JSON
  String toJson() => json.encode(toMap());

  /// Crear modelo desde JSON
  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));
}