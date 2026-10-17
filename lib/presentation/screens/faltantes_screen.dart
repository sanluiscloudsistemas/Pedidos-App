import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/remote/api_service.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';

/// Modelo de datos para un Producto Faltante
class FaltanteItemModel {
  final int? id;
  final String codigo;
  final String productoDescripcion;
  final String observacion;
  final String fecha;
  final DateTime? rawFecha;
  final bool isOffline;

  const FaltanteItemModel({
    this.id,
    required this.codigo,
    required this.productoDescripcion,
    this.observacion = '',
    required this.fecha,
    this.rawFecha,
    this.isOffline = false,
  });

  factory FaltanteItemModel.fromJson(Map<String, dynamic> json) {
    final rawDateStr = (json['fecha'] ?? json['FECHA'] ?? '').toString();
    final parsedDate = DateFormatter.parseFlexible(rawDateStr);
    final relativeOrFormatted = parsedDate != null
        ? DateFormatter.formatRelativeTime(parsedDate)
        : (rawDateStr.isNotEmpty ? rawDateStr : '-');

    final cod = (json['codigo'] ?? json['CODIGO'] ?? json['producto_id'] ?? json['id'] ?? '').toString();
    final desc = (json['producto_descripcion'] ??
            json['PRODUCTO_DESCRIPCION'] ??
            json['producto'] ??
            json['PRODUCTO'] ??
            json['nombre'] ??
            json['NOMBRE'] ??
            'Producto #$cod')
        .toString();
    final obs = (json['observacion'] ?? json['OBSERVACION'] ?? '').toString();

    return FaltanteItemModel(
      id: (json['id'] ?? json['ID'] as num?)?.toInt(),
      codigo: cod,
      productoDescripcion: desc,
      observacion: obs,
      fecha: relativeOrFormatted,
      rawFecha: parsedDate,
      isOffline: json['isOffline'] == true,
    );
  }
}

/// Pantalla de Productos Faltantes (`Faltantes`)
class FaltantesScreen extends StatefulWidget {
  const FaltantesScreen({super.key});

  @override
  State<FaltantesScreen> createState() => _FaltantesScreenState();
}

class _FaltantesScreenState extends State<FaltantesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<FaltanteItemModel> _faltantesOriginales = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 25;
  String? _errorMessage;

  int? _sortColumnIndex = 1;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarFaltantes(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore &&
        _searchController.text.trim().isEmpty) {
      _cargarMasFaltantes();
    }
  }

  Future<void> _cargarFaltantes({bool isRefresh = false}) async {
    if (!mounted) return;
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _offset = 0;
        _hasMore = true;
      });
    }

    try {
      final apiService = context.read<ApiService>();
      HiveService? hiveService;
      try {
        hiveService = context.read<HiveService>();
      } catch (_) {}

      final response = await apiService.getFaltantes(
        offset: _offset,
        limit: _limit,
      );

      final data = response.data;
      final List<FaltanteItemModel> nuevosRemotos = [];
      bool hasMoreServer = false;

      if (data is Map<String, dynamic> && data['items'] is List) {
        final List itemsJson = data['items'];
        for (final it in itemsJson) {
          if (it is Map<String, dynamic>) {
            nuevosRemotos.add(FaltanteItemModel.fromJson(it));
          }
        }
        hasMoreServer = data['hasMore'] == true || nuevosRemotos.length >= _limit;
      }

      // Incorporar faltantes locales pendientes (solo en primer refresh)
      final List<FaltanteItemModel> locales = [];
      if (isRefresh && hiveService != null) {
        final pending = hiveService.getPendingFaltantes();
        for (final p in pending) {
          final parsedDate = DateFormatter.parseFlexible(p['fecha']);
          locales.add(FaltanteItemModel(
            codigo: (p['productoCodigo'] ?? p['productoId'] ?? '').toString(),
            productoDescripcion: (p['productoDescripcion'] ?? 'Producto #${p['productoId']}').toString(),
            observacion: (p['observacion'] ?? '').toString(),
            fecha: parsedDate != null
                ? DateFormatter.formatRelativeTime(parsedDate)
                : (p['fecha'] ?? '').toString(),
            rawFecha: parsedDate,
            isOffline: true,
          ));
        }
      }

      if (!mounted) return;
      setState(() {
        if (isRefresh) {
          _faltantesOriginales = [...locales, ...nuevosRemotos];
        } else {
          _faltantesOriginales.addAll(nuevosRemotos);
        }
        _offset = _faltantesOriginales.length;
        _hasMore = hasMoreServer && nuevosRemotos.isNotEmpty;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      if (isRefresh) {
        try {
          final hiveService = context.read<HiveService>();
          final pending = hiveService.getPendingFaltantes();
          if (pending.isNotEmpty) {
            final locales = pending.map((p) {
              final parsedDate = DateFormatter.parseFlexible(p['fecha']);
              return FaltanteItemModel(
                codigo: (p['productoCodigo'] ?? p['productoId'] ?? '').toString(),
                productoDescripcion: (p['productoDescripcion'] ?? 'Producto #${p['productoId']}').toString(),
                observacion: (p['observacion'] ?? '').toString(),
                fecha: parsedDate != null
                    ? DateFormatter.formatRelativeTime(parsedDate)
                    : (p['fecha'] ?? '').toString(),
                rawFecha: parsedDate,
                isOffline: true,
              );
            }).toList();
            setState(() {
              _faltantesOriginales = locales;
              _isLoading = false;
              _isLoadingMore = false;
              _errorMessage = null;
            });
            return;
          }
        } catch (_) {}

        setState(() {
          _errorMessage = 'Error al cargar productos faltantes: $e';
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _cargarMasFaltantes() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    setState(() => _isLoadingMore = true);
    await _cargarFaltantes(isRefresh: false);
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<FaltanteItemModel> get _faltantesFiltrados {
    final query = _searchController.text.toLowerCase().trim();
    final list = _faltantesOriginales.where((f) {
      if (query.isEmpty) return true;
      return f.productoDescripcion.toLowerCase().contains(query) ||
          f.codigo.toLowerCase().contains(query) ||
          f.observacion.toLowerCase().contains(query) ||
          f.fecha.toLowerCase().contains(query);
    }).toList();

    if (_sortColumnIndex != null) {
      list.sort((a, b) {
        int cmp = 0;
        switch (_sortColumnIndex) {
          case 0:
            final aNum = int.tryParse(a.codigo);
            final bNum = int.tryParse(b.codigo);
            if (aNum != null && bNum != null) {
              cmp = aNum.compareTo(bNum);
            } else {
              cmp = a.codigo.compareTo(b.codigo);
            }
            break;
          case 1:
            cmp = a.productoDescripcion.compareTo(b.productoDescripcion);
            break;
          case 2:
            cmp = a.observacion.compareTo(b.observacion);
            break;
          case 3:
            final aDate = a.rawFecha ?? DateTime(1970);
            final bDate = b.rawFecha ?? DateTime(1970);
            cmp = aDate.compareTo(bDate);
            break;
        }
        return _sortAscending ? cmp : -cmp;
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final faltantesList = _faltantesFiltrados;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _cargarFaltantes(isRefresh: true),
        color: AppColors.primaryRed,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buscador superior con botón "Ir"
                SearchFilterBar(
                  controller: _searchController,
                  hintText: 'Buscar producto faltante por descripción o código...',
                  onSearch: () => setState(() {}),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Summary Header con recuento de faltantes
                ListHeaderSummary(
                  count: faltantesList.length,
                  label: 'faltantes',
                ),
                const SizedBox(height: 12),

                // Contenido principal: Loading / Error / Empty / Grilla
                if (_isLoading && _faltantesOriginales.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.0),
                      child: CircularProgressIndicator(color: AppColors.primaryRed),
                    ),
                  )
                else if (_errorMessage != null && _faltantesOriginales.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
                            onPressed: () => _cargarFaltantes(isRefresh: true),
                            icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                            label: const Text('Reintentar', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (faltantesList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cardBorder),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'No se encontraron productos faltantes.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columnSpacing: 16,
                      headingRowHeight: 40,
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 80,
                      border: TableBorder.all(color: AppColors.cardBorder, width: 1),
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                      columns: [
                        DataColumn(
                          label: const Text(
                            'Codigo',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                          ),
                          onSort: _onSort,
                        ),
                        DataColumn(
                          label: const Row(
                            children: [
                              Text(
                                'Producto Descripcion ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                              ),
                              Icon(Icons.swap_vert, size: 16, color: Color(0xFF1976D2)),
                            ],
                          ),
                          onSort: _onSort,
                        ),
                        DataColumn(
                          label: const Text(
                            'Observacion',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                          ),
                          onSort: _onSort,
                        ),
                        DataColumn(
                          label: const Text(
                            'Fecha',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                          ),
                          onSort: _onSort,
                        ),
                      ],
                      rows: faltantesList.map((f) {
                        return DataRow(cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  f.codigo,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (f.isOffline) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.cloud_off, size: 14, color: Colors.orange),
                                ],
                              ],
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 240,
                              child: Text(
                                f.productoDescripcion,
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
                            SizedBox(
                              width: 100,
                              child: Text(
                                f.observacion.isNotEmpty ? f.observacion : '-',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 110,
                              child: Text(
                                f.fecha,
                                style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),

                if (_isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primaryRed),
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
