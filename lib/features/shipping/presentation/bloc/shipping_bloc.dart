// Ruta: lib/features/shipping/presentation/bloc/shipping_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/get_shippings.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_event.dart';
import 'package:inyecdiesel_eco/features/shipping/presentation/bloc/shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final GetShippings getShippings;

  ShippingBloc({required this.getShippings}) : super(ShippingInitial()) {
    on<LoadShippings>(_onLoadShippings);
    on<FilterShippingsByStatus>(_onFilterShippingsByStatus);
    on<SearchShippings>(_onSearchShippings);
    on<CreateShipping>(_onCreateShipping);
    on<UpdateShipping>(_onUpdateShipping);
  }

  Future<void> _onLoadShippings(
      LoadShippings event,
      Emitter<ShippingState> emit,
      ) async {
    emit(ShippingLoading());
    final result = await getShippings();
    result.fold(
          (failure) => emit(ShippingError('No se pudieron cargar los envíos')),
          (shippings) => emit(ShippingLoaded(shippings)),
    );
  }

  Future<void> _onFilterShippingsByStatus(
      FilterShippingsByStatus event,
      Emitter<ShippingState> emit,
      ) async {
    emit(ShippingLoading());
    final result = await getShippings();
    result.fold(
          (failure) => emit(ShippingError('No se pudieron cargar los envíos')),
          (shippings) {
        final filteredShippings = shippings
            .where((shipping) => shipping.status == event.status)
            .toList();
        emit(ShippingLoaded(filteredShippings));
      },
    );
  }

  Future<void> _onSearchShippings(
      SearchShippings event,
      Emitter<ShippingState> emit,
      ) async {
    emit(ShippingLoading());
    final result = await getShippings();
    result.fold(
          (failure) => emit(ShippingError('No se pudieron cargar los envíos')),
          (shippings) {
        final query = event.query.toLowerCase();
        final filteredShippings = shippings.where((shipping) {
          return shipping.orderId.toLowerCase().contains(query) ||
              shipping.trackingNumber.toLowerCase().contains(query) ||
              shipping.carrier.toLowerCase().contains(query);
        }).toList();
        emit(ShippingLoaded(filteredShippings));
      },
    );
  }

  Future<void> _onCreateShipping(
      CreateShipping event,
      Emitter<ShippingState> emit,
      ) async {
    // Implementar la lógica para crear un nuevo envío
    // Este método sería completado cuando se implemente la funcionalidad
  }

  Future<void> _onUpdateShipping(
      UpdateShipping event,
      Emitter<ShippingState> emit,
      ) async {
    // Implementar la lógica para actualizar un envío existente
    // Este método sería completado cuando se implemente la funcionalidad
  }
}

// Ruta: lib/features/shipping/presentation/bloc/shipping_event.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';

abstract class ShippingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShippings extends ShippingEvent {}

class FilterShippingsByStatus extends ShippingEvent {
  final ShippingStatus status;

  FilterShippingsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchShippings extends ShippingEvent {
  final String query;

  SearchShippings(this.query);

  @override
  List<Object?> get props => [query];
}

class CreateShipping extends ShippingEvent {
  final ShippingEntity shipping;

  CreateShipping(this.shipping);

  @override
  List<Object?> get props => [shipping];
}

class UpdateShipping extends ShippingEvent {
  final ShippingEntity shipping;

  UpdateShipping(this.shipping);

  @override
  List<Object?> get props => [shipping];
}

// Ruta: lib/features/shipping/presentation/bloc/shipping_state.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';

abstract class ShippingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingLoaded extends ShippingState {
  final List<ShippingEntity> shippings;

  ShippingLoaded(this.shippings);

  @override
  List<Object?> get props => [shippings];
}

class ShippingError extends ShippingState {
  final String message;

  ShippingError(this.message);

  @override
  List<Object?> get props => [message];
}

class ShippingCreated extends ShippingState {
  final ShippingEntity shipping;

  ShippingCreated(this.shipping);

  @override
  List<Object?> get props => [shipping];
}

class ShippingUpdated extends ShippingState {
  final ShippingEntity shipping;

  ShippingUpdated(this.shipping);

  @override
  List<Object?> get props => [shipping];
}