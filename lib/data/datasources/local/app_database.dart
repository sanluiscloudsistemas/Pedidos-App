import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get descripcion => text().nullable()();
  RealColumn get precio => real()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Productos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = p.join(dbFolder.path, 'db.sqlite');
    return NativeDatabase.createInBackground(File(file));
  });
}
