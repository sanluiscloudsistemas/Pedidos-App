import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';

/// Modelo para los ítems del menú de Pedidos
class PedidoMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const PedidoMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });
}

/// Pantalla del Menú de Gestión de Pedidos (`PEDIDOS`)
class PedidosMenuScreen extends StatelessWidget {
  const PedidosMenuScreen({super.key});

  List<PedidoMenuItem> get _items => const [
        PedidoMenuItem(
          title: 'Agregar Pedido',
          subtitle: 'Pedido de un Cliente para un Reparto',
          icon: Icons.post_add,
        ),
        PedidoMenuItem(
          title: 'Mis Pedidos',
          subtitle: 'Pedidos de mis clientes para Repartos',
          icon: Icons.shopping_cart,
        ),
        PedidoMenuItem(
          title: 'Catálogo',
          subtitle: 'Catálogo de Productos',
          icon: Icons.menu_book,
        ),
        PedidoMenuItem(
          title: 'Mis Clientes',
          subtitle: 'Clientes para visitar',
          icon: Icons.import_contacts,
        ),
        PedidoMenuItem(
          title: 'Mis Repartos',
          subtitle: 'Repartos habilitados',
          icon: Icons.local_shipping,
          isSelected: true,
        ),
        PedidoMenuItem(
          title: 'Faltantes',
          subtitle: 'Productos en falta o incluir en los pedidos',
          icon: Icons.remove_shopping_cart,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _buildMenuItemCard(context, item);
        },
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, PedidoMenuItem item) {
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
          onTap: item.onTap,
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
                        color: AppColors.textDark,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
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
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 10),
                Text(
                  item.subtitle,
                  style: AppStyles.subtitleStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
