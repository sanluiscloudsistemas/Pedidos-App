import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:preventa/data/datasources/local/hive_service.dart';

void main() {
  late Directory tempDir;
  late HiveService hiveService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    hiveService = HiveService();
    await hiveService.init();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('ordersStream emite los pedidos existentes inmediatamente a un nuevo suscriptor sin requerir nuevo guardado', () async {
    await hiveService.saveOrder(
      organizacionId: 1,
      clienteId: 10,
      vendedorId: 2,
      repartoId: 3,
      condicionVenta: 'CONTADO',
      total: 5000.0,
      fecha: '2026-10-17',
      items: [],
    );

    // Nuevo suscriptor escucha ordersStream DESPUÉS de haber guardado e inicializado
    final initialOrders = await hiveService.ordersStream.first;
    expect(initialOrders.length, equals(1));
    expect(initialOrders.first.order.total, equals(5000.0));
  });
}
