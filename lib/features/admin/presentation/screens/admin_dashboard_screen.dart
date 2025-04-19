// Ruta: lib/features/admin/presentation/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/config/app_theme.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/widgets/dashboard_card.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/widgets/recent_orders_widget.dart';
import 'package:inyecdiesel_eco/features/admin/presentation/widgets/inventory_alert_widget.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo y fecha
            Text(
              'Bienvenido, Admin',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Aquí está el resumen de hoy',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            // Tarjetas de estadísticas
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardCard(
                  title: 'Pedidos Pendientes',
                  value: '12',
                  icon: Icons.pending_actions,
                  color: AppTheme.primaryRed,
                  onTap: () => context.push(RouteConstants.adminOrders),
                ),
                DashboardCard(
                  title: 'Total Ventas',
                  value: '\$13,485',
                  icon: Icons.attach_money,
                  color: AppTheme.successGreen,
                  onTap: () => context.push(RouteConstants.adminAnalytics),
                ),
                DashboardCard(
                  title: 'Productos',
                  value: '48',
                  icon: Icons.inventory_2,
                  color: AppTheme.darkBlue,
                  onTap: () => context.push(RouteConstants.adminProducts),
                ),
                DashboardCard(
                  title: 'Bajo Inventario',
                  value: '7',
                  icon: Icons.warning_amber,
                  color: Colors.amber,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Pedidos recientes
            const Text(
              'Pedidos Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const RecentOrdersWidget(),

            const SizedBox(height: 24),

            // Alertas de inventario
            const Text(
              'Alertas de Inventario',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const InventoryAlertWidget(),
          ],
        ),
      ),
    );
  }
}