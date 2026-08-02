import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFFAF9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 1,
        titleSpacing: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFB71C1C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 20),
            onPressed: () {},
          ),
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, color: Colors.white, size: 20),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              const SizedBox(width: 10),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, color: Colors.white, size: 20),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
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
