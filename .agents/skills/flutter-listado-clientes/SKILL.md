---
name: "flutter-listado-clientes"
description: "Construye la pantalla de Clientes ('Mis Clientes') en Flutter con buscador con botón 'Ir', menú desplegable de Acciones, botón primario rojo 'Crear' y tabla interactiva de clientes (Editar, Código, Pedido, Cliente, Documento y Tipo IVA)."
---

# Skill: Pantalla de Listado de Clientes en Flutter (`Mis Clientes`)

Esta habilidad define la especificación visual, estructura de datos, buscador con botón, menú de acciones y código Flutter para construir la pantalla de **Mis Clientes** basada en la interfaz del sistema de preventas.

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Botón Primario 'Crear'**: Rojo sólido `#D32F2F` con texto blanco centrado en negrita.
- **Iconos de Acción (Editar y Pedido)**: Azul interactivo `#1976D2`.
- **Títulos de Columna**: Azul interactivo `#1976D2` para `Codigo`, `Pedido`, `Cliente`, `Documento`, `Tipo Iva`.
- **Buscador y Desplegable 'Acciones'**: Fondo blanco con borde gris `#E0E0E0` y botón 'Ir' alineado a la derecha.

---

## 📋 Estructura de Componentes de la Pantalla

### 1. Cabecera (AppBar)
- Título: `PEDIDOS`
- Iconos derecha: Mensajes (`Icons.chat_bubble_outline`), Ayuda (`Icons.help_outline`), Perfil (`Icons.person_outline`).

### 2. Buscador y Filtro con Botón 'Ir'
- Fila con dropdown de filtro de búsqueda `[Q v]`, campo de texto `[ Input... ]` y botón `[ Ir ]`.

### 3. Menú Desplegable 'Acciones' y Botón 'Crear'
- Desplegable de ancho completo: `[ Acciones  v ]`
- Botón Rojo Primario: `[ Crear ]` (Abrir formulario de alta de cliente).

### 4. Tabla de Clientes (Campos)

| Columna | Alineación | Formato / Color | Ejemplo |
| :--- | :--- | :--- | :--- |
| **Acción Editar** | Centro | Icono lápiz azul (`#1976D2`) | `Icons.edit_note` / `Icons.edit_outlined` |
| **Codigo** | Centro / Izq | Texto azul (`#1976D2`, Negrita) | `1051`, `0193`, `0016`, `1480` |
| **Acción Pedido** | Centro | Icono carrito azul (`#1976D2`) | `Icons.add_shopping_cart` |
| **Cliente** | Izquierda | Texto negro (`#212121`, Negrita) | `CALDERON ELIANA (CF)`, `DOMINGUEZ CARLOS MATIAS (FA)` |
| **Documento** | Izquierda | Texto prefijo CUIT/CUIL | `CUIL : 1051`, `CUIT : 23334283119` |
| **Tipo Iva** | Izquierda | Texto condición fiscal | `CONSUMIDOR FINAL`, `RESP. INSCRIPTO`, `MONOTRIBUTO` |

---

## 🧩 Patrón de Código en Flutter (`MisClientesScreen`)

```dart
import 'package:flutter/material.dart';

class ClienteModel {
  final String codigo;
  final String nombre;
  final String documento;
  final String tipoIva;

  const ClienteModel({
    required this.codigo,
    required this.nombre,
    required this.documento,
    required this.tipoIva,
  });
}

class MisClientesScreen extends StatefulWidget {
  const MisClientesScreen({super.key});

  @override
  State<MisClientesScreen> createState() => _MisClientesScreenState();
}

class _MisClientesScreenState extends State<MisClientesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<ClienteModel> _clientes = const [
    ClienteModel(
      codigo: '1051',
      nombre: 'CALDERON ELIANA (CF)',
      documento: 'CUIL : 1051',
      tipoIva: 'CONSUMIDOR FINAL',
    ),
    ClienteModel(
      codigo: '0193',
      nombre: 'DOMINGUEZ CARLOS MATIAS (FA)',
      documento: 'CUIT : 23334283119',
      tipoIva: 'RESP. INSCRIPTO',
    ),
    ClienteModel(
      codigo: '0016',
      nombre: 'PIÑEYRO IRMA BRANKA (FA)',
      documento: 'CUIT : 27059203792',
      tipoIva: 'RESP. INSCRIPTO',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buscador con botón Ir
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    child: const Icon(Icons.search, color: Colors.grey),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: ''),
                    ),
                  ),
                  OutlinedButton(onPressed: () {}, child: const Text('Ir')),
                ],
              ),
              const SizedBox(height: 12),
              // Dropdown Acciones
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Acciones'), Icon(Icons.keyboard_arrow_down)],
                ),
              ),
              const SizedBox(height: 12),
              // Botón Crear Rojo
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
                onPressed: () {},
                child: const Text('Crear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              // Tabla de Datos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: SizedBox.shrink()),
                    DataColumn(label: Text('Codigo', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Pedido', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Cliente', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Documento', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Tipo Iva', style: TextStyle(color: Color(0xFF1976D2)))),
                  ],
                  rows: _clientes.map((c) {
                    return DataRow(cells: [
                      DataCell(IconButton(icon: const Icon(Icons.edit_outlined, color: Color(0xFF1976D2)), onPressed: () {})),
                      DataCell(Text(c.codigo)),
                      DataCell(IconButton(icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF1976D2)), onPressed: () {})),
                      DataCell(Text(c.nombre)),
                      DataCell(Text(c.documento)),
                      DataCell(Text(c.tipoIva)),
                    ]);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
```
