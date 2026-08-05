---
name: "flutter-listado-repartos"
description: "Construye la pantalla de Repartos del preventista ('Mis Repartos') en Flutter con filtros por estado, etiquetas de filtro activo (Pills/Tags), buscador, recuento de filas y tabla estructurada de repartos (Fecha, Código, Nombre, Descripción y Zona)."
---

# Skill: Pantalla de Listado de Repartos en Flutter (`Mis Repartos`)

Esta habilidad define la especificación visual, estructura de datos, chips de filtros activos y código Flutter para construir la pantalla de **Mis Repartos** basada en la interfaz del sistema de preventas.

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Navegación / Breadcrumb**: `< Inicio \ Mis Repartos` con texto gris (`#757575`).
- **Campo de Búsqueda**: Borde gris claro (`#E0E0E0`) con icono `Icons.search`.
- **Filtro Estado**: Casillas de verificación `Checkbox` con botón azul `Borrar` (`#1976D2`).
- **Etiqueta de Filtro Activo (Pill/Tag)**: Chip rectangular gris claro (`#F0F0F0`) con texto `Estado ABIERTO` e icono de cerrar `[X]`.
- **Títulos de Columna**: Azul interactivo `#1976D2` para `Fecha ↓≡`, `Codigo`, `Nombre`, `Descripcion`, `Zona`.

---

## 📋 Estructura de Componentes de la Pantalla

### 1. Cabecera (AppBar)
- Título: `PEDIDOS`
- Iconos derecha: Mensajes (`Icons.chat_bubble_outline`), Ayuda (`Icons.help_outline`), Perfil (`Icons.person_outline`).

### 2. Breadcrumb y Búsqueda
- Ruta: `< Inicio \ Mis Repartos`
- Caja de entrada de texto: Placeholder `Buscar...` e icono `Icons.search`.

### 3. Sección Filtros: Estado
- Acordeón / Desplegable: `[v] Estado` con opción a la derecha `Borrar` (Azul `#1976D2`)
- Casillas de Estado:
  - `FINALIZADO (29)`
  - `[x] ABIERTO (7)`  *(Seleccionado)*
  - `EN CARGA (1)`

### 4. Recuento, Filtros Activos y Restablecer
- Texto: **`Recuento Total de Filas 7`**
- Etiqueta de filtro: `Estado  ABIERTO  (x)`
- Botón de refresco: `[C] Restablecer`

### 5. Tabla de Repartos (Campos)

| Columna | Alineación | Formato / Color | Ejemplo |
| :--- | :--- | :--- | :--- |
| **Fecha ↓≡** | Izquierda | `dd/MM/yyyy HH:mm:ss` (Texto azul `#1976D2`) | `30/07/2026 00:00:00` |
| **Codigo** | Centro / Izq | Texto negro (`#424242`) | `95521`, `95522`, `95523`, `95501` |
| **Nombre** | Izquierda | Texto negro (`#212121`, Negrita) | `FER II 31-07-26`, `SAMUEL 31-07-26` |
| **Descripcion** | Izquierda | Texto secundario (`#424242`) | `FER II 31-07-26`, `ALEXIS 31-07-26` |
| **Zona** | Izquierda | Texto completo de zona | `FER (LUNES - JUEVES) B° PUERTAS DEL SOL Y EVA PERON` |

---

## 🧩 Patrón de Código en Flutter (`MisRepartosScreen`)

```dart
import 'package:flutter/material.dart';

class RepartoModel {
  final String fecha;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String zona;
  final String estado;

  const RepartoModel({
    required this.fecha,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.zona,
    required this.estado,
  });
}

class MisRepartosScreen extends StatefulWidget {
  const MisRepartosScreen({super.key});

  @override
  State<MisRepartosScreen> createState() => _MisRepartosScreenState();
}

class _MisRepartosScreenState extends State<MisRepartosScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _filterAbierto = true;
  bool _filterFinalizado = false;
  bool _filterEnCarga = false;

  final List<RepartoModel> _repartos = const [
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95521',
      nombre: 'FER II 31-07-26',
      descripcion: 'FER II 31-07-26',
      zona: 'FER (LUNES - JUEVES) B° PUERTAS DEL SOL Y EVA PERON',
      estado: 'ABIERTO',
    ),
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95522',
      nombre: 'SAMUEL 31-07-26',
      descripcion: 'SAMUEL 31-07-26',
      zona: 'SAMUEL (LUNES - JUEVES) NORTE SL',
      estado: 'ABIERTO',
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
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(hintText: 'Buscar...', prefixIcon: Icon(Icons.search)),
              ),
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text('Estado', style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  CheckboxListTile(
                    title: const Text('ABIERTO (7)'),
                    value: _filterAbierto,
                    onChanged: (val) => setState(() => _filterAbierto = val ?? false),
                  ),
                ],
              ),
              if (_filterAbierto) ...[
                Chip(
                  label: const Text('Estado ABIERTO'),
                  onDeleted: () => setState(() => _filterAbierto = false),
                ),
              ],
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Fecha ↓≡', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Codigo', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Nombre', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Descripcion', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Zona', style: TextStyle(color: Color(0xFF1976D2)))),
                  ],
                  rows: _repartos.map((r) {
                    return DataRow(cells: [
                      DataCell(Text(r.fecha)),
                      DataCell(Text(r.codigo)),
                      DataCell(Text(r.nombre)),
                      DataCell(Text(r.descripcion)),
                      DataCell(Text(r.zona)),
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
