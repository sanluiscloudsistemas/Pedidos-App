import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';

part 'app_database.g.dart';

class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  //TextColumn get codigo => text().withLength(min: 1, max: 30)();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get descripcion => text().nullable()();
  RealColumn get precio => real()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
}

/// Tabla para guardar los pedidos generados localmente (modo offline / online)
class PedidosLocal extends Table {
  IntColumn get id => integer().autoIncrement()();

  //IntColumn get pedido_id => integer().withDefault(const Constant(0))();  
  //IntColumn get organizacion_id => integer().withDefault(const Constant(0))();  
  //IntColumn get vendedor_id => integer().withDefault(const Constant(0))();   
  //IntColumn get cliente_id => integer().withDefault(const Constant(0))();

  TextColumn get cliente => text()();
  TextColumn get condicionVenta => text().withDefault(const Constant('CONTADO'))();
  //IntColumn get reparto_id => integer().withDefault(const Constant(0))();
  TextColumn get reparto => text().withLength(min: 1, max: 100)();//text().withDefault(const Constant('GENERAL'))();
  RealColumn get totalMonto => real()();
  TextColumn get fechaGeneracion => text()();
  // Estado de sincronización: 'PENDING_SYNC', 'SYNCED', 'SYNC_ERROR'
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING_SYNC'))();
  TextColumn get syncErrorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tabla para guardar los ítems pertenecientes a un pedido local
class OrderItemsLocal extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pedidoLocalId => integer().references(PedidosLocal, #id, onDelete: KeyAction.cascade)();
  TextColumn get codigo => text()();
  TextColumn get descripcion => text()();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
  RealColumn get descuento => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();
}

@DriftDatabase(tables: [Productos, PedidosLocal, OrderItemsLocal])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    return SqfliteQueryExecutor.inDatabaseFolder(path: 'db.sqlite');
  });
}
