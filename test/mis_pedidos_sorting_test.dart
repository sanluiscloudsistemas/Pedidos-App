import 'package:flutter_test/flutter_test.dart';
import 'package:preventas/presentation/screens/mis_pedidos_screen.dart';

void main() {
  group('PedidoItemModel ordenamiento descendente por fecha de creación', () {
    test('Ordena correctamente pedidos con fechas en formato ISO y dd/MM/yyyy', () {
      final pedidoViejo = const PedidoItemModel(
        codigo: 'PED-001',
        cliente: 'Cliente A',
        fechaGeneracion: '2026-09-20 10:00:00',
        monto: 100.0,
        estado: 'FINALIZADO',
      );

      final pedidoIntermedio = const PedidoItemModel(
        codigo: 'PED-002',
        cliente: 'Cliente B',
        fechaGeneracion: '22/09/2026 15:30',
        monto: 250.0,
        estado: 'NUEVO',
      );

      final pedidoReciente = const PedidoItemModel(
        codigo: 'LOC-1',
        cliente: 'Cliente C',
        fechaGeneracion: '26/09/2026 12:00',
        monto: 500.0,
        estado: 'NUEVO',
        isOffline: true,
      );

      final lista = [pedidoViejo, pedidoReciente, pedidoIntermedio];
      lista.sort(PedidoItemModel.compareDesc);

      expect(lista.first.codigo, equals('LOC-1'));
      expect(lista[1].codigo, equals('PED-002'));
      expect(lista.last.codigo, equals('PED-001'));
    });

    test('Ordena pedidos según fecha_de_generacion tanto remotos como offline', () {
      final pedidoViejoRemoto = PedidoItemModel.fromJson({
        'codigo': 'PED-001',
        'cliente': 'Cliente A',
        'fecha_de_generacion': '2026-09-20 10:00:00',
        'monto': 100.0,
        'estado': 'FINALIZADO',
      });

      final pedidoIntermedioRemoto = PedidoItemModel.fromJson({
        'codigo': 'PED-002',
        'cliente': 'Cliente B',
        'fecha_de_generacion': '2026-09-24 15:30:00',
        'monto': 200.0,
        'estado': 'NUEVO',
      });

      final pedidoRecienteOffline = const PedidoItemModel(
        codigo: 'LOC-1',
        cliente: 'Cliente Offline',
        fechaGeneracion: '26 SEP 2026',
        monto: 300.0,
        estado: 'NUEVO',
        isOffline: true,
      );

      final lista = [pedidoViejoRemoto, pedidoRecienteOffline, pedidoIntermedioRemoto];
      lista.sort(PedidoItemModel.compareDesc);

      expect(lista.first.codigo, equals('LOC-1'));
      expect(lista[1].codigo, equals('PED-002'));
      expect(lista.last.codigo, equals('PED-001'));
    });

    test('Desempata por código/ID descendente cuando las fechas son iguales', () {
      final pedido1 = const PedidoItemModel(
        id: '10',
        codigo: '10',
        cliente: 'Cliente 1',
        fechaGeneracion: '26/09/2026 10:00',
        monto: 100.0,
        estado: 'NUEVO',
      );

      final pedido2 = const PedidoItemModel(
        id: '25',
        codigo: '25',
        cliente: 'Cliente 2',
        fechaGeneracion: '26/09/2026 10:00',
        monto: 100.0,
        estado: 'NUEVO',
      );

      final lista = [pedido1, pedido2];
      lista.sort(PedidoItemModel.compareDesc);

      expect(lista.first.id, equals('25'));
      expect(lista.last.id, equals('10'));
    });
  });

  group('Unificación de formato DD MON YYYY HH24:MI:SS y estándar Oracle', () {
    test('Unifica pedidos online y offline con el formato DD MON YYYY HH24:MI:SS', () {
      final pedidoRemoto = const PedidoItemModel(
        codigo: 'REM-100',
        cliente: 'Cliente Online',
        fechaGeneracion: '2026-09-26 14:30:15',
        monto: 3000.0,
        estado: 'FINALIZADO',
      );

      final pedidoOffline = const PedidoItemModel(
        codigo: 'LOC-101',
        cliente: 'Cliente Offline',
        fechaGeneracion: '26/09/2026 12:00:45',
        monto: 2500.0,
        estado: 'NUEVO',
        isOffline: true,
      );

      expect(pedidoRemoto.fechaFormateada, equals('26 SEP 2026 14:30:15'));
      expect(pedidoOffline.fechaFormateada, equals('26 SEP 2026 12:00:45'));
    });

    test('DateFormatter.formatOracleTimestamp genera YYYY-MM-DD HH24:MI:SS:THZ', () {
      final dt = DateTime(2026, 9, 26, 12, 52, 50);
      final formatted = DateFormatter.formatOracleTimestamp(dt);

      // Debe contener año-mes-día hora:minuto:segundo seguido del huso horario
      expect(formatted, startsWith('2026-09-26 12:52:50:'));
      expect(formatted.split(':').length, greaterThanOrEqualTo(4));
    });

    test('DateFormatter.formatDdMonYyyyHhMiSs genera DD MON YYYY HH24:MI:SS', () {
      final dt = DateTime(2026, 9, 26, 14, 5, 30);
      expect(DateFormatter.formatDdMonYyyyHhMiSs(dt), equals('26 SEP 2026 14:05:30'));
    });
  });
}
