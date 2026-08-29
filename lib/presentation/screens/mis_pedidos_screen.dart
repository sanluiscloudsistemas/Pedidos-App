import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../data/datasources/remote/api_service.dart';
import '../../domain/repositories/sync_repository.dart';
import '../notifiers/sync_notifier.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';

/// Modelo de datos para un Pedido en la vista de lista
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

  factory PedidoItemModel.fromJson(Map<String, dynamic> json) {
    double parseMonto(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) {
        final clean = val.replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '.').trim();
        return double.tryParse(clean) ?? 0.0;
      }
      return 0.0;
    }

    return PedidoItemModel(
      fechaGeneracion: json['fecha_generacion']?.toString().trim() ??
          json['fecha']?.toString().trim() ??
          '',
      codigo: json['codigo']?.toString().trim() ??
          json['pedido_id']?.toString().trim() ??
          json['id']?.toString().trim() ??
          '',
      cliente: json['cliente_nombre']?.toString().trim() ??
          json['cliente']?.toString().trim() ??
          (json['cliente_id'] != null ? 'Cliente ID: ${json['cliente_id']}' : 'Sin cliente'),
      monto: parseMonto(json['monto'] ?? json['total']),
      estado: json['estado']?.toString().trim() ?? 'NUEVO',
    );
  }
}

/// Pantalla de Listado de Pedidos (`Mis Pedidos` / Pedidos Actuales del Cliente)
class MisPedidosScreen extends StatefulWidget {
  final String? clienteNombre;

  const MisPedidosScreen({
    super.key,
    this.clienteNombre,
  });

  @override
  State<MisPedidosScreen> createState() => _MisPedidosScreenState();
}

class _MisPedidosScreenState extends State<MisPedidosScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _filterFinalizado = false;
  bool _filterNuevo = false;
  bool _filterPendiente = false;

  List<PedidoItemModel> _pedidosRemotos = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 25;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.clienteNombre != null) {
      _searchController.text = widget.clienteNombre!;
    }
    _scrollController.addListener(_onScroll);
    _cargarPedidos(isRefresh: true);
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
      _cargarMasPedidos();
    }
  }

  Future<void> _cargarPedidos({bool isRefresh = false}) async {
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
      final response = await apiService.getPedidos(
        offset: _offset,
        limit: _limit,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        final List itemsJson = data['items'];
        final nuevosPedidos = itemsJson
            .map((item) => PedidoItemModel.fromJson(item as Map<String, dynamic>))
            .toList();

        final hasMoreServer = data['hasMore'] == true || nuevosPedidos.length >= _limit;

        setState(() {
          if (isRefresh) {
            _pedidosRemotos = nuevosPedidos;
          } else {
            _pedidosRemotos.addAll(nuevosPedidos);
          }
          _offset = _pedidosRemotos.length;
          _hasMore = hasMoreServer && nuevosPedidos.isNotEmpty;
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        if (isRefresh) {
          _errorMessage = 'Error al cargar pedidos: $e';
        }
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _cargarMasPedidos() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    await _cargarPedidos(isRefresh: false);
  }

  List<PedidoItemModel> _getCombinedPedidos(List<FullLocalOrder> localOrders) {
    final localItems = localOrders.map((full) {
      final statusLabel = full.order.syncStatus == 'PENDING_SYNC'
          ? 'PENDIENTE SYNC'
          : (full.order.syncStatus == 'SYNC_ERROR' ? 'ERROR SYNC' : 'FINALIZADO');
      return PedidoItemModel(
        fechaGeneracion: full.order.fecha,
        codigo: 'LOC-${full.order.id}',
        cliente: 'Cliente ID: ${full.order.clienteId}',
        monto: full.order.total,
        estado: statusLabel,
      );
    }).toList();

    return [...localItems, ..._pedidosRemotos];
  }

  List<PedidoItemModel> _getPedidosFiltrados(List<PedidoItemModel> allPedidos) {
    return allPedidos.where((p) {
      final query = _searchController.text.toLowerCase().trim();
      final matchSearch = query.isEmpty ||
          p.cliente.toLowerCase().contains(query) ||
          p.codigo.toLowerCase().contains(query);

      final hasStatusFilter = _filterFinalizado || _filterNuevo || _filterPendiente;
      if (!hasStatusFilter) return matchSearch;

      final matchState = (_filterFinalizado && (p.estado == 'FINALIZADO' || p.estado == 'SYNCED')) ||
          (_filterNuevo && p.estado == 'NUEVO') ||
          (_filterPendiente && (p.estado == 'PENDIENTE' || p.estado == 'PENDIENTE SYNC'));

      return matchSearch && matchState;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _filterFinalizado = false;
      _filterNuevo = false;
      _filterPendiente = false;
      _searchController.clear();
    });
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'FINALIZADO':
      case 'SYNCED':
        return const Color(0xFF2E7D32); // Verde oscuro
      case 'NUEVO':
        return const Color(0xFF1976D2); // Azul
      case 'PENDIENTE SYNC':
      case 'PENDIENTE':
        return AppColors.warningOrange; // Naranja
      case 'ERROR SYNC':
        return AppColors.primaryRed;
      default:
        return AppColors.textSecondary;
    }
  }

  int _countByEstado(String estado, List<PedidoItemModel> allPedidos) {
    return allPedidos.where((p) => p.estado.toUpperCase() == estado.toUpperCase()).length;
  }

  Widget _buildStatusPill(String estado) {
    final color = _getEstadoColor(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        estado,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPedidoCard(PedidoItemModel p) {
    final formattedMonto = '\$ ${p.monto.toStringAsFixed(2).replaceAll('.', ',')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: AppStyles.cardDecoration(
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Código de Pedido y Pill de Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PEDIDO: ${p.codigo}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1976D2),
                ),
              ),
              _buildStatusPill(p.estado),
            ],
          ),
          const Divider(height: 12, color: AppColors.cardBorder),

          // Fecha Generación
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Fecha: ${p.fechaGeneracion}',
                style: const TextStyle(fontSize: 12, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Cliente
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  p.cliente,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Monto Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monto Total:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Text(
                formattedMonto,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableView(List<PedidoItemModel> pedidosList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowHeight: 40,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 64,
        border: TableBorder.all(color: AppColors.cardBorder, width: 1),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
        columns: const [
          DataColumn(
            label: Text('Fecha Generacion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
          ),
          DataColumn(
            numeric: true,
            label: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Estado Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
        rows: pedidosList.map((p) {
          final formattedMonto = '\$${p.monto.toStringAsFixed(2).replaceAll('.', ',')}';
          return DataRow(cells: [
            DataCell(Text(p.fechaGeneracion, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
            DataCell(Text(p.codigo, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
            DataCell(
              InkWell(
                onTap: () {
                  setState(() {
                    _searchController.text = p.cliente;
                  });
                },
                child: SizedBox(
                  width: 180,
                  child: Text(
                    p.cliente,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            DataCell(Text(formattedMonto, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
            DataCell(_buildStatusPill(p.estado)),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildBody(List<PedidoItemModel> pedidosList) {
    if (_isLoading && _pedidosRemotos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64.0),
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    if (_errorMessage != null && _pedidosRemotos.isEmpty) {
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
                onPressed: () => _cargarPedidos(isRefresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          if (pedidosList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No se encontraron pedidos',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ),
            );
          }
          return Column(
            children: pedidosList.map((p) => _buildPedidoCard(p)).toList(),
          );
        } else {
          return _buildTableView(pedidosList);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final syncNotifier = Provider.of<SyncNotifier>(context);
    final allPedidos = _getCombinedPedidos(syncNotifier.localOrders);
    final pedidosList = _getPedidosFiltrados(allPedidos);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (syncNotifier.pendingSyncCount > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.warningOrange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_off, color: AppColors.warningOrange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hay ${syncNotifier.pendingSyncCount} pedido(s) guardado(s) offline pendiente(s) de sincronizar.',
                          style: const TextStyle(fontSize: 12, color: Color(0xFFE65100), fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (syncNotifier.isSyncing)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.warningOrange),
                        )
                      else
                        TextButton(
                          onPressed: () => syncNotifier.syncPendingOrdersNow(),
                          child: const Text('Sincronizar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),

              // Buscador de Pedidos / Cliente
              SearchFilterBar(
                controller: _searchController,
                hintText: 'Buscar pedido por cliente o código...',
                onSearch: () => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Sección Filtros: Estado
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
                        'Estado',
                        style: AppStyles.sectionTitleStyle,
                      ),
                    ],
                  ),
                  children: [
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('FINALIZADO (${_countByEstado("FINALIZADO", allPedidos)})', style: const TextStyle(fontSize: 13)),
                      value: _filterFinalizado,
                      onChanged: (val) => setState(() => _filterFinalizado = val ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('NUEVO (${_countByEstado("NUEVO", allPedidos)})', style: const TextStyle(fontSize: 13)),
                      value: _filterNuevo,
                      onChanged: (val) => setState(() => _filterNuevo = val ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('PENDIENTE (${_countByEstado("PENDIENTE", allPedidos) + _countByEstado("PENDIENTE SYNC", allPedidos)})', style: const TextStyle(fontSize: 13)),
                      value: _filterPendiente,
                      onChanged: (val) => setState(() => _filterPendiente = val ?? false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recuento total de filas y botón restablecer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListHeaderSummary(
                    count: pedidosList.length,
                    label: 'pedidos',
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

              _buildBody(pedidosList),

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
    );
  }
}
