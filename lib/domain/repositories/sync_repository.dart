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
    required int organizacionId,
    required int clienteId,
    required int vendedorId,
    required int repartoId,
    required String condicionVenta,
    required double total,
    required String fecha,
    required List<Map<String, dynamic>> items,
  });

  /// Guarda un cliente nuevo localmente (con estado PENDING_SYNC)
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
  });

  /// Guarda un producto faltante localmente (con estado PENDING_SYNC)
  Future<int> saveFaltanteOffline({
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    String? observacion,
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
