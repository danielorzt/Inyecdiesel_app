// Ruta: lib/features/shipping/presentation/widgets/shipping_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_bloc.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_event.dart';

class ShippingForm extends StatefulWidget {
  final ShippingEntity? shipping;

  ShippingForm({Key? key, this.shipping}) : super(key: key);

  @override
  State<ShippingForm> createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _orderIdController;
  late final TextEditingController _trackingNumberController;
  late final TextEditingController _carrierController;
  late final TextEditingController _receiverNameController;
  late final TextEditingController _notesController;

  late ShippingStatus _selectedStatus;
  late DateTime _shippingDate;
  DateTime? _deliveryDate;

  @override
  void initState() {
    super.initState();

    // Inicializar con datos existentes o valores por defecto
    _orderIdController = TextEditingController(text: widget.shipping?.orderId ?? '');
    _trackingNumberController = TextEditingController(text: widget.shipping?.trackingNumber ?? '');
    _carrierController = TextEditingController(text: widget.shipping?.carrier ?? '');
    _receiverNameController = TextEditingController(text: widget.shipping?.receiverName ?? '');
    _notesController = TextEditingController(text: widget.shipping?.notes ?? '');

    _selectedStatus = widget.shipping?.status ?? ShippingStatus.pending;
    _shippingDate = widget.shipping?.shippingDate ?? DateTime.now();
    _deliveryDate = widget.shipping?.deliveryDate;
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    _trackingNumberController.dispose();
    _carrierController.dispose();
    _receiverNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID de Orden
            TextFormField(
              controller: _orderIdController,
              decoration: const InputDecoration(
                labelText: 'ID de Orden *',
                hintText: 'Ingresa el ID de la orden',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el ID de la orden';
                }
                return null;
              },
              enabled: widget.shipping == null, // Solo editable si es nuevo
            ),
            const SizedBox(height: 16),

            // Número de Guía
            TextFormField(
              controller: _trackingNumberController,
              decoration: const InputDecoration(
                labelText: 'Número de Guía *',
                hintText: 'Ingresa el número de guía',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el número de guía';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Transportista
            TextFormField(
              controller: _carrierController,
              decoration: const InputDecoration(
                labelText: 'Transportista *',
                hintText: 'Ingresa el nombre del transportista',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre del transportista';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Receptor
            TextFormField(
              controller: _receiverNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Receptor',
                hintText: 'Ingresa el nombre del receptor (opcional)',
              ),
            ),
            const SizedBox(height: 16),

            // Estado
            DropdownButtonFormField<ShippingStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Estado *',
              ),
              items: ShippingStatus.values.map((status) {
                return DropdownMenuItem<ShippingStatus>(
                  value: status,
                  child: Text(_getStatusText(status)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;

                  // Si el estado es "Entregado", establecer la fecha de entrega
                  if (value == ShippingStatus.delivered && _deliveryDate == null) {
                    _deliveryDate = DateTime.now();
                  }

                  // Si el estado no es "Entregado", limpiar la fecha de entrega
                  if (value != ShippingStatus.delivered) {
                    _deliveryDate = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Fecha de Envío
            GestureDetector(
              onTap: () => _selectShippingDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Envío *',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _formatDate(_shippingDate),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona la fecha de envío';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fecha de Entrega (solo si el estado es "Entregado")
            if (_selectedStatus == ShippingStatus.delivered)
              GestureDetector(
                onTap: () => _selectDeliveryDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Entrega *',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _deliveryDate != null ? _formatDate(_deliveryDate!) : '',
                    ),
                    validator: (value) {
                      if (_selectedStatus == ShippingStatus.delivered &&
                          (value == null || value.isEmpty)) {
                        return 'Por favor selecciona la fecha de entrega';
                      }
                      return null;
                    },
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Notas
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas',
                hintText: 'Ingresa notas adicionales (opcional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.shipping == null ? 'Crear Envío' : 'Actualizar Envío'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectShippingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _shippingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _shippingDate) {
      setState(() {
        _shippingDate = picked;
      });
    }
  }

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? DateTime.now(),
      firstDate: _shippingDate,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí se implementaría la lógica para guardar o actualizar
      // el envío, usando el bloc para manejar la acción

      // Si estamos editando un envío existente
      if (widget.shipping != null) {
        // Implementar la actualización
        _showNotImplementedSnackBar(context, 'Actualizar envío');
      } else {
        // Implementar la creación
        _showNotImplementedSnackBar(context, 'Crear nuevo envío');
      }

      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getStatusText(ShippingStatus status) {
    switch (status) {
      case ShippingStatus.pending:
        return 'Pendiente';
      case ShippingStatus.inTransit:
        return 'En tránsito';
      case ShippingStatus.delivered:
        return 'Entregado';
      case ShippingStatus.returned:
        return 'Devuelto';
      case ShippingStatus.lost:
        return 'Perdido';
    }
  }

  void _showNotImplementedSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidad de "$feature" no implementada aún'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}