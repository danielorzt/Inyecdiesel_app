// Ruta: lib/features/shipping/domain/entities/shipping_entity.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';

enum ShippingStatus {
  pending,       // Pendiente de asignación de guía
  inTransit,     // En tránsito
  delivered,     // Entregado
  returned,      // Devuelto
  lost,          // Perdido
}

class ShippingEntity extends Equatable {
  final String id;
  final String orderId;
  final DateTime shippingDate;
  final ShippingStatus status;
  final String trackingNumber;
  final String carrier;
  final String? receiverName;
  final String? notes;
  final DateTime? deliveryDate;
  final String? assignedBy;

  const ShippingEntity({
    required this.id,
    required this.orderId,
    required this.shippingDate,
    required this.status,
    required this.trackingNumber,
    required this.carrier,
    this.receiverName,
    this.notes,
    this.deliveryDate,
    this.assignedBy,
  });

  // Método para verificar si el envío ha sido entregado
  bool get isDelivered => status == ShippingStatus.delivered;

  // Método para calcular los días en tránsito
  int get daysInTransit {
    if (status == ShippingStatus.delivered && deliveryDate != null) {
      return deliveryDate!.difference(shippingDate).inDays;
    } else if (status == ShippingStatus.pending) {
      return 0;
    } else {
      final now = DateTime.now();
      return now.difference(shippingDate).inDays;
    }
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    shippingDate,
    status,
    trackingNumber,
    carrier,
    deliveryDate,
  ];
}