// Ruta: lib/features/shipping/presentation/bloc/shipping_detail_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/get_shipping_by_id.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/update_shipping_status.dart';

// Events
abstract class ShippingDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShippingDetail extends ShippingDetailEvent {
  final String id;

  LoadShippingDetail({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateStatus extends ShippingDetailEvent {
  final String id;
  final ShippingStatus status;

  UpdateStatus({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

// States
abstract class ShippingDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShippingDetailInitial extends ShippingDetailState {}

class ShippingDetailLoading extends ShippingDetailState {}

class ShippingDetailLoaded extends ShippingDetailState {
  final ShippingEntity shipping;

  ShippingDetailLoaded({required this.shipping});

  @override
  List<Object?> get props => [shipping];
}

class ShippingDetailError extends ShippingDetailState {
  final String message;

  ShippingDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StatusUpdateSuccess extends ShippingDetailState {
  final ShippingEntity shipping;

  StatusUpdateSuccess({required this.shipping});

  @override
  List<Object?> get props => [shipping];
}

class StatusUpdateError extends ShippingDetailState {
  final String message;

  StatusUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class ShippingDetailBloc extends Bloc<ShippingDetailEvent, ShippingDetailState> {
  final GetShippingById getShippingById;
  final UpdateShippingStatus updateShippingStatus;

  ShippingDetailBloc({
    required this.getShippingById,
    required this.updateShippingStatus,
  }) : super(ShippingDetailInitial()) {
    on<LoadShippingDetail>(_onLoadShippingDetail);
    on<UpdateStatus>(_onUpdateStatus);
  }

  Future<void> _onLoadShippingDetail(
      LoadShippingDetail event,
      Emitter<ShippingDetailState> emit,
      ) async {
    emit(ShippingDetailLoading());
    final result = await getShippingById(GetShippingById.Params(id: event.id));
    result.fold(
          (failure) => emit(ShippingDetailError(message: 'Error al cargar los detalles del envío')),
          (shipping) => emit(ShippingDetailLoaded(shipping: shipping)),
    );
  }

  Future<void> _onUpdateStatus(
      UpdateStatus event,
      Emitter<ShippingDetailState> emit,
      ) async {
    emit(ShippingDetailLoading());
    final result = await updateShippingStatus(
      UpdateShippingStatus.Params(id: event.id, status: event.status),
    );
    result.fold(
          (failure) => emit(StatusUpdateError(message: 'Error al actualizar el estado del envío')),
          (shipping) => emit(StatusUpdateSuccess(shipping: shipping)),
    );
  }
}

// Ruta: lib/features/shipping/presentation/bloc/shipping_form_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/entities/shipping_entity.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/create_shipping.dart';
import 'package:inyecdiesel_eco/features/shipping/domain/usecases/update_shipping.dart';

// Events
abstract class ShippingFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateNewShipping extends ShippingFormEvent {
  final ShippingEntity shipping;

  CreateNewShipping({required this.shipping});

  @override
  List<Object?> get props => [shipping];
}

class UpdateExistingShipping extends ShippingFormEvent {
  final ShippingEntity shipping;

  UpdateExistingShipping({required this.shipping});

  @override
  List<Object?> get props => [shipping];
}

// States
abstract class ShippingFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShippingFormInitial extends ShippingFormState {}

class ShippingFormLoading extends ShippingFormState {}

class ShippingFormSuccess extends ShippingFormState {
  final ShippingEntity shipping;
  final bool isCreated;

  ShippingFormSuccess({
    required this.shipping,
    required this.isCreated,
  });

  @override
  List<Object?> get props => [shipping, isCreated];
}

class ShippingFormError extends ShippingFormState {
  final String message;

  ShippingFormError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class ShippingFormBloc extends Bloc<ShippingFormEvent, ShippingFormState> {
  final CreateShipping createShipping;
  final UpdateShipping updateShipping;

  ShippingFormBloc({
    required this.createShipping,
    required this.updateShipping,
  }) : super(ShippingFormInitial()) {
    on<CreateNewShipping>(_onCreateNewShipping);
    on<UpdateExistingShipping>(_onUpdateExistingShipping);
  }

  Future<void> _onCreateNewShipping(
      CreateNewShipping event,
      Emitter<ShippingFormState> emit,
      ) async {
    emit(ShippingFormLoading());
    final result = await createShipping(event.shipping);
    result.fold(
          (failure) => emit(ShippingFormError(message: 'Error al crear el envío')),
          (shipping) => emit(ShippingFormSuccess(shipping: shipping, isCreated: true)),
    );
  }

  Future<void> _onUpdateExistingShipping(
      UpdateExistingShipping event,
      Emitter<ShippingFormState> emit,
      ) async {
    emit(ShippingFormLoading());
    final result = await updateShipping(event.shipping);
    result.fold(
          (failure) => emit(ShippingFormError(message: 'Error al actualizar el envío')),
          (shipping) => emit(ShippingFormSuccess(shipping: shipping, isCreated: false)),
    );
  }
}