import 'package:flutter_test/flutter_test.dart';
import 'package:preventa/presentation/screens/nuevo_pedido_wizard_screen.dart';

void main() {
  group('Pruebas unitarias de OrderItemDraft y recálculo de detalle de pedido', () {
    test('Calcula el total de una línea individual con precio, cantidad y descuento', () {
      const item = OrderItemDraft(
        codigo: 'PROD-01',
        descripcion: 'Fideos Spaghetti',
        cantidad: 3,
        precioUnitario: 1500.0,
        descuento: 200.0,
      );

      // (1500 * 3) - 200 = 4300
      expect(item.total, equals(4300.0));
    });

    test('Permite editar código, cantidad y precio con copyWith recalculando el total', () {
      const original = OrderItemDraft(
        codigo: 'PROD-01',
        descripcion: 'Fideos Spaghetti',
        cantidad: 2,
        precioUnitario: 1000.0,
        descuento: 0.0,
      );
      expect(original.total, equals(2000.0));

      final modificado = original.copyWith(
        codigo: 'PROD-99',
        descripcion: 'Arroz Extra',
        cantidad: 5,
        precioUnitario: 1200.0,
      );

      expect(modificado.codigo, equals('PROD-99'));
      expect(modificado.descripcion, equals('Arroz Extra'));
      expect(modificado.cantidad, equals(5));
      expect(modificado.precioUnitario, equals(1200.0));
      // (1200 * 5) - 0 = 6000
      expect(modificado.total, equals(6000.0));
    });

    test('Recálculo de total acumulado tras editar una línea existente en la lista', () {
      final items = <OrderItemDraft>[
        const OrderItemDraft(
          codigo: 'A1',
          descripcion: 'Producto A1',
          cantidad: 2,
          precioUnitario: 500.0,
        ), // 1000.0
        const OrderItemDraft(
          codigo: 'B2',
          descripcion: 'Producto B2',
          cantidad: 1,
          precioUnitario: 2500.0,
        ), // 2500.0
      ];

      double totalInicial = items.fold(0.0, (sum, it) => sum + it.total);
      expect(totalInicial, equals(3500.0));

      // Edición de la primera línea: cambio de código a A9 y cantidad de 2 a 4
      items[0] = items[0].copyWith(
        codigo: 'A9',
        cantidad: 4,
      );

      double totalTrasEdicion = items.fold(0.0, (sum, it) => sum + it.total);
      // (500 * 4) + 2500 = 4500.0
      expect(totalTrasEdicion, equals(4500.0));
      expect(items[0].codigo, equals('A9'));
      expect(items[0].cantidad, equals(4));
    });

    test('Recálculo de total acumulado tras eliminar una línea del detalle', () {
      final items = <OrderItemDraft>[
        const OrderItemDraft(
          codigo: 'LINE-1',
          descripcion: 'Galletitas',
          cantidad: 2,
          precioUnitario: 800.0,
        ), // 1600.0
        const OrderItemDraft(
          codigo: 'LINE-2',
          descripcion: 'Gaseosa',
          cantidad: 3,
          precioUnitario: 1200.0,
        ), // 3600.0
        const OrderItemDraft(
          codigo: 'LINE-3',
          descripcion: 'Aceite',
          cantidad: 1,
          precioUnitario: 2000.0,
        ), // 2000.0
      ];

      double totalInicial = items.fold(0.0, (sum, it) => sum + it.total);
      expect(totalInicial, equals(7200.0));

      // Eliminación de la línea 1 (índice 1: Gaseosa)
      items.removeAt(1);

      double totalTrasEliminar = items.fold(0.0, (sum, it) => sum + it.total);
      // 1600.0 + 2000.0 = 3600.0
      expect(items.length, equals(2));
      expect(totalTrasEliminar, equals(3600.0));
      expect(items.any((it) => it.codigo == 'LINE-2'), isFalse);
    });
  });
}
