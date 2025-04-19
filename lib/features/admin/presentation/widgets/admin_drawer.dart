// Ruta: lib/features/admin/presentation/widgets/admin_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inyecdiesel_eco/core/config/app_theme.dart';
import 'package:inyecdiesel_eco/core/constants/route_constants.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar la ruta actual
    final String currentRoute = GoRouterState.of(context).fullPath ?? '';

    return Drawer(
      child: Column(
        children: [
          // Encabezado del drawer
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.darkBlue,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppTheme.primaryRed,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 36,
              ),
            ),
            accountName: const Text(
              'Administrador',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: const Text(
              'admin@inyecdieseleco.com',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),

          // Menú de opciones
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Panel de Control',
            route: RouteConstants.adminDashboard,
            currentRoute: currentRoute,
          ),

          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            title: 'Productos',
            route: RouteConstants.adminProducts,
            currentRoute: currentRoute,
          ),

          _buildDrawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Pedidos',
            route: RouteConstants.adminOrders,
            currentRoute: currentRoute,
          ),

          _buildDrawerItem(
            context,
            icon: Icons.analytics,
            title: 'Estadísticas',
            route: RouteConstants.adminAnalytics,
            currentRoute: currentRoute,
          ),

          const Divider(),

          // Vista previa de cliente
          _buildDrawerItem(
            context,
            icon: Icons.storefront,
            title: 'Vista de Tienda',
            route: RouteConstants.home,
            currentRoute: currentRoute,
          ),

          const Spacer(),

          // Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              // Implementar lógica de cierre de sesión
              context.go(RouteConstants.login);
            },
          ),

          // Información de versión
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        required String currentRoute,
      }) {
    // Verificar si el elemento está activo
    final bool isActive = currentRoute.startsWith(route);

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppTheme.primaryRed : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppTheme.primaryRed : null,
          fontWeight: isActive ? FontWeight.bold : null,
        ),
      ),
      onTap: () {
        // Cerrar el drawer
        Navigator.pop(context);

        // Navegar a la ruta si no estamos ya en ella
        if (!isActive) {
          context.go(route);
        }
      },
    );
  }
}