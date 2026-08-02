import 'dart:async';
import 'package:flutter/material.dart';

import '../../domain/repositories/sync_repository.dart';
import 'connectivity_notifier.dart';

/// Notificador y Coordinador de Sincronización Offline-First.
/// Escucha a `ConnectivityNotifier`. Al detectar retorno a la red (`isConnected == true`),
/// sincroniza automáticamente los pedidos pendientes de Drift SQLite con la API remota.
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
    // 1. Escuchar cambios de la lista de pedidos en Drift en tiempo real
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

  /// Guarda un nuevo pedido de forma offline en Drift SQLite
  Future<int> saveOrderOffline({
    required String cliente,
    required String condicionVenta,
    required String reparto,
    required double totalMonto,
    required String fechaGeneracion,
    required List<Map<String, dynamic>> items,
  }) async {
    final id = await syncRepository.saveOrderOffline(
      cliente: cliente,
      condicionVenta: condicionVenta,
      reparto: reparto,
      totalMonto: totalMonto,
      fechaGeneracion: fechaGeneracion,
      items: items,
    );

    // Si actualmente está online, intentar sincronizar de inmediato
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
        _lastSyncMessage = '¡Se sincronizaron $count pedido(s) guardado(s) offline con éxito!';
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
