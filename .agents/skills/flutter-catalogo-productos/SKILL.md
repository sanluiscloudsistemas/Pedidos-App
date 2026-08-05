---
name: "flutter-catalogo-productos"
description: "Construye la pantalla de Catálogo de Productos en Flutter con filtros por categoría (Pastas, Panificación, etc.), contador de filas, buscador, miniaturas de imagen y tabla/lista estructurada (Código, Producto Descripción, Precio Unitario e Imagen View)."
---

# Skill: Pantalla de Catálogo de Productos en Flutter (`Catálogo`)

Esta habilidad define la especificación visual, estructura de datos, filtros por categoría, renderizado de miniaturas y código Flutter para construir la pantalla del **Catálogo de Productos** basada en la interfaz del sistema de preventas.

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Campo de Búsqueda**: Borde gris claro (`#E0E0E0`) con icono `Icons.search`.
- **Filtro Categoría**: Casillas de verificación `Checkbox` con contadores en gris `(147)`.
- **Enlace "Mostrar todo"**: Texto azul interactivo `#1976D2`.
- **Títulos de Columna**: Azul interactivo `#1976D2` para `Codigo`, `Producto Descripcion`, `Precio Unitario`, e `Imagen View ↑≡`.
- **Marco de Miniatura de Imagen**: Recuadro contenedor cuadrado blanco con borde gris `#E0E0E0` (ej. logo del producto o placeholder).

---

## 📋 Estructura de Componentes de la Pantalla

### 1. Cabecera (AppBar)
- Título: `PEDIDOS`
- Iconos derecha: Mensajes (`Icons.chat_bubble_outline`), Ayuda (`Icons.help_outline`), Perfil (`Icons.person_outline`).

### 2. Buscador y Filtro por Categorías
- Caja de entrada de texto: Placeholder `Buscar...` e icono `Icons.search`.
- Desplegable / Acordeón con icono desplegable: `[v] Categoria`
- Categorías con contadores:
  - `PASTAS (147)`
  - `PANIFICACION (113)`
  - `FECOVITA (85)`
  - `DOMITEC (69)`
  - `VANOLI (45)`
- Botón de texto: `Mostrar todo` (Azul `#1976D2`)

### 3. Barra de Acciones y Recuento
- Texto total: **`Recuento Total de Filas 791`**
- Derecha: Botón de refresco `[C] Restablecer` (Limpiar filtros)

### 4. Tabla / Lista de Productos (Campos)

| Columna | Alineación | Formato / Color | Ejemplo |
| :--- | :--- | :--- | :--- |
| **Codigo** | Centro / Izq | Texto azul (`#1976D2`, 12pt) | `651`, `.679`, `.654` |
| **Producto Descripcion** | Izquierda | Texto negro (`#212121`, 12pt) | `FIDEOS SECOS - DON EMILIO - TALLARIN MEDIANO SEM. DON EMILIO X 500 GR. - ,5 Kilos` |
| **Precio Unitario** | Derecha | Moneda en ARS (`$ 2100.00`) | `$ 2100.00`, `$ .00` |
| **Imagen View ↑≡** | Centro | Marco cuadrado con miniatura (`64x64px`) | Miniatura de la marca (ej. `Don Emilio`) |

---

## 🧩 Patrón de Código en Flutter (`CatalogoScreen`)

```dart
import 'package:flutter/material.dart';

class ProductoCatalogoModel {
  final String codigo;
  final String descripcion;
  final double precioUnitario;
  final String categoria;
  final String? imageUrl;

  const ProductoCatalogoModel({
    required this.codigo,
    required this.descripcion,
    required this.precioUnitario,
    required this.categoria,
    this.imageUrl,
  });
}

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedCategorias = {};

  final List<ProductoCatalogoModel> _productos = const [
    ProductoCatalogoModel(
      codigo: '651',
      descripcion: 'FIDEOS SECOS - DON EMILIO - TALLARIN MEDIANO SEM. DON EMILIO X 500 GR. - ,5 Kilos',
      precioUnitario: 2100.00,
      categoria: 'PASTAS',
    ),
    ProductoCatalogoModel(
      codigo: '.679',
      descripcion: 'FIDEOS SECOS - DON EMILIO - BONIF. FIDEOS ENTREFINO X 500 GR. - ,5 Kilos',
      precioUnitario: 0.00,
      categoria: 'PASTAS',
    ),
    ProductoCatalogoModel(
      codigo: '.654',
      descripcion: 'FIDEOS SECOS - DON EMILIO - BONIF. FIDEOS MOÑITO DON EMILIO X 500 GR. - ,5 Kilos',
      precioUnitario: 0.00,
      categoria: 'PASTAS',
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
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  CheckboxListTile(
                    title: const Text('PASTAS (147)'),
                    value: _selectedCategorias.contains('PASTAS'),
                    onChanged: (val) {},
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Mostrar todo', style: TextStyle(color: Color(0xFF1976D2))),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recuento Total de Filas 791', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restablecer'),
                  )
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Codigo', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Producto Descripcion', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Precio Unitario', style: TextStyle(color: Color(0xFF1976D2)))),
                    DataColumn(label: Text('Imagen View ↑≡', style: TextStyle(color: Color(0xFF1976D2)))),
                  ],
                  rows: _productos.map((p) {
                    return DataRow(cells: [
                      DataCell(Text(p.codigo)),
                      DataCell(Text(p.descripcion)),
                      DataCell(Text('\$ ${p.precioUnitario.toStringAsFixed(2)}')),
                      DataCell(
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
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
