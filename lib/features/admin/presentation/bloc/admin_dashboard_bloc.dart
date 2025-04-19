// Ruta: lib/features/admin/presentation/bloc/admin_dashboard_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inyecdiesel_eco/features/admin/domain/entities/dashboard_stats_entity.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/get_dashboard_stats.dart';
import 'package:inyecdiesel_eco/features/admin/domain/usecases/get_inventory_alerts.dart';
import 'package:inyecdiesel_eco/features/products/domain/entities/product_entity.dart';

// Events
abstract class AdminDashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends AdminDashboardEvent {}

class LoadInventoryAlerts extends AdminDashboardEvent {}

// States
abstract class AdminDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardStatsLoaded extends AdminDashboardState {
  final DashboardStatsEntity stats;

  AdminDashboardStatsLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class AdminDashboardInventoryAlertsLoaded extends AdminDashboardState {
  final List<ProductEntity> products;

  AdminDashboardInventoryAlertsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class AdminDashboardError extends AdminDashboardState {
  final String message;

  AdminDashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetDashboardStats getDashboardStats;
  final GetInventoryAlerts getInventoryAlerts;

  AdminDashboardBloc({
    required this.getDashboardStats,
    required this.getInventoryAlerts,
  }) : super(AdminDashboardInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<LoadInventoryAlerts>(_onLoadInventoryAlerts);
  }

  Future<void> _onLoadDashboardStats(
      LoadDashboardStats event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    final result = await getDashboardStats();
    result.fold(
          (failure) => emit(AdminDashboardError(message: 'Error al cargar estadísticas')),
          (stats) => emit(AdminDashboardStatsLoaded(stats: stats)),
    );
  }

  Future<void> _onLoadInventoryAlerts(
      LoadInventoryAlerts event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    final result = await getInventoryAlerts();
    result.fold(
          (failure) => emit(AdminDashboardError(message: 'Error al cargar alertas de inventario')),
          (products) => emit(AdminDashboardInventoryAlertsLoaded(products: products)),
    );
  }
}