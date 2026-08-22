import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';

/// Modelo de datos para un Producto en el Catálogo
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

/// Pantalla de Catálogo de Productos para un Cliente (`Catálogo`)
class CatalogoScreen extends StatefulWidget {
  final String? clienteNombre;

  const CatalogoScreen({
    super.key,
    this.clienteNombre,
  });

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedCategorias = {};
  bool _mostrarTodo = false;

  final List<ProductoCatalogoModel> _productosOriginales = [];

  final Map<String, int> _categoriaCounts = const {
    'PASTAS': 147,
    'PANIFICACION': 113,
    'FECOVITA': 85,
    'DOMITEC': 69,
    'VANOLI': 45,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductoCatalogoModel> get _productosFiltrados {
    return _productosOriginales.where((p) {
      final query = _searchController.text.toLowerCase().trim();
      final matchSearch = query.isEmpty ||
          p.descripcion.toLowerCase().contains(query) ||
          p.codigo.toLowerCase().contains(query);

      final matchCategory = _selectedCategorias.isEmpty ||
          _selectedCategorias.contains(p.categoria);

      return matchSearch && matchCategory;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategorias.clear();
      _searchController.clear();
      _mostrarTodo = false;
    });
  }

  void _toggleCategoria(String cat, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedCategorias.add(cat);
      } else {
        _selectedCategorias.remove(cat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productosList = _productosFiltrados;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buscador de Productos con botón "Ir"
              SearchFilterBar(
                controller: _searchController,
                hintText: 'Buscar producto por nombre o código...',
                onSearch: () => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Sección Filtros: Categoría
              Container(
                decoration: AppStyles.cardDecoration(
                  backgroundColor: Colors.white,
                  borderColor: AppColors.cardBorder,
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  shape: const Border(),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  title: Row(
                    children: const [
                      Icon(Icons.check_box_outlined, size: 18, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text(
                        'Categoría',
                        style: AppStyles.sectionTitleStyle,
                      ),
                    ],
                  ),
                  children: [
                    ..._categoriaCounts.entries
                        .take(_mostrarTodo ? _categoriaCounts.length : 5)
                        .map((entry) {
                      return CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          '${entry.key} (${entry.value})',
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                        ),
                        value: _selectedCategorias.contains(entry.key),
                        onChanged: (val) => _toggleCategoria(entry.key, val),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _mostrarTodo = !_mostrarTodo;
                          });
                        },
                        child: Text(
                          _mostrarTodo ? 'Mostrar menos' : 'Mostrar todo',
                          style: const TextStyle(
                            color: Color(0xFF1976D2),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recuento total y botón restablecer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListHeaderSummary(
                    count: productosList.length,
                    label: '   Lista de Productos',
                  ),
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
                    label: const Text(
                      'Restablecer',
                      style: TextStyle(color: AppColors.textDark, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tabla de Productos del Catálogo
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 44,
                  dataRowMinHeight: 70,
                  dataRowMaxHeight: 90,
                  border: TableBorder.all(color: AppColors.cardBorder, width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Codigo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Producto Descripcion',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text(
                        'Precio\nUnitario',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text(
                            'Imagen View ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                          ),
                          Icon(Icons.swap_vert, size: 16, color: Color(0xFF1976D2)),
                        ],
                      ),
                    ),
                  ],
                  rows: productosList.map((p) {
                    final formattedPrecio = p.precioUnitario > 0
                        ? '\$ ${p.precioUnitario.toStringAsFixed(2)}'
                        : '\$ .00';

                    return DataRow(cells: [
                      DataCell(
                        Text(
                          p.codigo,
                          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            p.descripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          formattedPrecio,
                          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 64,
                          height: 64,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: AppStyles.cardDecoration(
                            backgroundColor: Colors.white,
                            borderColor: AppColors.cardBorder,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cloud_queue, size: 24, color: AppColors.primaryRed),
                                SizedBox(height: 2),
                                Text(
                                  'Don Emilio',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
