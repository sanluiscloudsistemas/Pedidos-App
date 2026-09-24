import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preventa/core/utils/retention_calculator.dart';
import 'package:preventa/domain/repositories/sync_repository.dart';
import 'package:preventa/presentation/notifiers/connectivity_notifier.dart';
import 'package:preventa/presentation/notifiers/sync_notifier.dart';

/// Implementación de prueba para verificar persistencia, purga y sincronización
class MockSyncRepository implements SyncRepository {
  final List<FullLocalOrder> orders = [];
  String? lastPurgeDate;
  int syncCallCount = 0;

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
    final nextId = orders.length + 1;
    final order = LocalOrderEntity(
      id: nextId,
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

    orders.add(FullLocalOrder(order: order, items: []));
    return nextId;
  }

  void addOrderWithDate({
    required int id,
    required String syncStatus,
    required DateTime createdAt,
  }) {
    final order = LocalOrderEntity(
      id: id,
      organizacionId: 14,
      clienteId: 100 + id,
      clienteNombre: 'Cliente $id',
      vendedorId: 1,
      repartoId: 1,
      condicionVenta: 'CNT',
      total: 1000.0,
      fecha: '20/09/2026',
      syncStatus: syncStatus,
      createdAt: createdAt,
    );
    orders.add(FullLocalOrder(order: order, items: []));
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    orders.removeWhere((o) => o.order.id == orderId);
  }

  @override
  Future<int> checkAndPurgeDailySyncedOrders(String? retentionParam) async {
    final now = DateTime.now();
    final todayString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    if (lastPurgeDate == todayString) {
      return 0; // Ya ejecutada hoy
    }

    final cutoffDate = RetentionCalculator.calculateCutoffDate(
      from: now,
      retention: retentionParam,
    );

    int count = 0;
    orders.removeWhere((o) {
      if (o.order.syncStatus == 'SYNCED' && o.order.createdAt.isBefore(cutoffDate)) {
        count++;
        return true;
      }
      return false;
    });

    lastPurgeDate = todayString;
    return count;
  }

  @override
  Future<List<FullLocalOrder>> getAllLocalOrders() async => orders;

  @override
  Stream<List<FullLocalOrder>> watchAllLocalOrders() async* {
    yield orders;
  }

  @override
  Future<List<FullLocalOrder>> getPendingSyncOrders() async {
    return orders.where((o) => o.order.syncStatus == 'PENDING_SYNC').toList();
  }

  @override
  Future<int> syncPendingOrders() async {
    syncCallCount++;
    int count = 0;
    for (var i = 0; i < orders.length; i++) {
      if (orders[i].order.syncStatus == 'PENDING_SYNC') {
        orders[i] = FullLocalOrder(
          order: orders[i].order.copyWith(syncStatus: 'SYNCED'),
          items: orders[i].items,
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
  }) async => 1;

  @override
  Future<int> saveFaltanteOffline({
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    String? observacion,
  }) async => 1;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RetentionCalculator - Pruebas de Unidades de Tiempo (d, w, m, y)', () {
    final baseDate = DateTime(2026, 6, 15, 12, 0, 0);

    test('Resta de días (d)', () {
      final cutoff = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: '10d');
      expect(cutoff, equals(DateTime(2026, 6, 5, 12, 0, 0)));
    });

    test('Resta de semanas (w)', () {
      final cutoff = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: '2w');
      expect(cutoff, equals(DateTime(2026, 6, 1, 12, 0, 0)));
    });

    test('Resta de meses (m)', () {
      final cutoff = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: '3m');
      expect(cutoff, equals(DateTime(2026, 3, 15, 12, 0, 0)));
    });

    test('Resta de meses con ajuste de fin de mes (31 de marzo - 1m -> 28 de febrero)', () {
      final march31 = DateTime(2026, 3, 31, 10, 0, 0);
      final cutoff = RetentionCalculator.calculateCutoffDate(from: march31, retention: '1m');
      expect(cutoff.month, equals(2));
      expect(cutoff.day, equals(28));
    });

    test('Resta de años (y)', () {
      final cutoff = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: '1y');
      expect(cutoff, equals(DateTime(2025, 6, 15, 12, 0, 0)));
    });

    test('Resta de años con bisiesto (29 de febrero 2024 - 1y -> 28 de febrero 2023)', () {
      final leapDate = DateTime(2024, 2, 29, 12, 0, 0);
      final cutoff = RetentionCalculator.calculateCutoffDate(from: leapDate, retention: '1y');
      expect(cutoff, equals(DateTime(2023, 2, 28, 12, 0, 0)));
    });

    test('Formato nulo, vacío o inválido aplica fallback por defecto de 30 días', () {
      final cutoffNull = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: null);
      final cutoffEmpty = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: '');
      final cutoffInvalid = RetentionCalculator.calculateCutoffDate(from: baseDate, retention: '30_dias');

      final expected = baseDate.subtract(const Duration(days: 30));
      expect(cutoffNull, equals(expected));
      expect(cutoffEmpty, equals(expected));
      expect(cutoffInvalid, equals(expected));
    });
  });

  group('Purga Diaria en Primera Conexión de la Aplicación', () {
    late MockSyncRepository repository;
    late ConnectivityNotifier connectivityNotifier;

    setUp(() {
      repository = MockSyncRepository();
      connectivityNotifier = ConnectivityNotifier();
    });

    test('Elimina únicamente pedidos SYNCED expirados y conserva PENDING_SYNC y SYNCED recientes', () async {
      final now = DateTime.now();

      // 1. Pedido SYNCED expirado (hace 45 días) -> Debe eliminarse
      repository.addOrderWithDate(
        id: 1,
        syncStatus: 'SYNCED',
        createdAt: now.subtract(const Duration(days: 45)),
      );

      // 2. Pedido SYNCED reciente (hace 5 días) -> Debe conservarse
      repository.addOrderWithDate(
        id: 2,
        syncStatus: 'SYNCED',
        createdAt: now.subtract(const Duration(days: 5)),
      );

      // 3. Pedido PENDING_SYNC antiguo (hace 60 días) -> NUNCA debe eliminarse
      repository.addOrderWithDate(
        id: 3,
        syncStatus: 'PENDING_SYNC',
        createdAt: now.subtract(const Duration(days: 60)),
      );

      expect(repository.orders.length, equals(3));

      // Primera conexión del día con retención de 30 días
      final purged = await repository.checkAndPurgeDailySyncedOrders('30d');
      expect(purged, equals(1));
      expect(repository.orders.length, equals(2));

      // Verificar que quedan el ID 2 (SYNCED reciente) y el ID 3 (PENDING_SYNC)
      final remainingIds = repository.orders.map((o) => o.order.id).toList();
      expect(remainingIds, containsAll([2, 3]));
      expect(remainingIds.contains(1), isFalse);

      // Segunda conexión del mismo día -> no debe purgar nada nuevamente
      final secondPurge = await repository.checkAndPurgeDailySyncedOrders('30d');
      expect(secondPurge, equals(0));
    });

    test('SyncNotifier dispara la purga diaria al inicializarse conectado y no en desconexión', () async {
      final now = DateTime.now();
      repository.addOrderWithDate(
        id: 10,
        syncStatus: 'SYNCED',
        createdAt: now.subtract(const Duration(days: 40)),
      );

      // Asegurar que está online al inicio
      expect(connectivityNotifier.isConnected, isTrue);

      final notifier = SyncNotifier(
        syncRepository: repository,
        connectivityNotifier: connectivityNotifier,
        retentionParam: '30d',
      );

      // Dar tiempo a microtareas asíncronas de la primera conexión
      await Future.delayed(const Duration(milliseconds: 50));

      // El pedido antiguo ID 10 debió ser purgado
      expect(repository.orders.any((o) => o.order.id == 10), isFalse);

      notifier.dispose();
    });
  });

  group('Temporizador de Sincronización cada 30 Minutos', () {
    test('fakeAsync: Detona la sincronización de órdenes pendientes cada 30 minutos con red', () {
      fakeAsync((async) {
        final repository = MockSyncRepository();
        final connectivityNotifier = ConnectivityNotifier();

        // Registrar orden pendiente
        repository.addOrderWithDate(
          id: 50,
          syncStatus: 'PENDING_SYNC',
          createdAt: DateTime.now(),
        );

        final notifier = SyncNotifier(
          syncRepository: repository,
          connectivityNotifier: connectivityNotifier,
          periodicSyncInterval: const Duration(minutes: 30),
          retentionParam: '30d',
        );

        expect(repository.syncCallCount, equals(0));

        // Avanzar 15 minutos: el temporizador no debe haber detonado aún
        async.elapse(const Duration(minutes: 15));
        expect(repository.syncCallCount, equals(0));

        // Avanzar otros 15 minutos (total 30 min): debe detonarse la sincronización
        async.elapse(const Duration(minutes: 15));
        expect(repository.syncCallCount, equals(1));
        expect(repository.orders.first.order.syncStatus, equals('SYNCED'));

        // Avanzar 30 minutos más (total 60 min): segundo ciclo
        async.elapse(const Duration(minutes: 30));
        expect(repository.syncCallCount, equals(2));

        notifier.dispose();
      });
    });
  });

  group('Flujo Online Directo vs Offline en Base Local', () {
    test('En modo offline guarda localmente en PENDING_SYNC sin llamar a la API externa', () async {
      final repository = MockSyncRepository();
      final connectivityNotifier = ConnectivityNotifier();

      // Cambiar a offline
      connectivityNotifier.toggleManualSimulatedState();
      expect(connectivityNotifier.isConnected, isFalse);

      final notifier = SyncNotifier(
        syncRepository: repository,
        connectivityNotifier: connectivityNotifier,
        retentionParam: '30d',
      );

      final id = await notifier.saveOrderOffline(
        organizacionId: 14,
        clienteId: 501,
        vendedorId: 1,
        repartoId: 1,
        condicionVenta: 'CNT',
        total: 5000.0,
        fecha: '20/09/2026',
        items: [],
      );

      expect(id, equals(1));
      final pending = await repository.getPendingSyncOrders();
      expect(pending.length, equals(1));
      expect(pending.first.order.syncStatus, equals('PENDING_SYNC'));
      expect(repository.syncCallCount, equals(0)); // Cero llamadas de sincronización

      notifier.dispose();
    });

    test('En modo online el guardado sincroniza directamente y no queda pendiente', () async {
      final repository = MockSyncRepository();
      final connectivityNotifier = ConnectivityNotifier();

      expect(connectivityNotifier.isConnected, isTrue);

      final notifier = SyncNotifier(
        syncRepository: repository,
        connectivityNotifier: connectivityNotifier,
        retentionParam: '30d',
      );

      await notifier.saveOrderOffline(
        organizacionId: 14,
        clienteId: 502,
        vendedorId: 1,
        repartoId: 1,
        condicionVenta: 'CNT',
        total: 7500.0,
        fecha: '20/09/2026',
        items: [],
      );

      // Al estar online, saveOrderOffline dispara syncPendingOrdersNow()
      await Future.delayed(const Duration(milliseconds: 50));

      final pending = await repository.getPendingSyncOrders();
      expect(pending.isEmpty, isTrue);
      expect(repository.orders.first.order.syncStatus, equals('SYNCED'));
      expect(repository.syncCallCount, greaterThanOrEqualTo(1));

      notifier.dispose();
    });
  });
}
