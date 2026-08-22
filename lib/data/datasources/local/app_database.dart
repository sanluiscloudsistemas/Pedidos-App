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
  
  IntColumn get organizacionId => integer()();
  IntColumn get clienteId => integer()();
  IntColumn get vendedorId => integer()();
  IntColumn get repartoId => integer()();

  TextColumn get condicionVenta => text().withDefault(const Constant('CONTADO'))();
  RealColumn get total => real()();
  TextColumn get fecha => text()();
  
  // Estado de sincronización: 'PENDING_SYNC', 'SYNCED', 'SYNC_ERROR'
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING_SYNC'))();
  TextColumn get syncErrorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tabla para guardar los ítems pertenecientes a un pedido local
class OrderItemsLocal extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pedidoLocalId => integer().references(PedidosLocal, #id, onDelete: KeyAction.cascade)();
  IntColumn get productoId => integer()();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
  RealColumn get descuento => real().withDefault(const Constant(0.0))();
  RealColumn get precioTotal => real()();
}

class ClientesLocal extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId => integer()();
  IntColumn get vendedorId => integer()();
  TextColumn get nombre => text()();
  TextColumn get razonSocial => text()();
  TextColumn get tipoDocumento => text()();
  TextColumn get numeroDocumento => text()();
  TextColumn get tipoIva => text()();
  TextColumn get telefono => text().nullable()();
  TextColumn get emailPrincipal => text().nullable()();
  TextColumn get geoposicion => text().nullable()();
  TextColumn get estado => text().withDefault(const Constant('ACT'))();

  TextColumn get syncStatus => text().withDefault(const Constant('PENDING_SYNC'))();
  TextColumn get syncErrorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class FaltantesLocal extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId => integer()();
  IntColumn get vendedorId => integer()();
  IntColumn get productoId => integer()();
  TextColumn get fecha => text()();
  TextColumn get observacion => text().nullable()();

  TextColumn get syncStatus => text().withDefault(const Constant('PENDING_SYNC'))();
  TextColumn get syncErrorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Productos, PedidosLocal, OrderItemsLocal, ClientesLocal, FaltantesLocal])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    return SqfliteQueryExecutor.inDatabaseFolder(path: 'db.sqlite');
  });
}
