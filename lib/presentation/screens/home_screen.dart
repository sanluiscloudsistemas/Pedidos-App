import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/auth_notifier.dart';
import 'catalogo_screen.dart';
import 'faltantes_screen.dart';
import 'login_screen.dart';
import 'mis_clientes_screen.dart';
import 'mis_pedidos_screen.dart';
import 'mis_repartos_screen.dart';
import 'nuevo_pedido_wizard_screen.dart';

/// Modelo de ítem para el menú de la pantalla principal (Home)
class HomeMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Widget? targetScreen;

  const HomeMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSelected = false,
    this.targetScreen,
  });
}

/// Pantalla Principal (Home) de la Aplicación de Preventas (`PEDIDOS`)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<HomeMenuItem> get _menuItems => const [
        HomeMenuItem(
          title: 'Agregar Pedido',
          subtitle: 'Pedido de un Cliente para un Reparto',
          icon: Icons.post_add,
          targetScreen: NuevoPedidoWizardScreen(),
        ),
        HomeMenuItem(
          title: 'Mis Pedidos',
          subtitle: 'Pedidos de mis clientes para Repartos',
          icon: Icons.shopping_cart,
          targetScreen: MisPedidosScreen(),
        ),
        HomeMenuItem(
          title: 'Catálogo',
          subtitle: 'Catálogo de Productos',
          icon: Icons.menu_book,
          targetScreen: CatalogoScreen(),
        ),
        HomeMenuItem(
          title: 'Mis Clientes',
          subtitle: 'Clientes para visitar',
          icon: Icons.import_contacts,
          targetScreen: MisClientesScreen(),
        ),
        HomeMenuItem(
          title: 'Mis Repartos',
          subtitle: 'Repartos habilitados',
          icon: Icons.local_shipping,
          isSelected: true,
          targetScreen: MisRepartosScreen(),
        ),
        HomeMenuItem(
          title: 'Faltantes',
          subtitle: 'Productos en falta o incluir en los pedidos',
          icon: Icons.remove_shopping_cart,
          targetScreen: FaltantesScreen(),
        ),
      ];

  void _handleLogout(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    authNotifier.logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 1,
        titleSpacing: 0,
        leading: Builder(
          builder: (scaffoldContext) {
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 20),
                onPressed: () {
                  Scaffold.of(scaffoldContext).openDrawer();
                },
              ),
            );
          },
        ),
        title: const Text(
          'PEDIDOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download_outlined, color: Colors.white, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sincronizando datos con la nube...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.help_outline, color: Colors.white, size: 20),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              SizedBox(width: 8),
            ],
          ),
          PopupMenuButton<String>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person_outline, color: Colors.white, size: 20),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              ],
            ),
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Mi Perfil'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFD32F2F)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28,
                    child: Icon(Icons.person, color: Color(0xFFD32F2F), size: 32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Menú Preventas',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFD32F2F)),
              title: const Text('Inicio / Pedidos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Color(0xFFD32F2F)),
              title: const Text('Mis Pedidos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MisPedidosScreen()),
                );
              },
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
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _menuItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildHomeMenuItemCard(context, item);
        },
      ),
    );
  }

  Widget _buildHomeMenuItemCard(BuildContext context, HomeMenuItem item) {
    final cardBgColor = item.isSelected ? const Color(0xFFFFEBEE) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            if (item.targetScreen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.targetScreen!),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navegando a ${item.title}...')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B2B2B),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD32F2F),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
