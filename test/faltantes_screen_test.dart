import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:preventa/core/utils/date_formatter.dart';
import 'package:preventa/data/datasources/remote/api_service.dart';
import 'package:preventa/presentation/screens/faltantes_screen.dart';

class FakeApiService implements ApiService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  String? get sisorgId => '14';

  @override
  Future<Response> getFaltantes({
    dynamic sisorgId,
    int offset = 0,
    int limit = 25,
  }) async {
    return Response(
      requestOptions: RequestOptions(path: 'mobile/faltantes'),
      statusCode: 200,
      data: {
        'items': [
          {
            'id': 3615,
            'codigo': '080',
            'producto_descripcion': 'PAN DULCE - PAN DULCE - VENEZIANA - ROSCA DE PASCUA VENEZIANA X 400 GR.',
            'observacion': 'Sin stock en depósito',
            'fecha': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
          },
          {
            'id': 28527,
            'codigo': '297',
            'producto_descripcion': 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ DORADO ARPAN X 500 GR.',
            'observacion': null,
            'fecha': DateTime.now().subtract(const Duration(days: 35)).toIso8601String(),
          },
        ],
        'hasMore': false,
        'limit': 25,
        'offset': 0,
        'count': 2,
      },
    );
  }
}

void main() {
  group('FaltanteItemModel y DateFormatter', () {
    test('DateFormatter.formatRelativeTime formatea días, semanas y meses correctamente', () {
      final now = DateTime(2026, 10, 17, 12, 0);

      final hace3Meses = now.subtract(const Duration(days: 92));
      expect(DateFormatter.formatRelativeTime(hace3Meses, now: now), equals('Hace 3 meses'));

      final hace5Semanas = now.subtract(const Duration(days: 35));
      expect(DateFormatter.formatRelativeTime(hace5Semanas, now: now), equals('Hace 5 semanas'));

      final hace2Dias = now.subtract(const Duration(days: 2));
      expect(DateFormatter.formatRelativeTime(hace2Dias, now: now), equals('Hace 2 días'));

      final ayer = now.subtract(const Duration(days: 1));
      expect(DateFormatter.formatRelativeTime(ayer, now: now), equals('Ayer'));
    });

    test('FaltanteItemModel.fromJson mapea los campos de la API de ORDS', () {
      final json = {
        'id': 3615,
        'codigo': '080',
        'producto_descripcion': 'PAN DULCE - VENEZIANA',
        'observacion': 'Falta entregar',
        'fecha': '2026-04-15T13:53:35Z',
      };

      final model = FaltanteItemModel.fromJson(json);
      expect(model.id, equals(3615));
      expect(model.codigo, equals('080'));
      expect(model.productoDescripcion, equals('PAN DULCE - VENEZIANA'));
      expect(model.observacion, equals('Falta entregar'));
      expect(model.rawFecha, isNotNull);
      expect(model.isOffline, isFalse);
    });
  });

  group('FaltantesScreen Widget Test', () {
    testWidgets('Renderiza grilla de faltantes con datos obtenidos de la API', (tester) async {
      final mockApi = FakeApiService();

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<ApiService>.value(
            value: mockApi,
            child: const FaltantesScreen(),
          ),
        ),
      );

      // Esperar carga asíncrona
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verificar AppBar y Summary
      expect(find.text('PEDIDOS'), findsOneWidget);
      expect(find.text('Mostrando 2 faltantes'), findsOneWidget);

      // Verificar encabezados de columnas
      expect(find.text('Codigo'), findsOneWidget);
      expect(find.text('Producto Descripcion '), findsOneWidget);
      expect(find.text('Observacion'), findsOneWidget);
      expect(find.text('Fecha'), findsOneWidget);

      // Verificar contenido de las filas
      expect(find.text('080'), findsOneWidget);
      expect(find.text('297'), findsOneWidget);
      expect(find.text('Sin stock en depósito'), findsOneWidget);
      expect(find.text('-'), findsOneWidget); // Observación nula se muestra como guion
    });

    testWidgets('Filtra elementos mediante el buscador', (tester) async {
      final mockApi = FakeApiService();

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<ApiService>.value(
            value: mockApi,
            child: const FaltantesScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Mostrando 2 faltantes'), findsOneWidget);

      // Escribir en el buscador 'REBOZADOR'
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'REBOZADOR');
      await tester.pump();

      // Debe quedar solo 1 fila y actualizar el contador
      expect(find.text('Mostrando 1 faltantes'), findsOneWidget);
      expect(find.text('297'), findsOneWidget);
      expect(find.text('080'), findsNothing);
    });
  });
}
