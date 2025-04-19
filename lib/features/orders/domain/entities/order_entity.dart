// Ruta: lib/features/orders/domain/entities/order_entity.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/cart/domain/entities/cart_item_entity.dart';

enum OrderStatus {
  pending,     // Pedido realizado pero no confirmado
  confirmed,   // Pedido confirmado por el vendedor
  processing,  // Pedido en proceso de preparación
  shipped,     // Pedido enviado
  delivered,   // Pedido entregado
  cancelled,   // Pedido cancelado
}

class OrderEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final DateTime date;
  final double totalAmount;
  final OrderStatus status;
  final String? trackingNumber;
  final String? shippingCarrier;
  final String? notes;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.date,
    required this.totalAmount,
    required this.status,
    this.trackingNumber,
    this.shippingCarrier,
    this.notes,
  });

  int get totalItems => items.fold(
    0,
        (sum, item) => sum + item.quantity,
  );

  @override
  List<Object?> get props => [
    id,
    items,
    date,
    totalAmount,
    status,
    trackingNumber,
    shippingCarrier,
  ];
}