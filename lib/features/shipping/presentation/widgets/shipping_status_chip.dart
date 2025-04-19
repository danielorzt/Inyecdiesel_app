// Ruta: lib/features/shipping/presentation/widgets/shipping_status_chip.dart

import 'package:flutter/material.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';

class ShippingStatusChip extends StatelessWidget {
  final ShippingStatus status;

  const ShippingStatusChip({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configurar color y texto según el estado
    Color chipColor;
    String statusText;

    switch (status) {
      case ShippingStatus.pending:
        chipColor = Colors.orange;
        statusText = 'Pendiente';
        break;
      case ShippingStatus.inTransit:
        chipColor = Colors.blue;
        statusText = 'En Tránsito';
        break;
      case ShippingStatus.delivered:
        chipColor = Colors.green;
        statusText = 'Entregado';
        break;
      case ShippingStatus.returned:
        chipColor = Colors.purple;
        statusText = 'Devuelto';
        break;
      case ShippingStatus.lost:
        chipColor = Colors.red;
        statusText = 'Perdido';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 16,
            color: chipColor,
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: chipColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(ShippingStatus status) {
    switch (status) {
      case ShippingStatus.pending:
        return Icons.schedule;
      case ShippingStatus.inTransit:
        return Icons.local_shipping;
      case ShippingStatus.delivered:
        return Icons.check_circle;
      case ShippingStatus.returned:
        return Icons.assignment_return;
      case ShippingStatus.lost:
        return Icons.error;
    }
  }
}