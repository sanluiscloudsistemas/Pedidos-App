---
name: "flutter-listado-pedidos"
description: "Construye la pantalla de listado de pedidos ('Mis Pedidos') en Flutter con filtros por estado, búsqueda, recuento de filas, botones de acción y tabla/lista estructurada de pedidos (Fecha, Código, Cliente, Monto y Estado)."
---

# Skill: Pantalla de Listado de Pedidos en Flutter (`Mis Pedidos`)

Esta habilidad define la especificación visual, estructura de datos, filtros y código Flutter para construir la pantalla de **Mis Pedidos** basada en la interfaz del sistema de preventas.

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Navegación / Breadcrumb**: Texto gris (`#757575`) y título activo en gris oscuro (`#212121`).
- **Campo de Búsqueda**: Borde gris claro (`#E0E0E0`) con icono `Icons.search`.
- **Filtro Estado**: Casillas de verificación `Checkbox` con contadores en gris `(114)`.
- **Enlace de Cliente**: Texto en azul interactivo `#1976D2`.
- **Estado 'FINALIZADO'**: Texto en rojo corporativo `#D32F2F` en mayúsculas y negrita.
- **Estado 'NUEVO'**: Texto en azul `#1976D2` o verde `#388E3C`.
- **Estado 'PENDIENTE'**: Texto en naranja `#F57C00`.

---

## 📋 Estructura de Componentes de la Pantalla

### 1. Cabecera (AppBar)
- Título: `PEDIDOS`
- Iconos derecha: Mensajes (`Icons.chat_bubble_outline`), Ayuda (`Icons.help_outline`), Perfil (`Icons.person_outline`).

### 2. Breadcrumb y Búsqueda
- Ruta: `< Inicio \ Mis Pedidos`
- Caja de entrada de texto: Input con placeholder `Buscar...` e icono `Icons.search`.

### 3. Sección de Filtros (`Estado`)
- Desplegable / Acordeón con icono desplegable: `[v] Estado`
- Opciones con contador:
  - `FINALIZADO (114)`
  - `NUEVO (2)`
  - `PENDIENTE (1)`

### 4. Barra de Acciones y Recuento
- Texto total: **`Recuento Total de Filas 117`**
- Botones a la derecha:
  - Botón delineado `[Pedido  [+]]` (Agregar nuevo pedido)
  - Botón de refresco `[C] Restablecer` (Limpiar filtros)

### 5. Tabla / Lista de Pedidos (Campos)

| Columna | Alineación | Formato / Color | Ejemplo |
| :--- | :--- | :--- | :--- |
| **Fecha Generacion** | Izquierda | `dd/MM/yyyy` (Gris oscuro `#424242`) | `29/07/2026` |
| **Codigo** | Centro / Izq | Texto regular (`#424242`) | `513003` |
| **Cliente** | Izquierda | Texto Azul Enlace (`#1976D2`, Negrita) | `0720 BERARDI OLIVA CYNTHIA BELEN (FA)` |
| **Monto** | Derecha | Moneda en ARS (`$30.550,00`) | `$30.550,00` |
| **Estado Color** | Centro / Izq | Texto Rojo / Estado Mayúscula (`#D32F2F`) | `FINALIZADO` |

---

## 🧩 Patrón de Código en Flutter (`MisPedidosScreen`)

```dart
import 'package:flutter/material.dart';

class PedidoItemModel {
  final String fechaGeneracion;
  final String codigo;
  final String cliente;
  final double monto;
  final String estado;

  const PedidoItemModel({
    required this.fechaGeneracion,
    required this.codigo,
    required this.cliente,
    required this.monto,
    required this.estado,
  });
}

class MisPedidosScreen extends StatefulWidget {
  const MisPedidosScreen({super.key});

  @override
  State<MisPedidosScreen> createState() => _MisPedidosScreenState();
}

class _MisPedidosScreenState extends State<MisPedidosScreen> {
  bool _filterFinalizado = false;
  bool _filterNuevo = false;
  bool _filterPendiente = false;
  final TextEditingController _searchController = TextEditingController();

  final List<PedidoItemModel> _pedidos = const [
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513003',
      cliente: '0720 BERARDI OLIVA CYNTHIA BELEN (FA)',
      monto: 30550.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513004',
      cliente: '0306 AGUERO CECILIA (FA)',
      monto: 41000.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513005',
      cliente: '3699 MIRANDA ROMINA SOLEDAD (CF)',
      monto: 30640.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513007',
      cliente: '0400 DISTRIBUIDORA MAG SRL CAIDOS (FA)',
      monto: 220500.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513008',
      cliente: '1335 DISTRIBUIDORA MAG SRL SARMIENTO (FA)',
      monto: 393000.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513009',
      cliente: '1335 DISTRIBUIDORA MAG SRL (FA)',
      monto: 67200.00,
      estado: 'FINALIZADO',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        title: const Text(
          'PEDIDOS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.chat_bubble_outline, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.help_outline, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.person_outline, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Row(
                children: const [
                  Icon(Icons.chevron_left, size: 18, color: Colors.grey),
                  Text('Inicio', style: TextStyle(color: Colors.grey)),
                  Text('  \\  ', style: TextStyle(color: Colors.grey)),
                  Text('Mis Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),

              // Buscador
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sección de Filtros de Estado
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                children: [
                  CheckboxListTile(
                    title: const Text('FINALIZADO (114)'),
                    value: _filterFinalizado,
                    dense: true,
                    onChanged: (val) => setState(() => _filterFinalizado = val ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('NUEVO (2)'),
                    value: _filterNuevo,
                    dense: true,
                    onChanged: (val) => setState(() => _filterNuevo = val ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('PENDIENTE (1)'),
                    value: _filterPendiente,
                    dense: true,
                    onChanged: (val) => setState(() => _filterPendiente = val ?? false),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Barra de Total y Acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recuento Total de Filas 117',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.post_add, size: 16),
                        label: const Text('Pedido'),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Restablecer'),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),

              // Tabla / DataTable de Pedidos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(label: Text('Fecha Generacion', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                    DataColumn(label: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Estado Color', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: _pedidos.map((p) {
                    return DataRow(cells: [
                      DataCell(Text(p.fechaGeneracion)),
                      DataCell(Text(p.codigo)),
                      DataCell(Text(p.cliente, style: const TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold))),
                      DataCell(Text('\$${p.monto.toStringAsFixed(2).replaceAll('.', ',')}')),
                      DataCell(Text(p.estado, style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold))),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
