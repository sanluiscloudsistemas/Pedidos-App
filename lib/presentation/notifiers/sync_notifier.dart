import 'dart:async';
import 'package:flutter/material.dart';

import '../../domain/repositories/sync_repository.dart';
import 'connectivity_notifier.dart';

/// Notificador y Coordinador de Sincronización Offline-First.
/// Escucha a `ConnectivityNotifier`. Al detectar retorno a la red (`isConnected == true`),
/// sincroniza automáticamente los pedidos pendientes de Hive con la API remota.
class SyncNotifier extends ChangeNotifier {
  final SyncRepository syncRepository;
  final ConnectivityNotifier connectivityNotifier;

  bool _isSyncing = false;
  int _lastSyncedCount = 0;
  String? _lastSyncMessage;
  List<FullLocalOrder> _localOrders = [];

  bool get isSyncing => _isSyncing;
  int get lastSyncedCount => _lastSyncedCount;
  String? get lastSyncMessage => _lastSyncMessage;
  List<FullLocalOrder> get localOrders => _localOrders;

  int get pendingSyncCount =>
      _localOrders.where((o) => o.order.syncStatus == 'PENDING_SYNC').length;

  StreamSubscription<List<FullLocalOrder>>? _ordersSubscription;
  bool _wasOffline = false;

  SyncNotifier({
    required this.syncRepository,
    required this.connectivityNotifier,
  }) {
    _initListeners();
  }

  void _initListeners() {
    // 1. Escuchar cambios de la lista de pedidos en Hive en tiempo real
    _ordersSubscription = syncRepository.watchAllLocalOrders().listen((orders) {
      _localOrders = orders;
      notifyListeners();
    });

    // 2. Escuchar cambios de conectividad a Internet
    _wasOffline = !connectivityNotifier.isConnected;

    connectivityNotifier.addListener(_handleConnectivityChange);
  }

  void _handleConnectivityChange() {
    final currentlyOnline = connectivityNotifier.isConnected;

    // Detectar transición de Offline a Online
    if (_wasOffline && currentlyOnline) {
      _wasOffline = false;
      syncPendingOrdersNow();
    } else if (!currentlyOnline) {
      _wasOffline = true;
    }

    notifyListeners();
  }

  /// Guarda un nuevo pedido de forma offline en Hive
  Future<int> saveOrderOffline({
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
    final id = await syncRepository.saveOrderOffline(
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
      items: items,
    );

    // Si actualmente está online, intentar sincronizar de inmediato
    if (connectivityNotifier.isConnected) {
      syncPendingOrdersNow();
    }

    return id;
  }

  /// Guarda un cliente nuevo offline
  Future<int> saveClienteOffline({
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
    final id = await syncRepository.saveClienteOffline(
      organizacionId: organizacionId,
      vendedorId: vendedorId,
      nombre: nombre,
      razonSocial: razonSocial,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      tipoIva: tipoIva,
      telefono: telefono,
      emailPrincipal: emailPrincipal,
      geoposicion: geoposicion,
    );

    if (connectivityNotifier.isConnected) {
      syncPendingOrdersNow();
    }
    return id;
  }

  /// Guarda un faltante offline
  Future<int> saveFaltanteOffline({
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    String? observacion,
  }) async {
    final id = await syncRepository.saveFaltanteOffline(
      organizacionId: organizacionId,
      vendedorId: vendedorId,
      productoId: productoId,
      fecha: fecha,
      observacion: observacion,
    );

    if (connectivityNotifier.isConnected) {
      syncPendingOrdersNow();
    }
    return id;
  }

  /// Dispara la sincronización manual o automática de pedidos pendientes
  Future<int> syncPendingOrdersNow() async {
    if (_isSyncing) return 0;

    _isSyncing = true;
    _lastSyncMessage = null;
    notifyListeners();

    try {
      final count = await syncRepository.syncPendingOrders();
      _lastSyncedCount = count;
      if (count > 0) {
        _lastSyncMessage = '¡Se sincronizaron $count registro(s) guardado(s) offline con éxito!';
      }
      return count;
    } catch (e) {
      _lastSyncMessage = 'Error durante la sincronización: $e';
      return 0;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    connectivityNotifier.removeListener(_handleConnectivityChange);
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
