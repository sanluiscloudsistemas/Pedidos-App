import 'package:drift/drift.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/local/app_database.dart';
import '../datasources/remote/api_service.dart';

class SyncRepositoryImpl implements SyncRepository {
  final AppDatabase db;
  final ApiService apiService;

  SyncRepositoryImpl({
    required this.db,
    required this.apiService,
  });

  @override
  Future<int> saveOrderOffline({
    required int organizacionId,
    required int clienteId,
    required int vendedorId,
    required int repartoId,
    required String condicionVenta,
    required double total,
    required String fecha,
    required List<Map<String, dynamic>> items,
  }) async {
    return db.transaction(() async {
      // 1. Insertar en PedidosLocal
      final pedidoId = await db.into(db.pedidosLocal).insert(
            PedidosLocalCompanion.insert(
              organizacionId: organizacionId,
              clienteId: clienteId,
              vendedorId: vendedorId,
              repartoId: repartoId,
              condicionVenta: Value(condicionVenta),
              total: total,
              fecha: fecha,
              syncStatus: const Value('PENDING_SYNC'),
            ),
          );

      // 2. Insertar cada ítem asociado en OrderItemsLocal
      for (final item in items) {
        await db.into(db.orderItemsLocal).insert(
              OrderItemsLocalCompanion.insert(
                pedidoLocalId: pedidoId,
                productoId: (item['productoId'] as num?)?.toInt() ?? 0,
                cantidad: (item['cantidad'] as num?)?.toInt() ?? 1,
                precioUnitario: (item['precioUnitario'] as num?)?.toDouble() ?? 0.0,
                descuento: Value((item['descuento'] as num?)?.toDouble() ?? 0.0),
                precioTotal: (item['precioTotal'] as num?)?.toDouble() ?? 0.0,
              ),
            );
      }

      return pedidoId;
    });
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
    return await db.into(db.clientesLocal).insert(
      ClientesLocalCompanion.insert(
        organizacionId: organizacionId,
        vendedorId: vendedorId,
        nombre: nombre,
        razonSocial: razonSocial,
        tipoDocumento: tipoDocumento,
        numeroDocumento: numeroDocumento,
        tipoIva: tipoIva,
        telefono: Value(telefono),
        emailPrincipal: Value(emailPrincipal),
        geoposicion: Value(geoposicion),
        syncStatus: const Value('PENDING_SYNC'),
      ),
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
    return await db.into(db.faltantesLocal).insert(
      FaltantesLocalCompanion.insert(
        organizacionId: organizacionId,
        vendedorId: vendedorId,
        productoId: productoId,
        fecha: fecha,
        observacion: Value(observacion),
        syncStatus: const Value('PENDING_SYNC'),
      ),
    );
  }

  @override
  Future<List<FullLocalOrder>> getAllLocalOrders() async {
    final orders = await db.select(db.pedidosLocal).get();
    final result = <FullLocalOrder>[];

    for (final order in orders) {
      final items = await (db.select(db.orderItemsLocal)
            ..where((tbl) => tbl.pedidoLocalId.equals(order.id)))
          .get();
      result.add(FullLocalOrder(order: order, items: items));
    }

    return result;
  }

  @override
  Stream<List<FullLocalOrder>> watchAllLocalOrders() {
    return db.select(db.pedidosLocal).watch().asyncMap((orders) async {
      final result = <FullLocalOrder>[];
      for (final order in orders) {
        final items = await (db.select(db.orderItemsLocal)
              ..where((tbl) => tbl.pedidoLocalId.equals(order.id)))
            .get();
        result.add(FullLocalOrder(order: order, items: items));
      }
      return result;
    });
  }

  @override
  Future<List<FullLocalOrder>> getPendingSyncOrders() async {
    final pendingOrders = await (db.select(db.pedidosLocal)
          ..where((tbl) => tbl.syncStatus.equals('PENDING_SYNC')))
        .get();

    final result = <FullLocalOrder>[];
    for (final order in pendingOrders) {
      final items = await (db.select(db.orderItemsLocal)
            ..where((tbl) => tbl.pedidoLocalId.equals(order.id)))
          .get();
      result.add(FullLocalOrder(order: order, items: items));
    }

    return result;
  }

  @override
  Future<int> syncPendingOrders() async {
    int syncedCount = 0;

    // 1. Sincronizar Pedidos
    final pendingOrdersList = await getPendingSyncOrders();
    for (final fullOrder in pendingOrdersList) {
      try {
        final payload = {
          'pedido': {
            'organizacion_id': fullOrder.order.organizacionId,
            'cliente_id': fullOrder.order.clienteId,
            'vendedor_id': fullOrder.order.vendedorId,
            'reparto_id': fullOrder.order.repartoId,
            'fecha': fullOrder.order.fecha,
            'condicionventa': fullOrder.order.condicionVenta,
            'total': fullOrder.order.total,
          },
          'items': fullOrder.items.map((it) => {
            'producto_id': it.productoId,
            'cantidad': it.cantidad,
            'precio_unitario': it.precioUnitario,
            'descuento': it.descuento,
            'precio_total': it.precioTotal,
          }).toList(),
        };

        await apiService.postPedido(payload);

        await (db.update(db.pedidosLocal)
              ..where((tbl) => tbl.id.equals(fullOrder.order.id)))
            .write(
          const PedidosLocalCompanion(
            syncStatus: Value('SYNCED'),
            syncErrorMessage: Value(null),
          ),
        );
        syncedCount++;
      } catch (e) {
        await (db.update(db.pedidosLocal)
              ..where((tbl) => tbl.id.equals(fullOrder.order.id)))
            .write(
          PedidosLocalCompanion(
            syncStatus: const Value('SYNC_ERROR'),
            syncErrorMessage: Value(e.toString()),
          ),
        );
      }
    }

    // 2. Sincronizar Clientes
    final pendingClientes = await (db.select(db.clientesLocal)
          ..where((tbl) => tbl.syncStatus.equals('PENDING_SYNC')))
        .get();

    for (final cliente in pendingClientes) {
      try {
        final payload = {
          'organizacion_id': cliente.organizacionId,
          'vendedor_id': cliente.vendedorId,
          'nombre': cliente.nombre,
          'razon_social': cliente.razonSocial,
          'tipo_documento': cliente.tipoDocumento,
          'numero_documento': cliente.numeroDocumento,
          'tipo_iva': cliente.tipoIva,
          'telefono': cliente.telefono ?? '',
          'email_principal': cliente.emailPrincipal ?? '',
          'geoposicion': cliente.geoposicion ?? '',
        };

        await apiService.postCliente(payload);

        await (db.update(db.clientesLocal)
              ..where((tbl) => tbl.id.equals(cliente.id)))
            .write(
          const ClientesLocalCompanion(
            syncStatus: Value('SYNCED'),
            syncErrorMessage: Value(null),
          ),
        );
        syncedCount++;
      } catch (e) {
        await (db.update(db.clientesLocal)
              ..where((tbl) => tbl.id.equals(cliente.id)))
            .write(
          ClientesLocalCompanion(
            syncStatus: const Value('SYNC_ERROR'),
            syncErrorMessage: Value(e.toString()),
          ),
        );
      }
    }

    // 3. Sincronizar Faltantes
    final pendingFaltantes = await (db.select(db.faltantesLocal)
          ..where((tbl) => tbl.syncStatus.equals('PENDING_SYNC')))
        .get();

    for (final faltante in pendingFaltantes) {
      try {
        final payload = {
          'organizacion_id': faltante.organizacionId,
          'vendedor_id': faltante.vendedorId,
          'producto_id': faltante.productoId,
          'fecha': faltante.fecha,
          'observacion': faltante.observacion ?? '',
        };

        await apiService.postFaltante(payload);

        await (db.update(db.faltantesLocal)
              ..where((tbl) => tbl.id.equals(faltante.id)))
            .write(
          const FaltantesLocalCompanion(
            syncStatus: Value('SYNCED'),
            syncErrorMessage: Value(null),
          ),
        );
        syncedCount++;
      } catch (e) {
        await (db.update(db.faltantesLocal)
              ..where((tbl) => tbl.id.equals(faltante.id)))
            .write(
          FaltantesLocalCompanion(
            syncStatus: const Value('SYNC_ERROR'),
            syncErrorMessage: Value(e.toString()),
          ),
        );
      }
    }

    return syncedCount;
  }
}
