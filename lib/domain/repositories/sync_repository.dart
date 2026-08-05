import '../../data/datasources/local/app_database.dart';

/// Modelo de datos compuesto para un Pedido local completo
class FullLocalOrder {
  final PedidosLocalData order;
  final List<OrderItemsLocalData> items;

  const FullLocalOrder({
    required this.order,
    required this.items,
  });
}

/// Contrato para el repositorio de sincronización y almacenamiento local (Offline-First)
abstract class SyncRepository {
  /// Guarda un nuevo pedido localmente en Drift SQLite (con estado PENDING_SYNC por defecto)
  Future<int> saveOrderOffline({
    required String cliente,
    required String condicionVenta,
    required String reparto,
    required double totalMonto,
    required String fechaGeneracion,
    required List<Map<String, dynamic>> items,
  });

  /// Obtiene todos los pedidos locales almacenados en Drift
  Future<List<FullLocalOrder>> getAllLocalOrders();

  /// Observa la lista completa de pedidos locales en tiempo real
  Stream<List<FullLocalOrder>> watchAllLocalOrders();

  /// Obtiene los pedidos que están pendientes de sincronizar (syncStatus == 'PENDING_SYNC')
  Future<List<FullLocalOrder>> getPendingSyncOrders();

  /// Sincroniza todos los pedidos pendientes con la API remota
  Future<int> syncPendingOrders();
}
