import '../../core/utils/date_formatter.dart';
import '../../core/utils/retention_calculator.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/api_service.dart';

class SyncRepositoryImpl implements SyncRepository {
  final HiveService hiveService;
  final ApiService apiService;
  final bool Function()? isOnline;

  SyncRepositoryImpl({
    required this.hiveService,
    required this.apiService,
    this.isOnline,
  });

  @override
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
    bool isCreatedOnline = false,
    String estado = 'NUEVO',
    required List<Map<String, dynamic>> items,
  }) async {
    return hiveService.saveOrder(
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
      isCreatedOnline: isCreatedOnline,
      estado: estado,
      items: items,
    );
  }

  @override
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
    return hiveService.saveCliente(
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
  }

  @override
  Future<int> saveFaltanteOffline({
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    String? observacion,
  }) async {
    return hiveService.saveFaltante(
      organizacionId: organizacionId,
      vendedorId: vendedorId,
      productoId: productoId,
      fecha: fecha,
      observacion: observacion,
    );
  }

  @override
  Future<List<FullLocalOrder>> getAllLocalOrders() async {
    return hiveService.getAllOrders();
  }

  @override
  Stream<List<FullLocalOrder>> watchAllLocalOrders() {
    return hiveService.ordersStream;
  }

  @override
  Future<List<FullLocalOrder>> getPendingSyncOrders() async {
    return hiveService.getPendingOrders();
  }

  @override
  Future<int> syncPendingOrders() async {
    // Si la verificación de conectividad reporta offline (real o simulado),
    // no enviar peticiones a la API para prevenir errores de red y estados inconsistentes.
    if (isOnline != null && !isOnline!()) {
      return 0;
    }

    int syncedCount = 0;

    // 1. Sincronizar Pedidos
    final pendingOrdersList = await getPendingSyncOrders();
    for (final fullOrder in pendingOrdersList) {
      try {
        final depId = int.tryParse(apiService.sisdepId ?? '') ??
            int.tryParse(apiService.sisperId ?? '') ??
            fullOrder.order.vendedorId;
        final depositoId = int.tryParse(apiService.depositoId ?? '') ?? depId;

        final payload = {
          'pedido': {
            'organizacion_id': fullOrder.order.organizacionId,
            'cliente_id': fullOrder.order.clienteId,
            'vendedor_id': fullOrder.order.vendedorId,
            'dependencia_id': depId,
            'deposito_id': depositoId,
            'reparto_id': fullOrder.order.repartoId,
            'fecha': DateFormatter.formatOracleTimestamp(fullOrder.order.createdAt),
            'condicionventa': _mapCondicionVenta(fullOrder.order.condicionVenta),
            'total': fullOrder.order.total,
            'estado': fullOrder.order.estado.isNotEmpty ? fullOrder.order.estado : 'NUEVO',
          },
          'items': fullOrder.items.map((it) => {
            'producto_codigo': it.productoId.toString(),
            'cantidad': it.cantidad,
            'precio_unitario': it.precioUnitario,
            'descuento': it.descuento,
            'precio_total': it.precioTotal,
          }).toList(),
        };

        await apiService.postPedido(payload);

        await hiveService.updateOrderStatus(
          fullOrder.order.id,
          'SYNCED',
        );
        syncedCount++;
      } catch (e) {
        await hiveService.updateOrderStatus(
          fullOrder.order.id,
          'SYNC_ERROR',
          errorMessage: e.toString(),
        );
      }
    }

    // 2. Sincronizar Clientes
    final pendingClientes = hiveService.getPendingClientes();
    for (final cliente in pendingClientes) {
      try {
        final payload = {
          'organizacion_id': cliente['organizacionId'],
          'vendedor_id': cliente['vendedorId'],
          'nombre': cliente['nombre'],
          'razon_social': cliente['razonSocial'],
          'tipo_documento': cliente['tipoDocumento'],
          'numero_documento': cliente['numeroDocumento'],
          'tipo_iva': cliente['tipoIva'],
          'telefono': cliente['telefono'] ?? '',
          'email_principal': cliente['emailPrincipal'] ?? '',
          'geoposicion': cliente['geoposicion'] ?? '',
        };

        await apiService.postCliente(payload);

        await hiveService.updateClienteStatus(
          cliente['id'] as int,
          'SYNCED',
        );
        syncedCount++;
      } catch (e) {
        await hiveService.updateClienteStatus(
          cliente['id'] as int,
          'SYNC_ERROR',
          errorMessage: e.toString(),
        );
      }
    }

    // 3. Sincronizar Faltantes
    final pendingFaltantes = hiveService.getPendingFaltantes();
    for (final faltante in pendingFaltantes) {
      try {
        final payload = {
          'organizacion_id': faltante['organizacionId'],
          'vendedor_id': faltante['vendedorId'],
          'producto_id': faltante['productoId'],
          'fecha': faltante['fecha'],
          'observacion': faltante['observacion'] ?? '',
        };

        await apiService.postFaltante(payload);

        await hiveService.updateFaltanteStatus(
          faltante['id'] as int,
          'SYNCED',
        );
        syncedCount++;
      } catch (e) {
        await hiveService.updateFaltanteStatus(
          faltante['id'] as int,
          'SYNC_ERROR',
          errorMessage: e.toString(),
        );
      }
    }

    return syncedCount;
  }

  String _mapCondicionVenta(String condicion) {
    final upper = condicion.toUpperCase().trim();
    if (upper.contains('CONT') || upper == 'CNT') {
      return 'CNT';
    }
    if (upper.contains('CTA') || upper.contains('CTE') || upper == 'CC') {
      return 'CC';
    }
    return upper.isNotEmpty ? upper : 'CNT';
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    return hiveService.deleteOrder(orderId);
  }

  @override
  Future<int> checkAndPurgeDailySyncedOrders(String? retentionParam) async {
    final now = DateTime.now();
    final todayString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final lastPurgeDate = hiveService.getLastPurgeDate();
    if (lastPurgeDate == todayString) {
      return 0;
    }

    final cutoffDate = RetentionCalculator.calculateCutoffDate(
      from: now,
      retention: retentionParam,
    );

    final purgedCount = await hiveService.purgeSyncedOrdersBefore(cutoffDate);
    await hiveService.setLastPurgeDate(todayString);
    return purgedCount;
  }
}
