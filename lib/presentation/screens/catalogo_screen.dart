import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../data/datasources/remote/api_service.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';

/// Modelo de datos para un Producto en el Catálogo
class ProductoCatalogoModel {
  final int? id;
  final String codigo;
  final String descripcion;
  final String? productoDescripcion;
  final double precioUnitario;
  final String categoria;
  final String? subcategoria;
  final String? marca;
  final int? stockAct;
  final String? imagenBase64;
  final String? imageUrl;

  const ProductoCatalogoModel({
    this.id,
    required this.codigo,
    required this.descripcion,
    this.productoDescripcion,
    required this.precioUnitario,
    required this.categoria,
    this.subcategoria,
    this.marca,
    this.stockAct,
    this.imagenBase64,
    this.imageUrl,
  });

  factory ProductoCatalogoModel.fromJson(Map<String, dynamic> json) {
    double parsePrecio(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) {
        final clean = val.replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '.').trim();
        return double.tryParse(clean) ?? 0.0;
      }
      return 0.0;
    }

    return ProductoCatalogoModel(
      id: (json['id'] as num?)?.toInt(),
      codigo: json['codigo']?.toString() ?? '',
      descripcion: json['producto_descripcion']?.toString() ?? json['descripcion']?.toString() ?? '',
      productoDescripcion: json['producto']?.toString(),
      precioUnitario: parsePrecio(json['precio_unitario']),
      categoria: (json['categoria']?.toString() ?? 'SIN CATEGORIA').trim(),
      subcategoria: json['subcategoria']?.toString(),
      marca: json['marca']?.toString(),
      stockAct: (json['stock_act'] as num?)?.toInt(),
      imagenBase64: json['imagen_base64']?.toString(),
    );
  }
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

  List<ProductoCatalogoModel> _productosOriginales = [];
  Map<String, int> _categoriaCounts = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarCatalogo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.getCatalogo();

      final data = response.data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        final List itemsJson = data['items'];
        final productos = itemsJson
            .map((item) => ProductoCatalogoModel.fromJson(item as Map<String, dynamic>))
            .toList();

        final Map<String, int> counts = {};
        for (final p in productos) {
          if (p.categoria.isNotEmpty) {
            counts[p.categoria] = (counts[p.categoria] ?? 0) + 1;
          }
        }

        setState(() {
          _productosOriginales = productos;
          _categoriaCounts = counts;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Formato de respuesta no válido.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar catálogo: $e';
        _isLoading = false;
      });
    }
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

  Widget _buildProductImage(ProductoCatalogoModel p) {
    if (p.imagenBase64 != null && p.imagenBase64!.isNotEmpty) {
      try {
        final cleanBase64 = p.imagenBase64!.replaceAll('\r', '').replaceAll('\n', '').trim();
        final bytes = base64Decode(cleanBase64);
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.memory(
            bytes,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackImage(p.marca),
          ),
        );
      } catch (_) {
        return _buildFallbackImage(p.marca);
      }
    }
    return _buildFallbackImage(p.marca);
  }

  Widget _buildFallbackImage(String? marca) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_queue, size: 24, color: AppColors.primaryRed),
        const SizedBox(height: 2),
        Text(
          marca ?? 'San Luis Cloud',
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBody(List<ProductoCatalogoModel> productosList) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64.0),
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    if (_errorMessage != null && _productosOriginales.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textDark),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _cargarCatalogo,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
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
              if (_categoriaCounts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No hay categorías disponibles',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                )
              else ...[
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
                if (_categoriaCounts.length > 5)
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
                      child: _buildProductImage(p),
                    ),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
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
          child: _buildBody(productosList),
        ),
      ),
    );
  }
}
