// Ruta: lib/features/orders/presentation/bloc/orders_event.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {}

class FilterOrdersByStatus extends OrdersEvent {
  final OrderStatus? status;

  FilterOrdersByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchOrders extends OrdersEvent {
  final String query;

  SearchOrders(this.query);

  @override
  List<Object?> get props => [query];
}

// Ruta: lib/features/orders/presentation/bloc/orders_state.dart

import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/orders/domain/entities/order_entity.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;

  OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}