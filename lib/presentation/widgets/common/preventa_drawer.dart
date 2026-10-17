import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../notifiers/auth_notifier.dart';
import '../../screens/catalogo_screen.dart';
import '../../screens/faltantes_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/mis_clientes_screen.dart';
import '../../screens/mis_pedidos_screen.dart';
import '../../screens/mis_repartos_screen.dart';
import '../../screens/nuevo_pedido_wizard_screen.dart';

/// Menú lateral de navegación unificado (Drawer) para toda la aplicación.
class PreventaDrawer extends StatelessWidget {
  const PreventaDrawer({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    await authNotifier.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pop(context); // Cerrar el Drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final userName = authNotifier.authResponse?.usuario ?? 'Preventista';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryRed),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 26,
                  child: Icon(Icons.person, color: AppColors.primaryRed, size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Menú Preventas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Usuario: $userName',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: AppColors.primaryRed),
            title: const Text('Inicio / Panel Principal'),
            onTap: () => _navigateToScreen(context, const HomeScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.post_add, color: AppColors.primaryRed),
            title: const Text('Agregar Pedido'),
            onTap: () => _navigateToScreen(context, const NuevoPedidoWizardScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: AppColors.primaryRed),
            title: const Text('Mis Pedidos'),
            onTap: () => _navigateToScreen(context, const MisPedidosScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: AppColors.primaryRed),
            title: const Text('Catálogo de Productos'),
            onTap: () => _navigateToScreen(context, const CatalogoScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.import_contacts, color: AppColors.primaryRed),
            title: const Text('Mis Clientes'),
            onTap: () => _navigateToScreen(context, const MisClientesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping, color: AppColors.primaryRed),
            title: const Text('Mis Repartos'),
            onTap: () => _navigateToScreen(context, const MisRepartosScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.remove_shopping_cart, color: AppColors.primaryRed),
            title: const Text('Productos Faltantes'),
            onTap: () => _navigateToScreen(context, const FaltantesScreen()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }
}
