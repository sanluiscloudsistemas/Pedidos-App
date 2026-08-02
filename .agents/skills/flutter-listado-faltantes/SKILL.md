---
name: "flutter-listado-faltantes"
description: "Construye la pantalla de Productos Faltantes ('Faltantes') en Flutter con buscador con botón 'Ir' y tabla interactiva de productos no entregados (Código, Descripción del Producto, Observación y Tiempo/Fecha de reporte)."
---

# Skill: Pantalla de Productos Faltantes en Flutter (`Faltantes`)

Esta habilidad define la especificación visual, estructura de datos, buscador con botón y código Flutter para construir la pantalla de **Faltantes** (productos incluidos en el pedido del cliente pero ausentes al momento de la entrega).

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Navegación / Breadcrumb**: `< Inicio \ Faltantes` con texto gris (`#757575`).
- **Títulos de Columna**: Azul interactivo `#1976D2` para `Codigo`, `Producto Descripcion ↑≡`, `Observacion`, `Fecha`.
- **Buscador con Botón 'Ir'**: Caja de entrada con selector desplegable a la izquierda `[Q v]` y botón `[ Ir ]` a la derecha.

---

## 📋 Estructura de Componentes de la Pantalla

### 1. Cabecera (AppBar)
- Título: `PEDIDOS`
- Iconos derecha: Mensajes (`Icons.chat_bubble_outline`), Ayuda (`Icons.help_outline`), Perfil (`Icons.person_outline`).

### 2. Breadcrumb y Buscador
- Ruta: `< Inicio \ Faltantes`
- Fila con selector desplegable `[Q v]`, campo de texto `[ Buscar... ]` y botón `[ Ir ]`.

### 3. Tabla de Faltantes (Campos)

| Columna | Alineación | Formato / Color | Ejemplo |
| :--- | :--- | :--- | :--- |
| **Codigo** | Centro / Izq | Texto azul (`#1976D2`, 12pt) | `294`, `297`, `296`, `295`, `190` |
| **Producto Descripcion ↑≡** | Izquierda | Texto negro (`#212121`, 12pt) con ordenación | `ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ CLASICO X 500 GR.` |
| **Observacion** | Izquierda | Texto secundario opcional (`#616161`) | *(vacío o notas de entrega)* |
| **Fecha** | Izquierda | Texto relativo de tiempo transcurrido | `Hace 3 meses`, `Hace 5 semanas`, `Hace 4 semanas` |

---

## 🧩 Patrón de Código en Flutter (`FaltantesScreen`)

```dart
import 'package:flutter/material.dart';

class FaltanteItemModel {
  final String codigo;
  final String productoDescripcion;
  final String observacion;
  final String fecha;

  const FaltanteItemModel({
    required this.codigo,
    required this.productoDescripcion,
    this.observacion = '',
    required this.fecha,
  });
}

class FaltantesScreen extends StatefulWidget {
  const FaltantesScreen({super.key});

  @override
  State<FaltantesScreen> createState() => _FaltantesScreenState();
}

class _FaltantesScreenState extends State<FaltantesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<FaltanteItemModel> _faltantes = const [
    FaltanteItemModel(
      codigo: '294',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ CLASICO ARPAN X 500 GR. - ,5 Kilos',
      fecha: 'Hace 3 meses',
    ),
    FaltanteItemModel(
      codigo: '297',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ DORADO ARPAN X 500 GR. - 5 Kilos',
      fecha: 'Hace 5 semanas',
    ),
    FaltanteItemModel(
      codigo: '296',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ PROVENZAL ARPAN X 500 GR. - ,5 Kilos',
      fecha: 'Hace 5 semanas',
    ),
    FaltanteItemModel(
      codigo: '190',
      productoDescripcion: 'ARROZ - ARROZ TIO CARLOS - TIO CARLOS - ARROZ TIO CARLOS INTEGRAL X 1 KG. - 1 Kilos',
      fecha: 'Hace 4 semanas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        title: const Text('PEDIDOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    child: const Icon(Icons.search, color: Colors.grey),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: ''),
                      ),
                    ),
                  ),
                  OutlinedButton(onPressed: () {}, child: const Text('Ir')),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Codigo', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Producto Descripcion ↑≡', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Observacion', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Fecha', style: TextStyle(color: Color(0xFF1976D2)))),
                  ],
                  rows: _faltantes.map((f) {
                    return DataRow(cells: [
                      DataCell(Text(f.codigo)),
                      DataCell(Text(f.productoDescripcion)),
                      DataCell(Text(f.observacion)),
                      DataCell(Text(f.fecha)),
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
