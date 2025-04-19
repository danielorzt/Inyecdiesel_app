// Ruta: lib/features/orders/presentation/bloc/orders_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inyecdiesel_eco/features/orders/domain/usecases/get_orders.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_event.dart';
import 'package:inyecdiesel_eco/features/orders/presentation/bloc/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders getOrders;

  OrdersBloc({required this.getOrders}) : super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
    on<SearchOrders>(_onSearchOrders);
  }

  Future<void> _onLoadOrders(
      LoadOrders event,
      Emitter<OrdersState> emit,
      ) async {
    emit(OrdersLoading());
    final result = await getOrders();
    result.fold(
          (failure) => emit(OrdersError('No se pudieron cargar los pedidos')),
          (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onFilterOrdersByStatus(
      FilterOrdersByStatus event,
      Emitter<OrdersState> emit,
      ) async {
    emit(OrdersLoading());
    final result = await getOrders();
    result.fold(
          (failure) => emit(OrdersError('No se pudieron cargar los pedidos')),
          (orders) {
        if (event.status == null) {
          emit(OrdersLoaded(orders));
        } else {
          final filteredOrders = orders.where((order) => order.status == event.status).toList();
          emit(OrdersLoaded(filteredOrders));
        }
      },
    );
  }

  Future<void> _onSearchOrders(
      SearchOrders event,
      Emitter<OrdersState> emit,
      ) async {
    emit(OrdersLoading());
    final result = await getOrders();
    result.fold(
          (failure) => emit(OrdersError('No se pudieron cargar los pedidos')),
          (orders) {
        if (event.query.isEmpty) {
          emit(OrdersLoaded(orders));
        } else {
          // Búsqueda por ID o por productos
          final filteredOrders = orders.where((order) {
            // Buscar por ID
            if (order.id.toLowerCase().contains(event.query.toLowerCase())) {
              return true;
            }

            // Buscar en los productos del pedido
            return order.items.any((item) =>
                item.product.name.toLowerCase().contains(event.query.toLowerCase()));
          }).toList();

          emit(OrdersLoaded(filteredOrders));
        }
      },
    );
  }
}