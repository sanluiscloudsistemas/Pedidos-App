/// Entidad de dominio pura para un pedido local
class LocalOrderEntity {
  final int id;
  final int organizacionId;
  final int clienteId;
  final String clienteNombre;
  final int vendedorId;
  final int repartoId;
  final String repartoNombre;
  final String condicionVenta;
  final double total;
  final String fecha;
  final String syncStatus;
  final String? syncErrorMessage;
  final DateTime createdAt;

  const LocalOrderEntity({
    required this.id,
    required this.organizacionId,
    required this.clienteId,
    this.clienteNombre = '',
    required this.vendedorId,
    required this.repartoId,
    this.repartoNombre = '',
    this.condicionVenta = 'CONTADO',
    required this.total,
    required this.fecha,
    this.syncStatus = 'PENDING_SYNC',
    this.syncErrorMessage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organizacionId': organizacionId,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'vendedorId': vendedorId,
      'repartoId': repartoId,
      'repartoNombre': repartoNombre,
      'condicionVenta': condicionVenta,
      'total': total,
      'fecha': fecha,
      'syncStatus': syncStatus,
      'syncErrorMessage': syncErrorMessage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LocalOrderEntity.fromMap(Map<dynamic, dynamic> map) {
    return LocalOrderEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      organizacionId: (map['organizacionId'] as num?)?.toInt() ?? 0,
      clienteId: (map['clienteId'] as num?)?.toInt() ?? 0,
      clienteNombre: map['clienteNombre']?.toString() ?? '',
      vendedorId: (map['vendedorId'] as num?)?.toInt() ?? 0,
      repartoId: (map['repartoId'] as num?)?.toInt() ?? 0,
      repartoNombre: map['repartoNombre']?.toString() ?? '',
      condicionVenta: map['condicionVenta']?.toString() ?? 'CONTADO',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      fecha: map['fecha']?.toString() ?? '',
      syncStatus: map['syncStatus']?.toString() ?? 'PENDING_SYNC',
      syncErrorMessage: map['syncErrorMessage']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  LocalOrderEntity copyWith({
    String? syncStatus,
    String? syncErrorMessage,
  }) {
    return LocalOrderEntity(
      id: id,
      organizacionId: organizacionId,
      clienteId: clienteId,
      clienteNombre: clienteNombre,
      vendedorId: vendedorId,
      repartoId: repartoId,
      repartoNombre: repartoNombre,
      condicionVenta: condicionVenta,
      total: total,
      fecha: fecha,
      syncStatus: syncStatus ?? this.syncStatus,
      syncErrorMessage: syncErrorMessage ?? this.syncErrorMessage,
      createdAt: createdAt,
    );
  }
}

/// Entidad de dominio pura para un ítem de pedido local
class LocalOrderItemEntity {
  final int id;
  final int pedidoLocalId;
  final int productoId;
  final String productoCodigo;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double precioTotal;

  const LocalOrderItemEntity({
    required this.id,
    required this.pedidoLocalId,
    required this.productoId,
    this.productoCodigo = '',
    this.descripcion = '',
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
    required this.precioTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pedidoLocalId': pedidoLocalId,
      'productoId': productoId,
      'productoCodigo': productoCodigo,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'descuento': descuento,
      'precioTotal': precioTotal,
    };
  }

  factory LocalOrderItemEntity.fromMap(Map<dynamic, dynamic> map) {
    return LocalOrderItemEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      pedidoLocalId: (map['pedidoLocalId'] as num?)?.toInt() ?? 0,
      productoId: (map['productoId'] as num?)?.toInt() ?? 0,
      productoCodigo: map['productoCodigo']?.toString() ?? '',
      descripcion: map['descripcion']?.toString() ?? '',
      cantidad: (map['cantidad'] as num?)?.toInt() ?? 1,
      precioUnitario: (map['precioUnitario'] as num?)?.toDouble() ?? 0.0,
      descuento: (map['descuento'] as num?)?.toDouble() ?? 0.0,
      precioTotal: (map['precioTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Modelo de datos compuesto para un Pedido local completo
class FullLocalOrder {
  final LocalOrderEntity order;
  final List<LocalOrderItemEntity> items;

  const FullLocalOrder({
    required this.order,
    required this.items,
  });
}

/// Contrato para el repositorio de sincronización y almacenamiento local (Offline-First)
abstract class SyncRepository {
  /// Guarda un nuevo pedido localmente en Hive (con estado PENDING_SYNC por defecto)
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

  /// Obtiene todos los pedidos locales almacenados en Hive
  Future<List<FullLocalOrder>> getAllLocalOrders();

  /// Observa la lista completa de pedidos locales en tiempo real
  Stream<List<FullLocalOrder>> watchAllLocalOrders();

  /// Obtiene los pedidos que están pendientes de sincronizar (syncStatus == 'PENDING_SYNC')
  Future<List<FullLocalOrder>> getPendingSyncOrders();

  /// Sincroniza todos los pedidos pendientes con la API remota
  Future<int> syncPendingOrders();

  /// Elimina definitivamente un pedido por su ID de la base local
  Future<void> deleteOrder(int orderId);

  /// Ejecuta la purga diaria de pedidos SYNCED expirados si es la primera conexión del día
  Future<int> checkAndPurgeDailySyncedOrders(String? retentionParam);
}
