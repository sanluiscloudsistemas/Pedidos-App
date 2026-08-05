import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import 'catalogo_screen.dart';
import 'faltantes_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: false,
      ),
      drawer: const PreventaDrawer(),
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
    final cardBgColor = item.isSelected ? AppColors.lightRedBg : Colors.white;

    return Container(
      decoration: AppStyles.cardDecoration(
        backgroundColor: cardBgColor,
        borderColor: item.isSelected ? AppColors.primaryRed : AppColors.cardBorder,
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
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
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
