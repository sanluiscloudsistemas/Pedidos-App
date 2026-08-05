---
name: "flutter-menu-pedidos"
description: "Construye la pantalla de menú de gestión de pedidos en Flutter con diseño fiel a la interfaz de preventas (cabecera roja, tarjetas estructuradas, iconos circulares rojos e ítem destacado)."
---

# Skill: Pantalla de Menú de Gestión de Pedidos en Flutter

Esta habilidad define la especificación de diseño, colores, fuentes, iconos, estructura de datos e implementación en Flutter para reproducir fielmente la pantalla de menú principal de **Gestión de Pedidos** (`PEDIDOS`).

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#C62828` (o `Colors.red.shade800`).
- **Icono Menú Lateral (Drawer Toggle)**: Contenedor cuadrado rojo oscuro `#B71C1C` con icono blanco `Icons.menu`.
- **Fondo de Pantalla**: Gris claro `#F5F5F5` o Blanco `#FFFFFF`.
- **Fondo de Tarjeta Normal**: Blanco `#FFFFFF` con borde gris claro `#E0E0E0` (radio de 6px).
- **Fondo de Tarjeta Destacada/Seleccionada**: Rosa/Rojo suave `#FFEBEE` / `#FCE4EC` (usado en **Mis Repartos**).
- **Círculo de Iconos Acción**: Círculo rojo `#D32F2F` con icono blanco.
- **Texto Título**: Negro / Gris muy oscuro (`#212121`), fuente semibold (`FontWeight.w600`).
- **Texto Subtítulo**: Gris secundario (`#666666`), fuente normal (`FontWeight.normal`).

---

## 📋 Lista Exacta de Ítems del Menú

| Ítem | Título | Subtítulo | Icono de Acción (Circular) | Estado |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `Agregar Pedido` | `Pedido de un Cliente para un Reparto` | `Icons.post_add` (Clipboard con signo +) | Normal |
| **2** | `Mis Pedidos` | `Pedidos de mis clientes para Repartos` | `Icons.shopping_cart` (Carrito de compras) | Normal |
| **3** | `Catálogo` | `Catálogo de Productos` | `Icons.menu_book` (Libro / Catálogo) | Normal |
| **4** | `Mis Clientes` | `Clientes para visitar` | `Icons.import_contacts` / `Icons.contact_phone` (Contactos) | Normal |
| **5** | `Mis Repartos` | `Repartos habilitados` | `Icons.local_shipping` (Camión de reparto) | **Destacado (Fondo Rosa/Rojo suave `#FFEBEE`)** |
| **6** | `Faltantes` | `Productos en falta o incluir en los pedidos` | `Icons.remove_shopping_cart` (Carrito con X) | Normal |

---

## 🏛️ Estructura del AppBar (Cabecera Superior)

- **Izquierda**:
  - Botón de Menú hamburguesa dentro de un recuadro rojo oscuro.
  - Título en mayúsculas: `PEDIDOS` (Texto blanco, negrita, tamaño 20pt).
- **Derecha (Acciones)**:
  1. Icono de sincronización/nube: `Icons.cloud_download`
  2. Icono de mensajes/chat: `Icons.chat_bubble_outline`
  3. Icono de ayuda con flecha abajo: `Icons.help_outline` + `Icons.keyboard_arrow_down`
  4. Icono de perfil de usuario con flecha abajo: `Icons.person_outline` + `Icons.keyboard_arrow_down`

---

## 🧩 Patrón de Código en Flutter (`PedidosMenuScreen`)

```dart
import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const MenuItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });
}

class PedidosMenuScreen extends StatelessWidget {
  const PedidosMenuScreen({super.key});

  List<MenuItemModel> get _menuItems => const [
        MenuItemModel(
          title: 'Agregar Pedido',
          subtitle: 'Pedido de un Cliente para un Reparto',
          icon: Icons.post_add,
        ),
        MenuItemModel(
          title: 'Mis Pedidos',
          subtitle: 'Pedidos de mis clientes para Repartos',
          icon: Icons.shopping_cart,
        ),
        MenuItemModel(
          title: 'Catálogo',
          subtitle: 'Catálogo de Productos',
          icon: Icons.menu_book,
        ),
        MenuItemModel(
          title: 'Mis Clientes',
          subtitle: 'Clientes para visitar',
          icon: Icons.import_contacts,
        ),
        MenuItemModel(
          title: 'Mis Repartos',
          subtitle: 'Repartos habilitados',
          icon: Icons.local_shipping,
          isSelected: true,
        ),
        MenuItemModel(
          title: 'Faltantes',
          subtitle: 'Productos en falta o incluir en los pedidos',
          icon: Icons.remove_shopping_cart,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 2,
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
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {},
          ),
          Row(
            children: [
              const Icon(Icons.help_outline, color: Colors.white),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              const SizedBox(width: 8),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _menuItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildMenuItemCard(item);
        },
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItemModel item) {
    final cardBgColor = item.isSelected ? const Color(0xFFFFEBEE) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
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
                        color: Color(0xFF212121),
                      ),
                    ),
                    Container(
                      width: 38,
                      height: 38,
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
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 8),
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
```
