// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
      
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );

  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );

  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    precio,
    stock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto( 
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  const Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['precio'] = Variable<double>(precio);
    map['stock'] = Variable<int>(stock);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      precio: Value(precio),
      stock: Value(stock),
    );
  }

  // acá Productos

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      precio: serializer.fromJson<double>(json['precio']),
      stock: serializer.fromJson<int>(json['stock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'precio': serializer.toJson<double>(precio),
      'stock': serializer.toJson<int>(stock),
    };
  }

  Producto copyWith({
    int? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    double? precio,
    int? stock,
  }) => Producto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    precio: precio ?? this.precio,
    stock: stock ?? this.stock,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      precio: data.precio.present ? data.precio.value : this.precio,
      stock: data.stock.present ? data.stock.value : this.stock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('stock: $stock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, descripcion, precio, stock);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.precio == this.precio &&
          other.stock == this.stock);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<double> precio;
  final Value<int> stock;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.stock = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    required double precio,
    this.stock = const Value.absent(),
  }) : nombre = Value(nombre),
       precio = Value(precio);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<double>? precio,
    Expression<int>? stock,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (precio != null) 'precio': precio,
      if (stock != null) 'stock': stock,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<double>? precio,
    Value<int>? stock,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('stock: $stock')
          ..write(')'))
        .toString();
  }
}

class $PedidosLocalTable extends PedidosLocal
    with TableInfo<$PedidosLocalTable, PedidosLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PedidosLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteMeta = const VerificationMeta(
    'cliente',
  );
  @override
  late final GeneratedColumn<String> cliente = GeneratedColumn<String>(
    'cliente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _condicionVentaMeta = const VerificationMeta(
    'condicionVenta',
  );
  @override
  late final GeneratedColumn<String> condicionVenta = GeneratedColumn<String>(
    'condicion_venta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CONTADO'),
  );
  static const VerificationMeta _repartoMeta = const VerificationMeta(
    'reparto',
  );
  @override
  late final GeneratedColumn<String> reparto = GeneratedColumn<String>(
    'reparto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('GENERAL'),
  );
  static const VerificationMeta _totalMontoMeta = const VerificationMeta(
    'totalMonto',
  );
  @override
  late final GeneratedColumn<double> totalMonto = GeneratedColumn<double>(
    'total_monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaGeneracionMeta = const VerificationMeta(
    'fechaGeneracion',
  );
  @override
  late final GeneratedColumn<String> fechaGeneracion = GeneratedColumn<String>(
    'fecha_generacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING_SYNC'),
  );
  static const VerificationMeta _syncErrorMessageMeta = const VerificationMeta(
    'syncErrorMessage',
  );
  @override
  late final GeneratedColumn<String> syncErrorMessage = GeneratedColumn<String>(
    'sync_error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cliente,
    condicionVenta,
    reparto,
    totalMonto,
    fechaGeneracion,
    syncStatus,
    syncErrorMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pedidos_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<PedidosLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente')) {
      context.handle(
        _clienteMeta,
        cliente.isAcceptableOrUnknown(data['cliente']!, _clienteMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteMeta);
    }
    if (data.containsKey('condicion_venta')) {
      context.handle(
        _condicionVentaMeta,
        condicionVenta.isAcceptableOrUnknown(
          data['condicion_venta']!,
          _condicionVentaMeta,
        ),
      );
    }
    if (data.containsKey('reparto')) {
      context.handle(
        _repartoMeta,
        reparto.isAcceptableOrUnknown(data['reparto']!, _repartoMeta),
      );
    }
    if (data.containsKey('total_monto')) {
      context.handle(
        _totalMontoMeta,
        totalMonto.isAcceptableOrUnknown(data['total_monto']!, _totalMontoMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMontoMeta);
    }
    if (data.containsKey('fecha_generacion')) {
      context.handle(
        _fechaGeneracionMeta,
        fechaGeneracion.isAcceptableOrUnknown(
          data['fecha_generacion']!,
          _fechaGeneracionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaGeneracionMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error_message')) {
      context.handle(
        _syncErrorMessageMeta,
        syncErrorMessage.isAcceptableOrUnknown(
          data['sync_error_message']!,
          _syncErrorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PedidosLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PedidosLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente'],
      )!,
      condicionVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condicion_venta'],
      )!,
      reparto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reparto'],
      )!,
      totalMonto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_monto'],
      )!,
      fechaGeneracion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_generacion'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncErrorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PedidosLocalTable createAlias(String alias) {
    return $PedidosLocalTable(attachedDatabase, alias);
  }
}

class PedidosLocalData extends DataClass
    implements Insertable<PedidosLocalData> {
  final int id;
  final String cliente;
  final String condicionVenta;
  final String reparto;
  final double totalMonto;
  final String fechaGeneracion;
  final String syncStatus;
  final String? syncErrorMessage;
  final DateTime createdAt;
  const PedidosLocalData({
    required this.id,
    required this.cliente,
    required this.condicionVenta,
    required this.reparto,
    required this.totalMonto,
    required this.fechaGeneracion,
    required this.syncStatus,
    this.syncErrorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente'] = Variable<String>(cliente);
    map['condicion_venta'] = Variable<String>(condicionVenta);
    map['reparto'] = Variable<String>(reparto);
    map['total_monto'] = Variable<double>(totalMonto);
    map['fecha_generacion'] = Variable<String>(fechaGeneracion);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncErrorMessage != null) {
      map['sync_error_message'] = Variable<String>(syncErrorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PedidosLocalCompanion toCompanion(bool nullToAbsent) {
    return PedidosLocalCompanion(
      id: Value(id),
      cliente: Value(cliente),
      condicionVenta: Value(condicionVenta),
      reparto: Value(reparto),
      totalMonto: Value(totalMonto),
      fechaGeneracion: Value(fechaGeneracion),
      syncStatus: Value(syncStatus),
      syncErrorMessage: syncErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(syncErrorMessage),
      createdAt: Value(createdAt),
    );
  }


  // Acá Pedidos
  factory PedidosLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PedidosLocalData(
      id: serializer.fromJson<int>(json['id']),
      cliente: serializer.fromJson<String>(json['cliente']),
      condicionVenta: serializer.fromJson<String>(json['condicionVenta']),
      reparto: serializer.fromJson<String>(json['reparto']),
      totalMonto: serializer.fromJson<double>(json['totalMonto']),
      fechaGeneracion: serializer.fromJson<String>(json['fechaGeneracion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncErrorMessage: serializer.fromJson<String?>(json['syncErrorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cliente': serializer.toJson<String>(cliente),
      'condicionVenta': serializer.toJson<String>(condicionVenta),
      'reparto': serializer.toJson<String>(reparto),
      'totalMonto': serializer.toJson<double>(totalMonto),
      'fechaGeneracion': serializer.toJson<String>(fechaGeneracion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncErrorMessage': serializer.toJson<String?>(syncErrorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PedidosLocalData copyWith({
    int? id,
    String? cliente,
    String? condicionVenta,
    String? reparto,
    double? totalMonto,
    String? fechaGeneracion,
    String? syncStatus,
    Value<String?> syncErrorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => PedidosLocalData(
    id: id ?? this.id,
    cliente: cliente ?? this.cliente,
    condicionVenta: condicionVenta ?? this.condicionVenta,
    reparto: reparto ?? this.reparto,
    totalMonto: totalMonto ?? this.totalMonto,
    fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
    syncStatus: syncStatus ?? this.syncStatus,
    syncErrorMessage: syncErrorMessage.present
        ? syncErrorMessage.value
        : this.syncErrorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  PedidosLocalData copyWithCompanion(PedidosLocalCompanion data) {
    return PedidosLocalData(
      id: data.id.present ? data.id.value : this.id,
      cliente: data.cliente.present ? data.cliente.value : this.cliente,
      condicionVenta: data.condicionVenta.present
          ? data.condicionVenta.value
          : this.condicionVenta,
      reparto: data.reparto.present ? data.reparto.value : this.reparto,
      totalMonto: data.totalMonto.present
          ? data.totalMonto.value
          : this.totalMonto,
      fechaGeneracion: data.fechaGeneracion.present
          ? data.fechaGeneracion.value
          : this.fechaGeneracion,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncErrorMessage: data.syncErrorMessage.present
          ? data.syncErrorMessage.value
          : this.syncErrorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PedidosLocalData(')
          ..write('id: $id, ')
          ..write('cliente: $cliente, ')
          ..write('condicionVenta: $condicionVenta, ')
          ..write('reparto: $reparto, ')
          ..write('totalMonto: $totalMonto, ')
          ..write('fechaGeneracion: $fechaGeneracion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cliente,
    condicionVenta,
    reparto,
    totalMonto,
    fechaGeneracion,
    syncStatus,
    syncErrorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PedidosLocalData &&
          other.id == this.id &&
          other.cliente == this.cliente &&
          other.condicionVenta == this.condicionVenta &&
          other.reparto == this.reparto &&
          other.totalMonto == this.totalMonto &&
          other.fechaGeneracion == this.fechaGeneracion &&
          other.syncStatus == this.syncStatus &&
          other.syncErrorMessage == this.syncErrorMessage &&
          other.createdAt == this.createdAt);
}

class PedidosLocalCompanion extends UpdateCompanion<PedidosLocalData> {
  final Value<int> id;
  final Value<String> cliente;
  final Value<String> condicionVenta;
  final Value<String> reparto;
  final Value<double> totalMonto;
  final Value<String> fechaGeneracion;
  final Value<String> syncStatus;
  final Value<String?> syncErrorMessage;
  final Value<DateTime> createdAt;
  const PedidosLocalCompanion({
    this.id = const Value.absent(),
    this.cliente = const Value.absent(),
    this.condicionVenta = const Value.absent(),
    this.reparto = const Value.absent(),
    this.totalMonto = const Value.absent(),
    this.fechaGeneracion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PedidosLocalCompanion.insert({
    this.id = const Value.absent(),
    required String cliente,
    this.condicionVenta = const Value.absent(),
    this.reparto = const Value.absent(),
    required double totalMonto,
    required String fechaGeneracion,
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cliente = Value(cliente),
       totalMonto = Value(totalMonto),
       fechaGeneracion = Value(fechaGeneracion);
  static Insertable<PedidosLocalData> custom({
    Expression<int>? id,
    Expression<String>? cliente,
    Expression<String>? condicionVenta,
    Expression<String>? reparto,
    Expression<double>? totalMonto,
    Expression<String>? fechaGeneracion,
    Expression<String>? syncStatus,
    Expression<String>? syncErrorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cliente != null) 'cliente': cliente,
      if (condicionVenta != null) 'condicion_venta': condicionVenta,
      if (reparto != null) 'reparto': reparto,
      if (totalMonto != null) 'total_monto': totalMonto,
      if (fechaGeneracion != null) 'fecha_generacion': fechaGeneracion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncErrorMessage != null) 'sync_error_message': syncErrorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PedidosLocalCompanion copyWith({
    Value<int>? id,
    Value<String>? cliente,
    Value<String>? condicionVenta,
    Value<String>? reparto,
    Value<double>? totalMonto,
    Value<String>? fechaGeneracion,
    Value<String>? syncStatus,
    Value<String?>? syncErrorMessage,
    Value<DateTime>? createdAt,
  }) {
    return PedidosLocalCompanion(
      id: id ?? this.id,
      cliente: cliente ?? this.cliente,
      condicionVenta: condicionVenta ?? this.condicionVenta,
      reparto: reparto ?? this.reparto,
      totalMonto: totalMonto ?? this.totalMonto,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      syncStatus: syncStatus ?? this.syncStatus,
      syncErrorMessage: syncErrorMessage ?? this.syncErrorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cliente.present) {
      map['cliente'] = Variable<String>(cliente.value);
    }
    if (condicionVenta.present) {
      map['condicion_venta'] = Variable<String>(condicionVenta.value);
    }
    if (reparto.present) {
      map['reparto'] = Variable<String>(reparto.value);
    }
    if (totalMonto.present) {
      map['total_monto'] = Variable<double>(totalMonto.value);
    }
    if (fechaGeneracion.present) {
      map['fecha_generacion'] = Variable<String>(fechaGeneracion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncErrorMessage.present) {
      map['sync_error_message'] = Variable<String>(syncErrorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PedidosLocalCompanion(')
          ..write('id: $id, ')
          ..write('cliente: $cliente, ')
          ..write('condicionVenta: $condicionVenta, ')
          ..write('reparto: $reparto, ')
          ..write('totalMonto: $totalMonto, ')
          ..write('fechaGeneracion: $fechaGeneracion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsLocalTable extends OrderItemsLocal
    with TableInfo<$OrderItemsLocalTable, OrderItemsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pedidoLocalIdMeta = const VerificationMeta(
    'pedidoLocalId',
  );
  @override
  late final GeneratedColumn<int> pedidoLocalId = GeneratedColumn<int>(
    'pedido_local_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pedidos_local (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descuentoMeta = const VerificationMeta(
    'descuento',
  );
  @override
  late final GeneratedColumn<double> descuento = GeneratedColumn<double>(
    'descuento',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pedidoLocalId,
    codigo,
    descripcion,
    cantidad,
    precioUnitario,
    descuento,
    total,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pedido_local_id')) {
      context.handle(
        _pedidoLocalIdMeta,
        pedidoLocalId.isAcceptableOrUnknown(
          data['pedido_local_id']!,
          _pedidoLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pedidoLocalIdMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('descuento')) {
      context.handle(
        _descuentoMeta,
        descuento.isAcceptableOrUnknown(data['descuento']!, _descuentoMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pedidoLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pedido_local_id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      descuento: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}descuento'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
    );
  }

  @override
  $OrderItemsLocalTable createAlias(String alias) {
    return $OrderItemsLocalTable(attachedDatabase, alias);
  }
}

class OrderItemsLocalData extends DataClass
    implements Insertable<OrderItemsLocalData> {
  final int id;
  final int pedidoLocalId;
  final String codigo;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double total;
  const OrderItemsLocalData({
    required this.id,
    required this.pedidoLocalId,
    required this.codigo,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.descuento,
    required this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pedido_local_id'] = Variable<int>(pedidoLocalId);
    map['codigo'] = Variable<String>(codigo);
    map['descripcion'] = Variable<String>(descripcion);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['descuento'] = Variable<double>(descuento);
    map['total'] = Variable<double>(total);
    return map;
  }

  OrderItemsLocalCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsLocalCompanion(
      id: Value(id),
      pedidoLocalId: Value(pedidoLocalId),
      codigo: Value(codigo),
      descripcion: Value(descripcion),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      descuento: Value(descuento),
      total: Value(total),
    );
  }

  factory OrderItemsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsLocalData(
      id: serializer.fromJson<int>(json['id']),
      pedidoLocalId: serializer.fromJson<int>(json['pedidoLocalId']),
      codigo: serializer.fromJson<String>(json['codigo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      descuento: serializer.fromJson<double>(json['descuento']),
      total: serializer.fromJson<double>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pedidoLocalId': serializer.toJson<int>(pedidoLocalId),
      'codigo': serializer.toJson<String>(codigo),
      'descripcion': serializer.toJson<String>(descripcion),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'descuento': serializer.toJson<double>(descuento),
      'total': serializer.toJson<double>(total),
    };
  }

  OrderItemsLocalData copyWith({
    int? id,
    int? pedidoLocalId,
    String? codigo,
    String? descripcion,
    int? cantidad,
    double? precioUnitario,
    double? descuento,
    double? total,
  }) => OrderItemsLocalData(
    id: id ?? this.id,
    pedidoLocalId: pedidoLocalId ?? this.pedidoLocalId,
    codigo: codigo ?? this.codigo,
    descripcion: descripcion ?? this.descripcion,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    descuento: descuento ?? this.descuento,
    total: total ?? this.total,
  );
  OrderItemsLocalData copyWithCompanion(OrderItemsLocalCompanion data) {
    return OrderItemsLocalData(
      id: data.id.present ? data.id.value : this.id,
      pedidoLocalId: data.pedidoLocalId.present
          ? data.pedidoLocalId.value
          : this.pedidoLocalId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      descuento: data.descuento.present ? data.descuento.value : this.descuento,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsLocalData(')
          ..write('id: $id, ')
          ..write('pedidoLocalId: $pedidoLocalId, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('descuento: $descuento, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pedidoLocalId,
    codigo,
    descripcion,
    cantidad,
    precioUnitario,
    descuento,
    total,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsLocalData &&
          other.id == this.id &&
          other.pedidoLocalId == this.pedidoLocalId &&
          other.codigo == this.codigo &&
          other.descripcion == this.descripcion &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.descuento == this.descuento &&
          other.total == this.total);
}

class OrderItemsLocalCompanion extends UpdateCompanion<OrderItemsLocalData> {
  final Value<int> id;
  final Value<int> pedidoLocalId;
  final Value<String> codigo;
  final Value<String> descripcion;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> descuento;
  final Value<double> total;
  const OrderItemsLocalCompanion({
    this.id = const Value.absent(),
    this.pedidoLocalId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.descuento = const Value.absent(),
    this.total = const Value.absent(),
  });
  OrderItemsLocalCompanion.insert({
    this.id = const Value.absent(),
    required int pedidoLocalId,
    required String codigo,
    required String descripcion,
    required int cantidad,
    required double precioUnitario,
    this.descuento = const Value.absent(),
    required double total,
  }) : pedidoLocalId = Value(pedidoLocalId),
       codigo = Value(codigo),
       descripcion = Value(descripcion),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario),
       total = Value(total);
  static Insertable<OrderItemsLocalData> custom({
    Expression<int>? id,
    Expression<int>? pedidoLocalId,
    Expression<String>? codigo,
    Expression<String>? descripcion,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? descuento,
    Expression<double>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pedidoLocalId != null) 'pedido_local_id': pedidoLocalId,
      if (codigo != null) 'codigo': codigo,
      if (descripcion != null) 'descripcion': descripcion,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (descuento != null) 'descuento': descuento,
      if (total != null) 'total': total,
    });
  }

  OrderItemsLocalCompanion copyWith({
    Value<int>? id,
    Value<int>? pedidoLocalId,
    Value<String>? codigo,
    Value<String>? descripcion,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? descuento,
    Value<double>? total,
  }) {
    return OrderItemsLocalCompanion(
      id: id ?? this.id,
      pedidoLocalId: pedidoLocalId ?? this.pedidoLocalId,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      descuento: descuento ?? this.descuento,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pedidoLocalId.present) {
      map['pedido_local_id'] = Variable<int>(pedidoLocalId.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (descuento.present) {
      map['descuento'] = Variable<double>(descuento.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsLocalCompanion(')
          ..write('id: $id, ')
          ..write('pedidoLocalId: $pedidoLocalId, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('descuento: $descuento, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $PedidosLocalTable pedidosLocal = $PedidosLocalTable(this);
  late final $OrderItemsLocalTable orderItemsLocal = $OrderItemsLocalTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productos,
    pedidosLocal,
    orderItemsLocal,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pedidos_local',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_items_local', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> descripcion,
      required double precio,
      Value<int> stock,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<double> precio,
      Value<int> stock,
    });

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
          Producto,
          PrefetchHooks Function()
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<int> stock = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                stock: stock,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required double precio,
                Value<int> stock = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                stock: stock,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
      Producto,
      PrefetchHooks Function()
    >;
typedef $$PedidosLocalTableCreateCompanionBuilder =
    PedidosLocalCompanion Function({
      Value<int> id,
      required String cliente,
      Value<String> condicionVenta,
      Value<String> reparto,
      required double totalMonto,
      required String fechaGeneracion,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });
typedef $$PedidosLocalTableUpdateCompanionBuilder =
    PedidosLocalCompanion Function({
      Value<int> id,
      Value<String> cliente,
      Value<String> condicionVenta,
      Value<String> reparto,
      Value<double> totalMonto,
      Value<String> fechaGeneracion,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });

final class $$PedidosLocalTableReferences
    extends
        BaseReferences<_$AppDatabase, $PedidosLocalTable, PedidosLocalData> {
  $$PedidosLocalTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsLocalTable, List<OrderItemsLocalData>>
  _orderItemsLocalRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItemsLocal,
    aliasName: $_aliasNameGenerator(
      db.pedidosLocal.id,
      db.orderItemsLocal.pedidoLocalId,
    ),
  );

  $$OrderItemsLocalTableProcessedTableManager get orderItemsLocalRefs {
    final manager = $$OrderItemsLocalTableTableManager(
      $_db,
      $_db.orderItemsLocal,
    ).filter((f) => f.pedidoLocalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemsLocalRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PedidosLocalTableFilterComposer
    extends Composer<_$AppDatabase, $PedidosLocalTable> {
  $$PedidosLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cliente => $composableBuilder(
    column: $table.cliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condicionVenta => $composableBuilder(
    column: $table.condicionVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reparto => $composableBuilder(
    column: $table.reparto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalMonto => $composableBuilder(
    column: $table.totalMonto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaGeneracion => $composableBuilder(
    column: $table.fechaGeneracion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncErrorMessage => $composableBuilder(
    column: $table.syncErrorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderItemsLocalRefs(
    Expression<bool> Function($$OrderItemsLocalTableFilterComposer f) f,
  ) {
    final $$OrderItemsLocalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsLocal,
      getReferencedColumn: (t) => t.pedidoLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsLocalTableFilterComposer(
            $db: $db,
            $table: $db.orderItemsLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PedidosLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $PedidosLocalTable> {
  $$PedidosLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cliente => $composableBuilder(
    column: $table.cliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condicionVenta => $composableBuilder(
    column: $table.condicionVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reparto => $composableBuilder(
    column: $table.reparto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalMonto => $composableBuilder(
    column: $table.totalMonto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaGeneracion => $composableBuilder(
    column: $table.fechaGeneracion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncErrorMessage => $composableBuilder(
    column: $table.syncErrorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PedidosLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $PedidosLocalTable> {
  $$PedidosLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cliente =>
      $composableBuilder(column: $table.cliente, builder: (column) => column);

  GeneratedColumn<String> get condicionVenta => $composableBuilder(
    column: $table.condicionVenta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reparto =>
      $composableBuilder(column: $table.reparto, builder: (column) => column);

  GeneratedColumn<double> get totalMonto => $composableBuilder(
    column: $table.totalMonto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fechaGeneracion => $composableBuilder(
    column: $table.fechaGeneracion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncErrorMessage => $composableBuilder(
    column: $table.syncErrorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> orderItemsLocalRefs<T extends Object>(
    Expression<T> Function($$OrderItemsLocalTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsLocalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsLocal,
      getReferencedColumn: (t) => t.pedidoLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsLocalTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemsLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PedidosLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PedidosLocalTable,
          PedidosLocalData,
          $$PedidosLocalTableFilterComposer,
          $$PedidosLocalTableOrderingComposer,
          $$PedidosLocalTableAnnotationComposer,
          $$PedidosLocalTableCreateCompanionBuilder,
          $$PedidosLocalTableUpdateCompanionBuilder,
          (PedidosLocalData, $$PedidosLocalTableReferences),
          PedidosLocalData,
          PrefetchHooks Function({bool orderItemsLocalRefs})
        > {
  $$PedidosLocalTableTableManager(_$AppDatabase db, $PedidosLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PedidosLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PedidosLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PedidosLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cliente = const Value.absent(),
                Value<String> condicionVenta = const Value.absent(),
                Value<String> reparto = const Value.absent(),
                Value<double> totalMonto = const Value.absent(),
                Value<String> fechaGeneracion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PedidosLocalCompanion(
                id: id,
                cliente: cliente,
                condicionVenta: condicionVenta,
                reparto: reparto,
                totalMonto: totalMonto,
                fechaGeneracion: fechaGeneracion,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cliente,
                Value<String> condicionVenta = const Value.absent(),
                Value<String> reparto = const Value.absent(),
                required double totalMonto,
                required String fechaGeneracion,
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PedidosLocalCompanion.insert(
                id: id,
                cliente: cliente,
                condicionVenta: condicionVenta,
                reparto: reparto,
                totalMonto: totalMonto,
                fechaGeneracion: fechaGeneracion,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PedidosLocalTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemsLocalRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsLocalRefs) db.orderItemsLocal,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsLocalRefs)
                    await $_getPrefetchedData<
                      PedidosLocalData,
                      $PedidosLocalTable,
                      OrderItemsLocalData
                    >(
                      currentTable: table,
                      referencedTable: $$PedidosLocalTableReferences
                          ._orderItemsLocalRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PedidosLocalTableReferences(
                            db,
                            table,
                            p0,
                          ).orderItemsLocalRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.pedidoLocalId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PedidosLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PedidosLocalTable,
      PedidosLocalData,
      $$PedidosLocalTableFilterComposer,
      $$PedidosLocalTableOrderingComposer,
      $$PedidosLocalTableAnnotationComposer,
      $$PedidosLocalTableCreateCompanionBuilder,
      $$PedidosLocalTableUpdateCompanionBuilder,
      (PedidosLocalData, $$PedidosLocalTableReferences),
      PedidosLocalData,
      PrefetchHooks Function({bool orderItemsLocalRefs})
    >;
typedef $$OrderItemsLocalTableCreateCompanionBuilder =
    OrderItemsLocalCompanion Function({
      Value<int> id,
      required int pedidoLocalId,
      required String codigo,
      required String descripcion,
      required int cantidad,
      required double precioUnitario,
      Value<double> descuento,
      required double total,
    });
typedef $$OrderItemsLocalTableUpdateCompanionBuilder =
    OrderItemsLocalCompanion Function({
      Value<int> id,
      Value<int> pedidoLocalId,
      Value<String> codigo,
      Value<String> descripcion,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> descuento,
      Value<double> total,
    });

final class $$OrderItemsLocalTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrderItemsLocalTable,
          OrderItemsLocalData
        > {
  $$OrderItemsLocalTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PedidosLocalTable _pedidoLocalIdTable(_$AppDatabase db) =>
      db.pedidosLocal.createAlias(
        $_aliasNameGenerator(
          db.orderItemsLocal.pedidoLocalId,
          db.pedidosLocal.id,
        ),
      );

  $$PedidosLocalTableProcessedTableManager get pedidoLocalId {
    final $_column = $_itemColumn<int>('pedido_local_id')!;

    final manager = $$PedidosLocalTableTableManager(
      $_db,
      $_db.pedidosLocal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pedidoLocalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsLocalTable> {
  $$OrderItemsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get descuento => $composableBuilder(
    column: $table.descuento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  $$PedidosLocalTableFilterComposer get pedidoLocalId {
    final $$PedidosLocalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoLocalId,
      referencedTable: $db.pedidosLocal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosLocalTableFilterComposer(
            $db: $db,
            $table: $db.pedidosLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsLocalTable> {
  $$OrderItemsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get descuento => $composableBuilder(
    column: $table.descuento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  $$PedidosLocalTableOrderingComposer get pedidoLocalId {
    final $$PedidosLocalTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoLocalId,
      referencedTable: $db.pedidosLocal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosLocalTableOrderingComposer(
            $db: $db,
            $table: $db.pedidosLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsLocalTable> {
  $$OrderItemsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get descuento =>
      $composableBuilder(column: $table.descuento, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  $$PedidosLocalTableAnnotationComposer get pedidoLocalId {
    final $$PedidosLocalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoLocalId,
      referencedTable: $db.pedidosLocal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosLocalTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidosLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsLocalTable,
          OrderItemsLocalData,
          $$OrderItemsLocalTableFilterComposer,
          $$OrderItemsLocalTableOrderingComposer,
          $$OrderItemsLocalTableAnnotationComposer,
          $$OrderItemsLocalTableCreateCompanionBuilder,
          $$OrderItemsLocalTableUpdateCompanionBuilder,
          (OrderItemsLocalData, $$OrderItemsLocalTableReferences),
          OrderItemsLocalData,
          PrefetchHooks Function({bool pedidoLocalId})
        > {
  $$OrderItemsLocalTableTableManager(
    _$AppDatabase db,
    $OrderItemsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pedidoLocalId = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> descuento = const Value.absent(),
                Value<double> total = const Value.absent(),
              }) => OrderItemsLocalCompanion(
                id: id,
                pedidoLocalId: pedidoLocalId,
                codigo: codigo,
                descripcion: descripcion,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                descuento: descuento,
                total: total,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pedidoLocalId,
                required String codigo,
                required String descripcion,
                required int cantidad,
                required double precioUnitario,
                Value<double> descuento = const Value.absent(),
                required double total,
              }) => OrderItemsLocalCompanion.insert(
                id: id,
                pedidoLocalId: pedidoLocalId,
                codigo: codigo,
                descripcion: descripcion,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                descuento: descuento,
                total: total,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsLocalTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pedidoLocalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pedidoLocalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pedidoLocalId,
                                referencedTable:
                                    $$OrderItemsLocalTableReferences
                                        ._pedidoLocalIdTable(db),
                                referencedColumn:
                                    $$OrderItemsLocalTableReferences
                                        ._pedidoLocalIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderItemsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsLocalTable,
      OrderItemsLocalData,
      $$OrderItemsLocalTableFilterComposer,
      $$OrderItemsLocalTableOrderingComposer,
      $$OrderItemsLocalTableAnnotationComposer,
      $$OrderItemsLocalTableCreateCompanionBuilder,
      $$OrderItemsLocalTableUpdateCompanionBuilder,
      (OrderItemsLocalData, $$OrderItemsLocalTableReferences),
      OrderItemsLocalData,
      PrefetchHooks Function({bool pedidoLocalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$PedidosLocalTableTableManager get pedidosLocal =>
      $$PedidosLocalTableTableManager(_db, _db.pedidosLocal);
  $$OrderItemsLocalTableTableManager get orderItemsLocal =>
      $$OrderItemsLocalTableTableManager(_db, _db.orderItemsLocal);
}
