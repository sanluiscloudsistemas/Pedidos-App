import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'sync_offline_test.dart';

void main() {
  late FakeSyncRepository syncRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    syncRepository = FakeSyncRepository();
  });

  String generateRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#\$%^&*()_+{}|:"<>?~`-=[]\\;,./\'';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  test('Agente adversarial: Inyección de datos extremos y malformados en saveOrderOffline', () async {
    // Escenario 1: Valores nulos simulados, strings vacíos y números negativos
    final orderId1 = await syncRepository.saveOrderOffline(
      organizacionId: 14,
      clienteId: -999, // ID anómalo
      vendedorId: 23,
      repartoId: 12,
      condicionVenta: '  ',
      total: -9999999.99, // Monto negativo
      fecha: '99/99/9999', // Fecha inválida
      items: [
        {
          'codigo': '',
          'descripcion': null,
          'cantidad': -5,
          'precioUnitario': double.nan,
          'descuento': double.infinity,
          'total': -0.0,
        }
      ],
    );

    expect(orderId1, isPositive);
    
    // Escenario 2: Carga masiva de items (Stress test)
    final List<Map<String, dynamic>> massiveItems = List.generate(10000, (index) => {
      'codigo': 'ITEM_$index',
      'descripcion': 'Desc $index',
      'cantidad': 1,
      'precioUnitario': 10.0,
      'descuento': 0.0,
      'total': 10.0,
    });

    final orderId2 = await syncRepository.saveOrderOffline(
      organizacionId: 14,
      clienteId: 99999, // ID anómalo de stress
      vendedorId: 23,
      repartoId: 12,
      condicionVenta: 'CONTADO',
      total: 100000.0,
      fecha: '31/07/2026',
      items: massiveItems,
    );

    expect(orderId2, greaterThan(orderId1));

    // Verificación de resiliencia del harness
    final pending = await syncRepository.getPendingSyncOrders();
    expect(pending.length, equals(2));
  });
}
