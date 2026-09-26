import 'package:flutter/material.dart';

import '../../data/datasources/remote/api_service.dart';
import '../../data/models/pedido_item_model.dart';
import '../../domain/repositories/sync_repository.dart';

/// Notificador y gestor de estado para la lista de Pedidos (Mis Pedidos).
/// Centraliza la obtención remota vía ApiService, paginación, combinación con Hive y filtrado.
class PedidosNotifier extends ChangeNotifier {
  final ApiService apiService;

  List<PedidoItemModel> _pedidosRemotos = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 25;
  String? _errorMessage;

  // Filtros
  String _searchQuery = '';
  bool _filterFinalizado = false;
  bool _filterNuevo = false;
  bool _filterPendiente = false;
  bool _filterSoloOffline = false;
  bool _filterSoloOnline = false;

  PedidosNotifier({
    required this.apiService,
    String? initialSearchQuery,
  }) {
    if (initialSearchQuery != null && initialSearchQuery.isNotEmpty) {
      _searchQuery = initialSearchQuery;
    }
  }

  // Getters de estado
  List<PedidoItemModel> get pedidosRemotos => _pedidosRemotos;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  bool get filterFinalizado => _filterFinalizado;
  bool get filterNuevo => _filterNuevo;
  bool get filterPendiente => _filterPendiente;
  bool get filterSoloOffline => _filterSoloOffline;
  bool get filterSoloOnline => _filterSoloOnline;

  bool get hasActiveStatusFilters =>
      _filterFinalizado || _filterNuevo || _filterPendiente;

  bool get hasAnyActiveFilter =>
      _filterFinalizado ||
      _filterNuevo ||
      _filterPendiente ||
      _filterSoloOffline ||
      _filterSoloOnline ||
      _searchQuery.isNotEmpty;

  // Modificadores de filtros
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFilterFinalizado() {
    _filterFinalizado = !_filterFinalizado;
    notifyListeners();
  }

  void setFilterFinalizado(bool val) {
    _filterFinalizado = val;
    notifyListeners();
  }

  void toggleFilterNuevo() {
    _filterNuevo = !_filterNuevo;
    notifyListeners();
  }

  void setFilterNuevo(bool val) {
    _filterNuevo = val;
    notifyListeners();
  }

  void toggleFilterPendiente() {
    _filterPendiente = !_filterPendiente;
    notifyListeners();
  }

  void setFilterPendiente(bool val) {
    _filterPendiente = val;
    notifyListeners();
  }

  void toggleFilterSoloOffline() {
    _filterSoloOffline = !_filterSoloOffline;
    if (_filterSoloOffline) _filterSoloOnline = false;
    notifyListeners();
  }

  void toggleFilterSoloOnline() {
    _filterSoloOnline = !_filterSoloOnline;
    if (_filterSoloOnline) _filterSoloOffline = false;
    notifyListeners();
  }

  void resetFilters() {
    _filterFinalizado = false;
    _filterNuevo = false;
    _filterPendiente = false;
    _filterSoloOffline = false;
    _filterSoloOnline = false;
    _searchQuery = '';
    notifyListeners();
  }

  // Carga de pedidos remotos
  Future<void> cargarPedidos({bool isRefresh = false}) async {
    if (isRefresh) {
      _isLoading = true;
      _errorMessage = null;
      _offset = 0;
      _hasMore = true;
      notifyListeners();
    }

    try {
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

        if (isRefresh) {
          _pedidosRemotos = nuevosPedidos;
        } else {
          _pedidosRemotos.addAll(nuevosPedidos);
        }
        _pedidosRemotos.sort(PedidoItemModel.compareDesc);
        _offset = _pedidosRemotos.length;
        _hasMore = hasMoreServer && nuevosPedidos.isNotEmpty;
      }
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      if (isRefresh) {
        _errorMessage = 'Error al cargar pedidos: $e';
      }
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> cargarMasPedidos() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();
    await cargarPedidos(isRefresh: false);
  }

  /// Combina los pedidos de la base local Hive con los pedidos remotos de la API,
  /// asociando ítems y evitando duplicaciones.
  List<PedidoItemModel> getCombinedPedidos(List<FullLocalOrder> localOrders) {
    final localItems = localOrders.where((full) {
      // Si la orden ya se encuentra en los pedidos remotos, no duplicarla
      final existsInRemote = _pedidosRemotos.any((remoto) {
        if (remoto.codigo.isNotEmpty &&
            (remoto.codigo == full.order.id.toString() ||
             remoto.codigo == 'LOC-${full.order.id}')) {
          return true;
        }
        if (remoto.id != null && remoto.id == full.order.id.toString()) {
          return true;
        }
        if (remoto.fechaGeneracion.isNotEmpty &&
            remoto.fechaGeneracion == full.order.fecha &&
            remoto.monto == full.order.total) {
          return true;
        }
        return false;
      });
      return !existsInRemote;
    }).map((full) {
      final isOfflineOrder = !full.order.isCreatedOnline && full.order.syncStatus != 'SYNCED';
      final estadoComercial = full.order.estado.isNotEmpty ? full.order.estado : 'NUEVO';
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
        fechaCreacion: full.order.createdAt,
        codigo: 'LOC-${full.order.id}',
        cliente: cliText,
        monto: full.order.total,
        estado: estadoComercial,
        condicionVenta: full.order.condicionVenta,
        reparto: repText,
        items: mappedItems,
        isOffline: isOfflineOrder,
      );
    }).toList();

    // Para cada pedido remoto: si no contiene ítems en el JSON de cabecera,
    // buscar si coincide con una orden local para asociar sus ítems
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

    final combined = [...localItems, ...enrichedRemotos];
    combined.sort(PedidoItemModel.compareDesc);
    return combined;
  }

  /// Retorna la lista combinada filtrada según los criterios activos
  List<PedidoItemModel> getFilteredPedidos(List<FullLocalOrder> localOrders) {
    final all = getCombinedPedidos(localOrders);

    final filtered = all.where((p) {
      final query = _searchQuery.toLowerCase().trim();
      final matchSearch = query.isEmpty ||
          p.cliente.toLowerCase().contains(query) ||
          p.codigo.toLowerCase().contains(query);

      if (!matchSearch) return false;

      // Filtro por Origen (Offline vs Online)
      if (_filterSoloOffline && !p.isOffline) return false;
      if (_filterSoloOnline && p.isOffline) return false;

      if (!hasActiveStatusFilters) return true;

      final matchState = (_filterFinalizado && p.estado.toUpperCase() == 'FINALIZADO') ||
          (_filterNuevo && p.estado.toUpperCase() == 'NUEVO') ||
          (_filterPendiente && p.estado.toUpperCase() == 'PENDIENTE');

      return matchState;
    }).toList();

    filtered.sort(PedidoItemModel.compareDesc);
    return filtered;
  }

  /// Cantidad de pedidos según estado comercial
  int countByEstado(String estado, List<FullLocalOrder> localOrders) {
    final all = getCombinedPedidos(localOrders);
    return all.where((p) => p.estado.toUpperCase() == estado.toUpperCase()).length;
  }
}
