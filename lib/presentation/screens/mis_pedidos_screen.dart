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
import 'pedido_detail_screen.dart';

/// Modelo para un ítem dentro de un pedido
class PedidoDetalleItem {
  final String codigo;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double precioTotal;

  const PedidoDetalleItem({
    required this.codigo,
    this.descripcion = '',
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
    required this.precioTotal,
  });

  factory PedidoDetalleItem.fromJson(Map<String, dynamic> json) {
    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString().replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '.').trim()) ?? 0.0;
    }

    final cantRaw = json['cantidad'] ?? json['CANTIDAD'] ?? json['cant'] ?? json['CANT'];
    final cant = cantRaw is int
        ? cantRaw
        : (int.tryParse(cantRaw?.toString() ?? '') ?? 1);

    final unit = parseNum(
      json['precio_unitario'] ??
      json['PRECIO_UNITARIO'] ??
      json['monto_unitario'] ??
      json['MONTO_UNITARIO'] ??
      json['precio'] ??
      json['PRECIO']
    );

    final desc = parseNum(json['descuento'] ?? json['DESCUENTO']);

    final totalRaw = json['precio_total'] ??
        json['PRECIO_TOTAL'] ??
        json['monto_total'] ??
        json['MONTO_TOTAL'] ??
        json['total'] ??
        json['TOTAL'];
    final total = parseNum(totalRaw) > 0 ? parseNum(totalRaw) : (cant * unit) - desc;

    final codigoStr = json['producto_codigo']?.toString() ??
        json['PRODUCTO_CODIGO']?.toString() ??
        json['propro_codigo']?.toString() ??
        json['PROPRO_CODIGO']?.toString() ??
        json['producto_id']?.toString() ??
        json['PRODUCTO_ID']?.toString() ??
        json['propro_id']?.toString() ??
        json['PROPRO_ID']?.toString() ??
        json['codigo']?.toString() ??
        json['CODIGO']?.toString() ??
        json['id']?.toString() ??
        json['ID']?.toString() ??
        '';

    final descStr = json['descripcion']?.toString() ??
        json['DESCRIPCION']?.toString() ??
        json['producto_descripcion']?.toString() ??
        json['PRODUCTO_DESCRIPCION']?.toString() ??
        json['producto']?.toString() ??
        json['PRODUCTO']?.toString() ??
        json['nombre']?.toString() ??
        json['NOMBRE']?.toString() ??
        (codigoStr.isNotEmpty ? 'Producto #$codigoStr' : '');

    return PedidoDetalleItem(
      codigo: codigoStr,
      descripcion: descStr,
      cantidad: cant,
      precioUnitario: unit,
      descuento: desc,
      precioTotal: total,
    );
  }
}

/// Modelo de datos para un Pedido en la vista de lista
class PedidoItemModel {
  final String fechaGeneracion;
  final String fechaEntrega;
  final String estadoFecha;
  final String? estadoColor;
  final String? id;
  final String codigo;
  final String cliente;
  final double monto;
  final String estado;
  final String condicionVenta;
  final String reparto;
  final List<PedidoDetalleItem> items;
  final bool isOffline;

  const PedidoItemModel({
    required this.fechaGeneracion,
    this.fechaEntrega = '',
    this.estadoFecha = '',
    this.estadoColor,
    this.id,
    required this.codigo,
    required this.cliente,
    required this.monto,
    required this.estado,
    this.condicionVenta = 'CONTADO',
    this.reparto = '',
    this.items = const [],
    this.isOffline = false,
  });

  PedidoItemModel copyWith({
    String? fechaGeneracion,
    String? fechaEntrega,
    String? estadoFecha,
    String? estadoColor,
    String? id,
    String? codigo,
    String? cliente,
    double? monto,
    String? estado,
    String? condicionVenta,
    String? reparto,
    List<PedidoDetalleItem>? items,
    bool? isOffline,
  }) {
    return PedidoItemModel(
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      estadoFecha: estadoFecha ?? this.estadoFecha,
      estadoColor: estadoColor ?? this.estadoColor,
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      cliente: cliente ?? this.cliente,
      monto: monto ?? this.monto,
      estado: estado ?? this.estado,
      condicionVenta: condicionVenta ?? this.condicionVenta,
      reparto: reparto ?? this.reparto,
      items: items ?? this.items,
      isOffline: isOffline ?? this.isOffline,
    );
  }

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

    final List<PedidoDetalleItem> parsedItems = [];
    final rawItems = json['items'] ??
        json['ITEMS'] ??
        json['detalles'] ??
        json['DETALLES'] ??
        json['lineas'] ??
        json['LINEAS'] ??
        json['productos'] ??
        json['PRODUCTOS'] ??
        json['detalle'] ??
        json['DETALLE'];

    if (rawItems is List) {
      for (final it in rawItems) {
        if (it is Map<String, dynamic>) {
          parsedItems.add(PedidoDetalleItem.fromJson(it));
        } else if (it is Map) {
          parsedItems.add(PedidoDetalleItem.fromJson(Map<String, dynamic>.from(it)));
        }
      }
    }

    final fechaGen = json['fecha_generacion']?.toString().trim() ??
        json['FECHA_GENERACION']?.toString().trim() ??
        json['fecha']?.toString().trim() ??
        json['FECHA']?.toString().trim() ??
        json['fecha_creacion']?.toString().trim() ??
        json['FECHA_CREACION']?.toString().trim() ??
        '';

    final fechaEnt = json['fecha_entrega']?.toString().trim() ??
        json['FECHA_ENTREGA']?.toString().trim() ??
        '';

    final estadoFec = json['estado_fecha']?.toString().trim() ??
        json['ESTADO_FECHA']?.toString().trim() ??
        '';

    final estadoCol = json['estado_color']?.toString().trim() ??
        json['ESTADO_COLOR']?.toString().trim();

    final idVal = json['id']?.toString().trim() ??
        json['ID']?.toString().trim() ??
        json['pedido_id']?.toString().trim() ??
        json['PEDIDO_ID']?.toString().trim() ??
        json['comcom_id']?.toString().trim() ??
        json['COMCOM_ID']?.toString().trim();

    final codigoVal = json['codigo']?.toString().trim() ??
        json['CODIGO']?.toString().trim() ??
        (idVal != null && idVal.isNotEmpty ? idVal : '');

    final clienteNombre = json['cliente']?.toString().trim() ??
        json['CLIENTE']?.toString().trim() ??
        json['cliente_nombre']?.toString().trim() ??
        json['CLIENTE_NOMBRE']?.toString().trim() ??
        (json['cliente_id'] != null
            ? 'Cliente ID: ${json['cliente_id']}'
            : (json['CLIENTE_ID'] != null ? 'Cliente ID: ${json['CLIENTE_ID']}' : 'Sin cliente'));

    final montoVal = parseMonto(
      json['monto'] ??
      json['MONTO'] ??
      json['total'] ??
      json['TOTAL']
    );

    final estadoVal = json['estado']?.toString().trim() ??
        json['ESTADO']?.toString().trim() ??
        'NUEVO';

    final condVenta = json['condicion_venta']?.toString().trim() ??
        json['CONDICION_VENTA']?.toString().trim() ??
        json['condicionventa']?.toString().trim() ??
        json['CONDICIONVENTA']?.toString().trim() ??
        'CONTADO';

    final repartoVal = json['reparto']?.toString().trim() ??
        json['REPARTO']?.toString().trim() ??
        (json['sisrep_id'] != null
            ? 'Reparto ID: ${json['sisrep_id']}'
            : (json['SISREP_ID'] != null
                ? 'Reparto ID: ${json['SISREP_ID']}'
                : (json['reparto_id'] != null
                    ? 'Reparto ID: ${json['reparto_id']}'
                    : (json['REPARTO_ID'] != null ? 'Reparto ID: ${json['REPARTO_ID']}' : ''))));

    return PedidoItemModel(
      fechaGeneracion: fechaGen,
      fechaEntrega: fechaEnt,
      estadoFecha: estadoFec,
      estadoColor: estadoCol,
      id: idVal,
      codigo: codigoVal,
      cliente: clienteNombre,
      monto: montoVal,
      estado: estadoVal,
      condicionVenta: condVenta,
      reparto: repartoVal,
      items: parsedItems,
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
  bool _filterSoloOffline = false;
  bool _filterSoloOnline = false;

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
      final mappedItems = full.items.map((it) {
        final cod = it.productoCodigo.isNotEmpty ? it.productoCodigo : it.productoId.toString();
        final des = it.descripcion.isNotEmpty ? it.descripcion : 'Producto #$cod';
        return PedidoDetalleItem(
          codigo: cod,
          descripcion: des,
          cantidad: it.cantidad,
          precioUnitario: it.precioUnitario,
          descuento: it.descuento,
          precioTotal: it.precioTotal,
        );
      }).toList();

      final cliText = full.order.clienteNombre.isNotEmpty
          ? full.order.clienteNombre
          : 'Cliente ID: ${full.order.clienteId}';

      final repText = full.order.repartoNombre.isNotEmpty
          ? full.order.repartoNombre
          : (full.order.repartoId > 0 ? 'Reparto ID: ${full.order.repartoId}' : '');

      return PedidoItemModel(
        fechaGeneracion: full.order.fecha,
        codigo: 'LOC-${full.order.id}',
        cliente: cliText,
        monto: full.order.total,
        estado: statusLabel,
        condicionVenta: full.order.condicionVenta,
        reparto: repText,
        items: mappedItems,
        isOffline: true,
      );
    }).toList();

    // Para cada pedido remoto: si no contiene ítems en el JSON de cabecera,
    // buscar si coincide con una orden local (por ID, código o cliente/monto) para asociar sus ítems
    final enrichedRemotos = _pedidosRemotos.map((remoto) {
      if (remoto.items.isNotEmpty) return remoto;

      final matching = localOrders.cast<FullLocalOrder?>().firstWhere(
        (loc) {
          if (loc == null) return false;
          if (remoto.codigo.isNotEmpty &&
              (remoto.codigo == loc.order.id.toString() ||
               remoto.codigo == 'LOC-${loc.order.id}')) {
            return true;
          }
          if (remoto.id != null && remoto.id == loc.order.id.toString()) {
            return true;
          }
          // Coincidencia por fecha y monto idénticos
          if (remoto.fechaGeneracion.isNotEmpty &&
              remoto.fechaGeneracion == loc.order.fecha &&
              remoto.monto == loc.order.total) {
            return true;
          }
          return false;
        },
        orElse: () => null,
      );

      if (matching != null && matching.items.isNotEmpty) {
        final mappedItems = matching.items.map((it) {
          final cod = it.productoCodigo.isNotEmpty ? it.productoCodigo : it.productoId.toString();
          final des = it.descripcion.isNotEmpty ? it.descripcion : 'Producto #$cod';
          return PedidoDetalleItem(
            codigo: cod,
            descripcion: des,
            cantidad: it.cantidad,
            precioUnitario: it.precioUnitario,
            descuento: it.descuento,
            precioTotal: it.precioTotal,
          );
        }).toList();

        return remoto.copyWith(items: mappedItems);
      }
      return remoto;
    }).toList();

    return [...localItems, ...enrichedRemotos];
  }

  List<PedidoItemModel> _getPedidosFiltrados(List<PedidoItemModel> allPedidos) {
    return allPedidos.where((p) {
      final query = _searchController.text.toLowerCase().trim();
      final matchSearch = query.isEmpty ||
          p.cliente.toLowerCase().contains(query) ||
          p.codigo.toLowerCase().contains(query);

      if (!matchSearch) return false;

      // Filtro por Origen (Offline vs Online)
      if (_filterSoloOffline && !p.isOffline) return false;
      if (_filterSoloOnline && p.isOffline) return false;

      final hasStatusFilter = _filterFinalizado || _filterNuevo || _filterPendiente;
      if (!hasStatusFilter) return true;

      final matchState = (_filterFinalizado && (p.estado == 'FINALIZADO' || p.estado == 'SYNCED')) ||
          (_filterNuevo && p.estado == 'NUEVO') ||
          (_filterPendiente && (p.estado == 'PENDIENTE' || p.estado == 'PENDIENTE SYNC'));

      return matchState;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _filterFinalizado = false;
      _filterNuevo = false;
      _filterPendiente = false;
      _filterSoloOffline = false;
      _filterSoloOnline = false;
      _searchController.clear();
    });
  }

  Widget _buildOriginPill(bool isOffline) {
    final bg = isOffline ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9);
    final border = isOffline ? const Color(0xFFFFB74D) : const Color(0xFFA5D6A7);
    final color = isOffline ? const Color(0xFFE65100) : const Color(0xFF2E7D32);
    final icon = isOffline ? Icons.cloud_off : Icons.cloud_done;
    final label = isOffline ? 'OFFLINE' : 'ONLINE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
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
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
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

  void _abrirDetallePedido(BuildContext context, PedidoItemModel p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PedidoDetailScreen(pedido: p),
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
          // Código de Pedido, Origen y Pill de Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () => _abrirDetallePedido(context, p),
                        child: Text(
                          'PEDIDO: ${p.codigo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1976D2),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF1976D2),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildOriginPill(p.isOffline),
                  ],
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
            label: Text('Origen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
          ),
          DataColumn(
            label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
            DataCell(_buildOriginPill(p.isOffline)),
            DataCell(
              InkWell(
                onTap: () => _abrirDetallePedido(context, p),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    p.codigo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF1976D2),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 180,
                child: Text(
                  p.cliente,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                    const Divider(height: 1, color: AppColors.cardBorder),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        children: [
                          const Icon(Icons.cloud_off, size: 16, color: Color(0xFFE65100)),
                          const SizedBox(width: 6),
                          Text('MODO OFFLINE (${allPedidos.where((p) => p.isOffline).length})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      value: _filterSoloOffline,
                      onChanged: (val) => setState(() {
                        _filterSoloOffline = val ?? false;
                        if (_filterSoloOffline) _filterSoloOnline = false;
                      }),
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        children: [
                          const Icon(Icons.cloud_done, size: 16, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 6),
                          Text('MODO ONLINE / API (${allPedidos.where((p) => !p.isOffline).length})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      value: _filterSoloOnline,
                      onChanged: (val) => setState(() {
                        _filterSoloOnline = val ?? false;
                        if (_filterSoloOnline) _filterSoloOffline = false;
                      }),
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
