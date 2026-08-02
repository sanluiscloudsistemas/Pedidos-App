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
    required String cliente,
    required String condicionVenta,
    required String reparto,
    required double totalMonto,
    required String fechaGeneracion,
    required List<Map<String, dynamic>> items,
  }) async {
    return db.transaction(() async {
      // 1. Insertar en PedidosLocal
      final pedidoId = await db.into(db.pedidosLocal).insert(
            PedidosLocalCompanion.insert(
              cliente: cliente,
              condicionVenta: Value(condicionVenta),
              reparto: Value(reparto),
              totalMonto: totalMonto,
              fechaGeneracion: fechaGeneracion,
              syncStatus: const Value('PENDING_SYNC'),
            ),
          );

      // 2. Insertar cada ítem asociado en OrderItemsLocal
      for (final item in items) {
        await db.into(db.orderItemsLocal).insert(
              OrderItemsLocalCompanion.insert(
                pedidoLocalId: pedidoId,
                codigo: item['codigo'] as String? ?? '000',
                descripcion: item['descripcion'] as String? ?? 'Producto General',
                cantidad: (item['cantidad'] as num?)?.toInt() ?? 1,
                precioUnitario: (item['precioUnitario'] as num?)?.toDouble() ?? 0.0,
                descuento: Value((item['descuento'] as num?)?.toDouble() ?? 0.0),
                total: (item['total'] as num?)?.toDouble() ?? 0.0,
              ),
            );
      }

      return pedidoId;
    });
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
    final pendingList = await getPendingSyncOrders();
    if (pendingList.isEmpty) return 0;

    int syncedCount = 0;

    for (final fullOrder in pendingList) {
      try {
        final payload = {
          'id_local': fullOrder.order.id,
          'cliente': fullOrder.order.cliente,
          'condicion_venta': fullOrder.order.condicionVenta,
          'reparto': fullOrder.order.reparto,
          'total_monto': fullOrder.order.totalMonto,
          'fecha_generacion': fullOrder.order.fechaGeneracion,
          'items': fullOrder.items
              .map((it) => {
                    'codigo': it.codigo,
                    'descripcion': it.descripcion,
                    'cantidad': it.cantidad,
                    'precio_unitario': it.precioUnitario,
                    'descuento': it.descuento,
                    'total': it.total,
                  })
              .toList(),
        };

        // Simular o enviar HTTP POST a la API remota vía ApiService
        await apiService.post('/pedidos/sincronizar', data: payload);

        // Marcar como SYNCED en Drift SQLite
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
        // En caso de falla o error puntual en la API, registrar el mensaje en la BD
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

    return syncedCount;
  }
}
