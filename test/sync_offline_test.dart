import 'package:flutter_test/flutter_test.dart';
import 'package:preventa/domain/repositories/sync_repository.dart';
import 'package:preventa/presentation/notifiers/connectivity_notifier.dart';
import 'package:preventa/presentation/notifiers/sync_notifier.dart';

class FakeSyncRepository implements SyncRepository {
  final List<FullLocalOrder> _orders = [];

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
    final newId = _orders.length + 1;
    final orderData = LocalOrderEntity(
      id: newId,
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
      createdAt: DateTime.now(),
    );

    _orders.add(FullLocalOrder(order: orderData, items: []));
    return newId;
  }

  @override
  Future<List<FullLocalOrder>> getAllLocalOrders() async => _orders;

  @override
  Stream<List<FullLocalOrder>> watchAllLocalOrders() async* {
    yield _orders;
  }

  @override
  Future<List<FullLocalOrder>> getPendingSyncOrders() async {
    return _orders.where((o) => o.order.syncStatus == 'PENDING_SYNC').toList();
  }

  @override
  Future<int> syncPendingOrders() async {
    int count = 0;
    for (var i = 0; i < _orders.length; i++) {
      if (_orders[i].order.syncStatus == 'PENDING_SYNC') {
        _orders[i] = FullLocalOrder(
          order: _orders[i].order.copyWith(syncStatus: 'SYNCED'),
          items: _orders[i].items,
        );
        count++;
      }
    }
    return count;
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
    return 1;
  }

  @override
  Future<int> saveFaltanteOffline({
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    String? observacion,
  }) async {
    return 1;
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    _orders.removeWhere((o) => o.order.id == orderId);
  }

  String? _lastPurgeDate;

  @override
  Future<int> checkAndPurgeDailySyncedOrders(String? retentionParam) async {
    final now = DateTime.now();
    final todayString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    if (_lastPurgeDate == todayString) return 0;

    int count = 0;
    _orders.removeWhere((o) {
      if (o.order.syncStatus == 'SYNCED') {
        count++;
        return true;
      }
      return false;
    });

    _lastPurgeDate = todayString;
    return count;
  }
}

void main() {
  late FakeSyncRepository syncRepository;
  late ConnectivityNotifier connectivityNotifier;
  late SyncNotifier syncNotifier;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    syncRepository = FakeSyncRepository();
    connectivityNotifier = ConnectivityNotifier();
    syncNotifier = SyncNotifier(
      syncRepository: syncRepository,
      connectivityNotifier: connectivityNotifier,
    );
  });

  test('Guarda un pedido offline en modo sin conexión conservando estado PENDING_SYNC', () async {
    // Simular modo offline
    connectivityNotifier.toggleManualSimulatedState();
    expect(connectivityNotifier.isConnected, isFalse);

    final orderId = await syncNotifier.saveOrderOffline(
      organizacionId: 14,
      clienteId: 999,
      vendedorId: 23,
      repartoId: 12,
      condicionVenta: 'CONTADO',
      total: 15000.0,
      fecha: '31/07/2026',
      items: [
        {
          'productoId': 101,
          'cantidad': 2,
          'precioUnitario': 7500.0,
          'descuento': 0.0,
          'precioTotal': 15000.0,
        }
      ],
    );

    expect(orderId, equals(1));
    final pending = await syncRepository.getPendingSyncOrders();
    expect(pending.length, equals(1));
    expect(pending.first.order.clienteId, equals(999));
    expect(pending.first.order.syncStatus, equals('PENDING_SYNC'));
  });

  test('Sincroniza automáticamente los pedidos pendientes al volver la conexión a Internet', () async {
    // 1. Crear en modo offline
    connectivityNotifier.toggleManualSimulatedState();
    await syncNotifier.saveOrderOffline(
      organizacionId: 14,
      clienteId: 888,
      vendedorId: 23,
      repartoId: 12,
      condicionVenta: 'CONTADO',
      total: 20000.0,
      fecha: '31/07/2026',
      items: [],
    );

    expect((await syncRepository.getPendingSyncOrders()).length, equals(1));

    // 2. Simular retorno de conexión a Internet (Offline -> Online)
    connectivityNotifier.toggleManualSimulatedState();
    expect(connectivityNotifier.isConnected, isTrue);

    // Dar tiempo a la microtarea asíncrona de sincronización
    await Future.delayed(const Duration(milliseconds: 50));

    final pending = await syncRepository.getPendingSyncOrders();
    expect(pending.isEmpty, isTrue);
  });

  test('No permite sincronizar mediante la API si el sistema está en modo offline (simulado o real)', () async {
    // 1. Simular modo offline
    connectivityNotifier.toggleManualSimulatedState();
    expect(connectivityNotifier.isConnected, isFalse);

    await syncNotifier.saveOrderOffline(
      organizacionId: 14,
      clienteId: 555,
      vendedorId: 23,
      repartoId: 10,
      condicionVenta: 'CONTADO',
      total: 5000.0,
      fecha: '26/09/2026',
      items: [],
    );

    // 2. Intentar forzar sincronización manual mientras sigue offline
    final synced = await syncNotifier.syncPendingOrdersNow();
    expect(synced, equals(0));

    // Verificar que los pedidos pendientes permanecen intactos
    final pending = await syncRepository.getPendingSyncOrders();
    expect(pending.length, equals(1));
    expect(pending.first.order.syncStatus, equals('PENDING_SYNC'));
  });

  test('Guarda en base local pedidos online como SYNCED y offline como PENDING_SYNC', () async {
    // 1. Guardar pedido online
    await syncNotifier.saveOrderOffline(
      organizacionId: 14,
      clienteId: 101,
      vendedorId: 23,
      repartoId: 1,
      condicionVenta: 'CONTADO',
      total: 15000.0,
      fecha: '26/09/2026',
      syncStatus: 'SYNCED',
      isCreatedOnline: true,
      items: [],
    );

    // 2. Guardar pedido offline
    await syncNotifier.saveOrderOffline(
      organizacionId: 14,
      clienteId: 102,
      vendedorId: 23,
      repartoId: 2,
      condicionVenta: 'CTA_CTE',
      total: 8000.0,
      fecha: '26/09/2026',
      syncStatus: 'PENDING_SYNC',
      isCreatedOnline: false,
      items: [],
    );

    final allOrders = await syncRepository.getAllLocalOrders();
    expect(allOrders.length, equals(2));

    final onlineOrder = allOrders.firstWhere((o) => o.order.clienteId == 101);
    expect(onlineOrder.order.isCreatedOnline, isTrue);
    expect(onlineOrder.order.syncStatus, equals('SYNCED'));
    expect(onlineOrder.order.estado, equals('NUEVO'));

    final offlineOrder = allOrders.firstWhere((o) => o.order.clienteId == 102);
    expect(offlineOrder.order.isCreatedOnline, isFalse);
    expect(offlineOrder.order.syncStatus, equals('PENDING_SYNC'));
    expect(offlineOrder.order.estado, equals('NUEVO'));

    // Solo el offline cuenta como pendiente de sincronizar
    final pending = await syncRepository.getPendingSyncOrders();
    expect(pending.length, equals(1));
    expect(pending.first.order.clienteId, equals(102));
    expect(syncNotifier.pendingSyncCount, equals(1));
  });
}
