import 'package:flutter_test/flutter_test.dart';
import 'package:preventas/data/datasources/remote/api_service.dart';
import 'package:preventas/data/models/pedido_item_model.dart';
import 'package:preventas/domain/repositories/sync_repository.dart';
import 'package:preventas/presentation/notifiers/pedidos_notifier.dart';

void main() {
  group('PedidosNotifier pruebas de lógica de filtrado y combinación', () {
    late PedidosNotifier notifier;

    setUp(() {
      notifier = PedidosNotifier(apiService: ApiService());
    });

    test('Combina pedidos locales y remotos deduplicando y asignando estado comercial', () {
      final localOrders = [
        FullLocalOrder(
          order: LocalOrderEntity(
            id: 1,
            organizacionId: 14,
            clienteId: 50,
            clienteNombre: 'Cliente Local 1',
            vendedorId: 23,
            repartoId: 1,
            condicionVenta: 'CONTADO',
            total: 1200.0,
            fecha: '26 SEP 2026 10:00:00',
            syncStatus: 'PENDING_SYNC',
            isCreatedOnline: false,
            estado: 'NUEVO',
            createdAt: DateTime(2026, 9, 26, 10, 0, 0),
          ),
          items: [
            const LocalOrderItemEntity(
              id: 1,
              pedidoLocalId: 1,
              productoId: 101,
              productoCodigo: 'PROD-101',
              descripcion: 'Harina',
              cantidad: 2,
              precioUnitario: 600.0,
              precioTotal: 1200.0,
            ),
          ],
        ),
      ];

      final combined = notifier.getCombinedPedidos(localOrders);
      expect(combined.length, equals(1));
      expect(combined.first.codigo, equals('LOC-1'));
      expect(combined.first.estado, equals('NUEVO'));
      expect(combined.first.isOffline, isTrue);
      expect(combined.first.items.length, equals(1));
      expect(combined.first.items.first.codigo, equals('PROD-101'));
    });

    test('Filtra pedidos por búsqueda textual de cliente y código', () {
      final localOrders = [
        FullLocalOrder(
          order: LocalOrderEntity(
            id: 1,
            organizacionId: 14,
            clienteId: 50,
            clienteNombre: 'Panadería San Cayetano',
            vendedorId: 23,
            repartoId: 1,
            condicionVenta: 'CONTADO',
            total: 1200.0,
            fecha: '26 SEP 2026 10:00:00',
            syncStatus: 'PENDING_SYNC',
            isCreatedOnline: false,
            estado: 'NUEVO',
            createdAt: DateTime(2026, 9, 26, 10, 0, 0),
          ),
          items: [],
        ),
        FullLocalOrder(
          order: LocalOrderEntity(
            id: 2,
            organizacionId: 14,
            clienteId: 51,
            clienteNombre: 'Supermercado Central',
            vendedorId: 23,
            repartoId: 1,
            condicionVenta: 'CONTADO',
            total: 3500.0,
            fecha: '26 SEP 2026 11:00:00',
            syncStatus: 'SYNCED',
            isCreatedOnline: true,
            estado: 'NUEVO',
            createdAt: DateTime(2026, 9, 26, 11, 0, 0),
          ),
          items: [],
        ),
      ];

      notifier.setSearchQuery('Cayetano');
      final filteredByName = notifier.getFilteredPedidos(localOrders);
      expect(filteredByName.length, equals(1));
      expect(filteredByName.first.cliente, equals('Panadería San Cayetano'));

      notifier.setSearchQuery('LOC-2');
      final filteredByCode = notifier.getFilteredPedidos(localOrders);
      expect(filteredByCode.length, equals(1));
      expect(filteredByCode.first.cliente, equals('Supermercado Central'));
    });

    test('Filtra por origen offline y online', () {
      final localOrders = [
        FullLocalOrder(
          order: LocalOrderEntity(
            id: 1,
            organizacionId: 14,
            clienteId: 50,
            clienteNombre: 'Cliente Offline',
            vendedorId: 23,
            repartoId: 1,
            condicionVenta: 'CONTADO',
            total: 1000.0,
            fecha: '26 SEP 2026 10:00:00',
            syncStatus: 'PENDING_SYNC',
            isCreatedOnline: false,
            estado: 'NUEVO',
            createdAt: DateTime(2026, 9, 26, 10, 0, 0),
          ),
          items: [],
        ),
        FullLocalOrder(
          order: LocalOrderEntity(
            id: 2,
            organizacionId: 14,
            clienteId: 51,
            clienteNombre: 'Cliente Online',
            vendedorId: 23,
            repartoId: 1,
            condicionVenta: 'CONTADO',
            total: 2000.0,
            fecha: '26 SEP 2026 11:00:00',
            syncStatus: 'SYNCED',
            isCreatedOnline: true,
            estado: 'NUEVO',
            createdAt: DateTime(2026, 9, 26, 11, 0, 0),
          ),
          items: [],
        ),
      ];

      // Solo Offline
      notifier.toggleFilterSoloOffline();
      var filtered = notifier.getFilteredPedidos(localOrders);
      expect(filtered.length, equals(1));
      expect(filtered.first.isOffline, isTrue);

      // Solo Online
      notifier.toggleFilterSoloOnline();
      filtered = notifier.getFilteredPedidos(localOrders);
      expect(filtered.length, equals(1));
      expect(filtered.first.isOffline, isFalse);

      // Reset
      notifier.resetFilters();
      filtered = notifier.getFilteredPedidos(localOrders);
      expect(filtered.length, equals(2));
    });
  });
}
