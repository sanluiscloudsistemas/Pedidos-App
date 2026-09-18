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
}
