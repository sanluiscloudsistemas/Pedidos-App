import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../domain/repositories/sync_repository.dart';
import '../notifiers/sync_notifier.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';

/// Modelo de datos para un Pedido en la vista de lista
class PedidoItemModel {
  // falta agregar -Forma de Pago- si se va querer mostrar con formato en la lista con el nombre del Cliente.
  final String fechaGeneracion;
  final String codigo;
  final String cliente;
  final double monto;
  final String estado;

  const PedidoItemModel({
    // falta agregar -Forma de Pago- si se va querer mostrar con formato en la lista con el nombre del Cliente.
    required this.fechaGeneracion,
    required this.codigo,
    required this.cliente,
    required this.monto,
    required this.estado,
  });
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
  bool _filterFinalizado = false;
  bool _filterNuevo = false;
  bool _filterPendiente = false;
  final TextEditingController _searchController = TextEditingController();

  final List<PedidoItemModel> _pedidosOriginales = [];

  @override
  void initState() {
    super.initState();
    if (widget.clienteNombre != null) {
      _searchController.text = widget.clienteNombre!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    return [...localItems, ..._pedidosOriginales];
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
        return AppColors.primaryRed;
      case 'NUEVO':
        return const Color(0xFF1976D2);
      case 'PENDIENTE SYNC':
      case 'PENDIENTE':
        return AppColors.warningOrange;
      case 'ERROR SYNC':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  int _countByEstado(String estado, List<PedidoItemModel> allPedidos) {
    return allPedidos.where((p) => p.estado == estado).length;
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

              // Tabla de Datos de Pedidos
              SingleChildScrollView(
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
                      label: Text('Fecha\nGeneracion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                      label: Text('Estado\nColor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                      DataCell(
                        Text(
                          p.estado,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getEstadoColor(p.estado),
                            fontWeight: FontWeight.bold,
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
