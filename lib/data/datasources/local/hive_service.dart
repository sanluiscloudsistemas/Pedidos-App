import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/repositories/sync_repository.dart';

/// Servicio de persistencia local basado en Hive (100% Dart puro, sin C++ ni SQLite)
class HiveService {
  static const String ordersBoxName = 'preventas_orders_box';
  static const String orderItemsBoxName = 'preventas_order_items_box';
  static const String clientsBoxName = 'preventas_clients_box';
  static const String faltantesBoxName = 'preventas_faltantes_box';

  late Box<Map> _ordersBox;
  late Box<Map> _orderItemsBox;
  late Box<Map> _clientsBox;
  late Box<Map> _faltantesBox;

  final StreamController<List<FullLocalOrder>> _ordersStreamController =
      StreamController<List<FullLocalOrder>>.broadcast();

  Stream<List<FullLocalOrder>> get ordersStream => _ordersStreamController.stream;

  /// Inicializa las cajas locales de Hive
  Future<void> init() async {
    _ordersBox = await Hive.openBox<Map>(ordersBoxName);
    _orderItemsBox = await Hive.openBox<Map>(orderItemsBoxName);
    _clientsBox = await Hive.openBox<Map>(clientsBoxName);
    _faltantesBox = await Hive.openBox<Map>(faltantesBoxName);

    // Emitir estado inicial de órdenes
    _notifyOrdersChanged();
  }

  void _notifyOrdersChanged() {
    if (!_ordersStreamController.isClosed) {
      _ordersStreamController.add(getAllOrders());
    }
  }

  // ==================== PEDIDOS ====================

  /// Guarda una nueva orden y sus ítems localmente
  Future<int> saveOrder({
    required int organizacionId,
    required int clienteId,
    String clienteNombre = '',
    required int vendedorId,
    required int repartoId,
    String repartoNombre = '',
    required String condicionVenta,
    required double total,
    required String fecha,
    String syncStatus = 'PENDING_SYNC',
    required List<Map<String, dynamic>> items,
  }) async {
    // Generar ID autoincremental
    final int nextOrderId = (_ordersBox.keys.isNotEmpty
            ? _ordersBox.keys.cast<int>().reduce((a, b) => a > b ? a : b)
            : 0) +
        1;

    final orderEntity = LocalOrderEntity(
      id: nextOrderId,
      organizacionId: organizacionId,
      clienteId: clienteId,
      clienteNombre: clienteNombre,
      vendedorId: vendedorId,
      repartoId: repartoId,
      repartoNombre: repartoNombre,
      condicionVenta: condicionVenta,
      total: total,
      fecha: fecha,
      syncStatus: syncStatus,
      createdAt: DateTime.now(),
    );

    await _ordersBox.put(nextOrderId, orderEntity.toMap());

    // Guardar ítems asociados
    for (final item in items) {
      final int nextItemId = (_orderItemsBox.keys.isNotEmpty
              ? _orderItemsBox.keys.cast<int>().reduce((a, b) => a > b ? a : b)
              : 0) +
          1;

      final prodCodigo = item['producto_codigo']?.toString() ??
          item['productoCodigo']?.toString() ??
          item['codigo']?.toString() ??
          item['productoId']?.toString() ??
          '';

      final desc = item['descripcion']?.toString() ??
          item['producto_descripcion']?.toString() ??
          item['producto']?.toString() ??
          item['nombre']?.toString() ??
          '';

      final itemEntity = LocalOrderItemEntity(
        id: nextItemId,
        pedidoLocalId: nextOrderId,
        productoId: (item['productoId'] as num?)?.toInt() ??
            (int.tryParse(prodCodigo) ?? 0),
        productoCodigo: prodCodigo,
        descripcion: desc,
        cantidad: (item['cantidad'] as num?)?.toInt() ?? 1,
        precioUnitario: (item['precioUnitario'] as num?)?.toDouble() ??
            (item['precio_unitario'] as num?)?.toDouble() ??
            0.0,
        descuento: (item['descuento'] as num?)?.toDouble() ?? 0.0,
        precioTotal: (item['precioTotal'] as num?)?.toDouble() ??
            (item['precio_total'] as num?)?.toDouble() ??
            0.0,
      );

      await _orderItemsBox.put(nextItemId, itemEntity.toMap());
    }

    _notifyOrdersChanged();
    return nextOrderId;
  }

  /// Retorna todos los pedidos locales junto con sus ítems
  List<FullLocalOrder> getAllOrders() {
    final List<FullLocalOrder> list = [];

    for (final key in _ordersBox.keys) {
      final orderMap = _ordersBox.get(key);
      if (orderMap != null) {
        final order = LocalOrderEntity.fromMap(orderMap);

        // Buscar ítems que pertenezcan a este pedido
        final List<LocalOrderItemEntity> orderItems = [];
        for (final itemKey in _orderItemsBox.keys) {
          final itemMap = _orderItemsBox.get(itemKey);
          if (itemMap != null &&
              (itemMap['pedidoLocalId'] as num?)?.toInt() == order.id) {
            orderItems.add(LocalOrderItemEntity.fromMap(itemMap));
          }
        }

        list.add(FullLocalOrder(order: order, items: orderItems));
      }
    }

    // Ordenar descendente por ID (más reciente primero)
    list.sort((a, b) => b.order.id.compareTo(a.order.id));
    return list;
  }

  /// Retorna únicamente los pedidos en estado PENDING_SYNC
  List<FullLocalOrder> getPendingOrders() {
    return getAllOrders()
        .where((full) => full.order.syncStatus == 'PENDING_SYNC')
        .toList();
  }

  /// Actualiza el estado de sincronización de un pedido
  Future<void> updateOrderStatus(
    int orderId,
    String status, {
    String? errorMessage,
  }) async {
    final orderMap = _ordersBox.get(orderId);
    if (orderMap != null) {
      final current = LocalOrderEntity.fromMap(orderMap);
      final updated = current.copyWith(
        syncStatus: status,
        syncErrorMessage: errorMessage,
      );
      await _ordersBox.put(orderId, updated.toMap());
      _notifyOrdersChanged();
    }
  }

  // ==================== CLIENTES ====================

  /// Guarda un cliente offline
  Future<int> saveCliente({
    required int organizacionId,
    required int vendedorId,
    required String nombre,
    required String razonSocial,
    required String tipoDocumento,
    required String numeroDocumento,
    required String tipoIva,
    String? telefono,
    String? emailPrincipal,
    String? geoposicion,
  }) async {
    final int nextId = (_clientsBox.keys.isNotEmpty
            ? _clientsBox.keys.cast<int>().reduce((a, b) => a > b ? a : b)
            : 0) +
        1;

    final clientMap = {
      'id': nextId,
      'organizacionId': organizacionId,
      'vendedorId': vendedorId,
      'nombre': nombre,
      'razonSocial': razonSocial,
      'tipoDocumento': tipoDocumento,
      'numeroDocumento': numeroDocumento,
      'tipoIva': tipoIva,
      'telefono': telefono,
      'emailPrincipal': emailPrincipal,
      'geoposicion': geoposicion,
      'syncStatus': 'PENDING_SYNC',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _clientsBox.put(nextId, clientMap);
    return nextId;
  }

  List<Map<String, dynamic>> getPendingClientes() {
    final List<Map<String, dynamic>> list = [];
    for (final key in _clientsBox.keys) {
      final map = _clientsBox.get(key);
      if (map != null && map['syncStatus'] == 'PENDING_SYNC') {
        list.add(Map<String, dynamic>.from(map));
      }
    }
    return list;
  }

  Future<void> updateClienteStatus(int id, String status, {String? errorMessage}) async {
    final map = _clientsBox.get(id);
    if (map != null) {
      final updated = Map<String, dynamic>.from(map);
      updated['syncStatus'] = status;
      if (errorMessage != null) updated['syncErrorMessage'] = errorMessage;
      await _clientsBox.put(id, updated);
    }
  }

  // ==================== FALTANTES ====================

  /// Guarda un faltante offline
  Future<int> saveFaltante({
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    String? observacion,
  }) async {
    final int nextId = (_faltantesBox.keys.isNotEmpty
            ? _faltantesBox.keys.cast<int>().reduce((a, b) => a > b ? a : b)
            : 0) +
        1;

    final faltanteMap = {
      'id': nextId,
      'organizacionId': organizacionId,
      'vendedorId': vendedorId,
      'productoId': productoId,
      'fecha': fecha,
      'observacion': observacion,
      'syncStatus': 'PENDING_SYNC',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _faltantesBox.put(nextId, faltanteMap);
    return nextId;
  }

  List<Map<String, dynamic>> getPendingFaltantes() {
    final List<Map<String, dynamic>> list = [];
    for (final key in _faltantesBox.keys) {
      final map = _faltantesBox.get(key);
      if (map != null && map['syncStatus'] == 'PENDING_SYNC') {
        list.add(Map<String, dynamic>.from(map));
      }
    }
    return list;
  }

  Future<void> updateFaltanteStatus(int id, String status, {String? errorMessage}) async {
    final map = _faltantesBox.get(id);
    if (map != null) {
      final updated = Map<String, dynamic>.from(map);
      updated['syncStatus'] = status;
      if (errorMessage != null) updated['syncErrorMessage'] = errorMessage;
      await _faltantesBox.put(id, updated);
    }
  }

  Future<void> close() async {
    await _ordersStreamController.close();
    await _ordersBox.close();
    await _orderItemsBox.close();
    await _clientsBox.close();
    await _faltantesBox.close();
  }
}
