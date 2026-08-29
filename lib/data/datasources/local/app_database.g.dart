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
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendedorIdMeta = const VerificationMeta(
    'vendedorId',
  );
  @override
  late final GeneratedColumn<int> vendedorId = GeneratedColumn<int>(
    'vendedor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repartoIdMeta = const VerificationMeta(
    'repartoId',
  );
  @override
  late final GeneratedColumn<int> repartoId = GeneratedColumn<int>(
    'reparto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
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
    organizacionId,
    clienteId,
    vendedorId,
    repartoId,
    condicionVenta,
    total,
    fecha,
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
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('vendedor_id')) {
      context.handle(
        _vendedorIdMeta,
        vendedorId.isAcceptableOrUnknown(data['vendedor_id']!, _vendedorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendedorIdMeta);
    }
    if (data.containsKey('reparto_id')) {
      context.handle(
        _repartoIdMeta,
        repartoId.isAcceptableOrUnknown(data['reparto_id']!, _repartoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repartoIdMeta);
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
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
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
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      vendedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendedor_id'],
      )!,
      repartoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reparto_id'],
      )!,
      condicionVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condicion_venta'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
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
  final int organizacionId;
  final int clienteId;
  final int vendedorId;
  final int repartoId;
  final String condicionVenta;
  final double total;
  final String fecha;
  final String syncStatus;
  final String? syncErrorMessage;
  final DateTime createdAt;
  const PedidosLocalData({
    required this.id,
    required this.organizacionId,
    required this.clienteId,
    required this.vendedorId,
    required this.repartoId,
    required this.condicionVenta,
    required this.total,
    required this.fecha,
    required this.syncStatus,
    this.syncErrorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['cliente_id'] = Variable<int>(clienteId);
    map['vendedor_id'] = Variable<int>(vendedorId);
    map['reparto_id'] = Variable<int>(repartoId);
    map['condicion_venta'] = Variable<String>(condicionVenta);
    map['total'] = Variable<double>(total);
    map['fecha'] = Variable<String>(fecha);
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
      organizacionId: Value(organizacionId),
      clienteId: Value(clienteId),
      vendedorId: Value(vendedorId),
      repartoId: Value(repartoId),
      condicionVenta: Value(condicionVenta),
      total: Value(total),
      fecha: Value(fecha),
      syncStatus: Value(syncStatus),
      syncErrorMessage: syncErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(syncErrorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory PedidosLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PedidosLocalData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      vendedorId: serializer.fromJson<int>(json['vendedorId']),
      repartoId: serializer.fromJson<int>(json['repartoId']),
      condicionVenta: serializer.fromJson<String>(json['condicionVenta']),
      total: serializer.fromJson<double>(json['total']),
      fecha: serializer.fromJson<String>(json['fecha']),
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
      'organizacionId': serializer.toJson<int>(organizacionId),
      'clienteId': serializer.toJson<int>(clienteId),
      'vendedorId': serializer.toJson<int>(vendedorId),
      'repartoId': serializer.toJson<int>(repartoId),
      'condicionVenta': serializer.toJson<String>(condicionVenta),
      'total': serializer.toJson<double>(total),
      'fecha': serializer.toJson<String>(fecha),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncErrorMessage': serializer.toJson<String?>(syncErrorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PedidosLocalData copyWith({
    int? id,
    int? organizacionId,
    int? clienteId,
    int? vendedorId,
    int? repartoId,
    String? condicionVenta,
    double? total,
    String? fecha,
    String? syncStatus,
    Value<String?> syncErrorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => PedidosLocalData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    clienteId: clienteId ?? this.clienteId,
    vendedorId: vendedorId ?? this.vendedorId,
    repartoId: repartoId ?? this.repartoId,
    condicionVenta: condicionVenta ?? this.condicionVenta,
    total: total ?? this.total,
    fecha: fecha ?? this.fecha,
    syncStatus: syncStatus ?? this.syncStatus,
    syncErrorMessage: syncErrorMessage.present
        ? syncErrorMessage.value
        : this.syncErrorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  PedidosLocalData copyWithCompanion(PedidosLocalCompanion data) {
    return PedidosLocalData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      vendedorId: data.vendedorId.present
          ? data.vendedorId.value
          : this.vendedorId,
      repartoId: data.repartoId.present ? data.repartoId.value : this.repartoId,
      condicionVenta: data.condicionVenta.present
          ? data.condicionVenta.value
          : this.condicionVenta,
      total: data.total.present ? data.total.value : this.total,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
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
          ..write('organizacionId: $organizacionId, ')
          ..write('clienteId: $clienteId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('repartoId: $repartoId, ')
          ..write('condicionVenta: $condicionVenta, ')
          ..write('total: $total, ')
          ..write('fecha: $fecha, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    clienteId,
    vendedorId,
    repartoId,
    condicionVenta,
    total,
    fecha,
    syncStatus,
    syncErrorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PedidosLocalData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.clienteId == this.clienteId &&
          other.vendedorId == this.vendedorId &&
          other.repartoId == this.repartoId &&
          other.condicionVenta == this.condicionVenta &&
          other.total == this.total &&
          other.fecha == this.fecha &&
          other.syncStatus == this.syncStatus &&
          other.syncErrorMessage == this.syncErrorMessage &&
          other.createdAt == this.createdAt);
}

class PedidosLocalCompanion extends UpdateCompanion<PedidosLocalData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<int> clienteId;
  final Value<int> vendedorId;
  final Value<int> repartoId;
  final Value<String> condicionVenta;
  final Value<double> total;
  final Value<String> fecha;
  final Value<String> syncStatus;
  final Value<String?> syncErrorMessage;
  final Value<DateTime> createdAt;
  const PedidosLocalCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.vendedorId = const Value.absent(),
    this.repartoId = const Value.absent(),
    this.condicionVenta = const Value.absent(),
    this.total = const Value.absent(),
    this.fecha = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PedidosLocalCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required int clienteId,
    required int vendedorId,
    required int repartoId,
    this.condicionVenta = const Value.absent(),
    required double total,
    required String fecha,
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : organizacionId = Value(organizacionId),
       clienteId = Value(clienteId),
       vendedorId = Value(vendedorId),
       repartoId = Value(repartoId),
       total = Value(total),
       fecha = Value(fecha);
  static Insertable<PedidosLocalData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<int>? clienteId,
    Expression<int>? vendedorId,
    Expression<int>? repartoId,
    Expression<String>? condicionVenta,
    Expression<double>? total,
    Expression<String>? fecha,
    Expression<String>? syncStatus,
    Expression<String>? syncErrorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (clienteId != null) 'cliente_id': clienteId,
      if (vendedorId != null) 'vendedor_id': vendedorId,
      if (repartoId != null) 'reparto_id': repartoId,
      if (condicionVenta != null) 'condicion_venta': condicionVenta,
      if (total != null) 'total': total,
      if (fecha != null) 'fecha': fecha,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncErrorMessage != null) 'sync_error_message': syncErrorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PedidosLocalCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<int>? clienteId,
    Value<int>? vendedorId,
    Value<int>? repartoId,
    Value<String>? condicionVenta,
    Value<double>? total,
    Value<String>? fecha,
    Value<String>? syncStatus,
    Value<String?>? syncErrorMessage,
    Value<DateTime>? createdAt,
  }) {
    return PedidosLocalCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      clienteId: clienteId ?? this.clienteId,
      vendedorId: vendedorId ?? this.vendedorId,
      repartoId: repartoId ?? this.repartoId,
      condicionVenta: condicionVenta ?? this.condicionVenta,
      total: total ?? this.total,
      fecha: fecha ?? this.fecha,
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
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (vendedorId.present) {
      map['vendedor_id'] = Variable<int>(vendedorId.value);
    }
    if (repartoId.present) {
      map['reparto_id'] = Variable<int>(repartoId.value);
    }
    if (condicionVenta.present) {
      map['condicion_venta'] = Variable<String>(condicionVenta.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
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
          ..write('organizacionId: $organizacionId, ')
          ..write('clienteId: $clienteId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('repartoId: $repartoId, ')
          ..write('condicionVenta: $condicionVenta, ')
          ..write('total: $total, ')
          ..write('fecha: $fecha, ')
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
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _precioTotalMeta = const VerificationMeta(
    'precioTotal',
  );
  @override
  late final GeneratedColumn<double> precioTotal = GeneratedColumn<double>(
    'precio_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pedidoLocalId,
    productoId,
    cantidad,
    precioUnitario,
    descuento,
    precioTotal,
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
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
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
    if (data.containsKey('precio_total')) {
      context.handle(
        _precioTotalMeta,
        precioTotal.isAcceptableOrUnknown(
          data['precio_total']!,
          _precioTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioTotalMeta);
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
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
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
      precioTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_total'],
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
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double precioTotal;
  const OrderItemsLocalData({
    required this.id,
    required this.pedidoLocalId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.descuento,
    required this.precioTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pedido_local_id'] = Variable<int>(pedidoLocalId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['descuento'] = Variable<double>(descuento);
    map['precio_total'] = Variable<double>(precioTotal);
    return map;
  }

  OrderItemsLocalCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsLocalCompanion(
      id: Value(id),
      pedidoLocalId: Value(pedidoLocalId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      descuento: Value(descuento),
      precioTotal: Value(precioTotal),
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
      productoId: serializer.fromJson<int>(json['productoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      descuento: serializer.fromJson<double>(json['descuento']),
      precioTotal: serializer.fromJson<double>(json['precioTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pedidoLocalId': serializer.toJson<int>(pedidoLocalId),
      'productoId': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'descuento': serializer.toJson<double>(descuento),
      'precioTotal': serializer.toJson<double>(precioTotal),
    };
  }

  OrderItemsLocalData copyWith({
    int? id,
    int? pedidoLocalId,
    int? productoId,
    int? cantidad,
    double? precioUnitario,
    double? descuento,
    double? precioTotal,
  }) => OrderItemsLocalData(
    id: id ?? this.id,
    pedidoLocalId: pedidoLocalId ?? this.pedidoLocalId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    descuento: descuento ?? this.descuento,
    precioTotal: precioTotal ?? this.precioTotal,
  );
  OrderItemsLocalData copyWithCompanion(OrderItemsLocalCompanion data) {
    return OrderItemsLocalData(
      id: data.id.present ? data.id.value : this.id,
      pedidoLocalId: data.pedidoLocalId.present
          ? data.pedidoLocalId.value
          : this.pedidoLocalId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      descuento: data.descuento.present ? data.descuento.value : this.descuento,
      precioTotal: data.precioTotal.present
          ? data.precioTotal.value
          : this.precioTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsLocalData(')
          ..write('id: $id, ')
          ..write('pedidoLocalId: $pedidoLocalId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('descuento: $descuento, ')
          ..write('precioTotal: $precioTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pedidoLocalId,
    productoId,
    cantidad,
    precioUnitario,
    descuento,
    precioTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsLocalData &&
          other.id == this.id &&
          other.pedidoLocalId == this.pedidoLocalId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.descuento == this.descuento &&
          other.precioTotal == this.precioTotal);
}

class OrderItemsLocalCompanion extends UpdateCompanion<OrderItemsLocalData> {
  final Value<int> id;
  final Value<int> pedidoLocalId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> descuento;
  final Value<double> precioTotal;
  const OrderItemsLocalCompanion({
    this.id = const Value.absent(),
    this.pedidoLocalId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.descuento = const Value.absent(),
    this.precioTotal = const Value.absent(),
  });
  OrderItemsLocalCompanion.insert({
    this.id = const Value.absent(),
    required int pedidoLocalId,
    required int productoId,
    required int cantidad,
    required double precioUnitario,
    this.descuento = const Value.absent(),
    required double precioTotal,
  }) : pedidoLocalId = Value(pedidoLocalId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario),
       precioTotal = Value(precioTotal);
  static Insertable<OrderItemsLocalData> custom({
    Expression<int>? id,
    Expression<int>? pedidoLocalId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? descuento,
    Expression<double>? precioTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pedidoLocalId != null) 'pedido_local_id': pedidoLocalId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (descuento != null) 'descuento': descuento,
      if (precioTotal != null) 'precio_total': precioTotal,
    });
  }

  OrderItemsLocalCompanion copyWith({
    Value<int>? id,
    Value<int>? pedidoLocalId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? descuento,
    Value<double>? precioTotal,
  }) {
    return OrderItemsLocalCompanion(
      id: id ?? this.id,
      pedidoLocalId: pedidoLocalId ?? this.pedidoLocalId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      descuento: descuento ?? this.descuento,
      precioTotal: precioTotal ?? this.precioTotal,
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
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
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
    if (precioTotal.present) {
      map['precio_total'] = Variable<double>(precioTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsLocalCompanion(')
          ..write('id: $id, ')
          ..write('pedidoLocalId: $pedidoLocalId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('descuento: $descuento, ')
          ..write('precioTotal: $precioTotal')
          ..write(')'))
        .toString();
  }
}

class $ClientesLocalTable extends ClientesLocal
    with TableInfo<$ClientesLocalTable, ClientesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendedorIdMeta = const VerificationMeta(
    'vendedorId',
  );
  @override
  late final GeneratedColumn<int> vendedorId = GeneratedColumn<int>(
    'vendedor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _razonSocialMeta = const VerificationMeta(
    'razonSocial',
  );
  @override
  late final GeneratedColumn<String> razonSocial = GeneratedColumn<String>(
    'razon_social',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoDocumentoMeta = const VerificationMeta(
    'tipoDocumento',
  );
  @override
  late final GeneratedColumn<String> tipoDocumento = GeneratedColumn<String>(
    'tipo_documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroDocumentoMeta = const VerificationMeta(
    'numeroDocumento',
  );
  @override
  late final GeneratedColumn<String> numeroDocumento = GeneratedColumn<String>(
    'numero_documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoIvaMeta = const VerificationMeta(
    'tipoIva',
  );
  @override
  late final GeneratedColumn<String> tipoIva = GeneratedColumn<String>(
    'tipo_iva',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailPrincipalMeta = const VerificationMeta(
    'emailPrincipal',
  );
  @override
  late final GeneratedColumn<String> emailPrincipal = GeneratedColumn<String>(
    'email_principal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geoposicionMeta = const VerificationMeta(
    'geoposicion',
  );
  @override
  late final GeneratedColumn<String> geoposicion = GeneratedColumn<String>(
    'geoposicion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACT'),
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
    organizacionId,
    vendedorId,
    nombre,
    razonSocial,
    tipoDocumento,
    numeroDocumento,
    tipoIva,
    telefono,
    emailPrincipal,
    geoposicion,
    estado,
    syncStatus,
    syncErrorMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('vendedor_id')) {
      context.handle(
        _vendedorIdMeta,
        vendedorId.isAcceptableOrUnknown(data['vendedor_id']!, _vendedorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendedorIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('razon_social')) {
      context.handle(
        _razonSocialMeta,
        razonSocial.isAcceptableOrUnknown(
          data['razon_social']!,
          _razonSocialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_razonSocialMeta);
    }
    if (data.containsKey('tipo_documento')) {
      context.handle(
        _tipoDocumentoMeta,
        tipoDocumento.isAcceptableOrUnknown(
          data['tipo_documento']!,
          _tipoDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoDocumentoMeta);
    }
    if (data.containsKey('numero_documento')) {
      context.handle(
        _numeroDocumentoMeta,
        numeroDocumento.isAcceptableOrUnknown(
          data['numero_documento']!,
          _numeroDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroDocumentoMeta);
    }
    if (data.containsKey('tipo_iva')) {
      context.handle(
        _tipoIvaMeta,
        tipoIva.isAcceptableOrUnknown(data['tipo_iva']!, _tipoIvaMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoIvaMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email_principal')) {
      context.handle(
        _emailPrincipalMeta,
        emailPrincipal.isAcceptableOrUnknown(
          data['email_principal']!,
          _emailPrincipalMeta,
        ),
      );
    }
    if (data.containsKey('geoposicion')) {
      context.handle(
        _geoposicionMeta,
        geoposicion.isAcceptableOrUnknown(
          data['geoposicion']!,
          _geoposicionMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
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
  ClientesLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      vendedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendedor_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      razonSocial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}razon_social'],
      )!,
      tipoDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_documento'],
      )!,
      numeroDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_documento'],
      )!,
      tipoIva: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_iva'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      emailPrincipal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_principal'],
      ),
      geoposicion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geoposicion'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
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
  $ClientesLocalTable createAlias(String alias) {
    return $ClientesLocalTable(attachedDatabase, alias);
  }
}

class ClientesLocalData extends DataClass
    implements Insertable<ClientesLocalData> {
  final int id;
  final int organizacionId;
  final int vendedorId;
  final String nombre;
  final String razonSocial;
  final String tipoDocumento;
  final String numeroDocumento;
  final String tipoIva;
  final String? telefono;
  final String? emailPrincipal;
  final String? geoposicion;
  final String estado;
  final String syncStatus;
  final String? syncErrorMessage;
  final DateTime createdAt;
  const ClientesLocalData({
    required this.id,
    required this.organizacionId,
    required this.vendedorId,
    required this.nombre,
    required this.razonSocial,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.tipoIva,
    this.telefono,
    this.emailPrincipal,
    this.geoposicion,
    required this.estado,
    required this.syncStatus,
    this.syncErrorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['vendedor_id'] = Variable<int>(vendedorId);
    map['nombre'] = Variable<String>(nombre);
    map['razon_social'] = Variable<String>(razonSocial);
    map['tipo_documento'] = Variable<String>(tipoDocumento);
    map['numero_documento'] = Variable<String>(numeroDocumento);
    map['tipo_iva'] = Variable<String>(tipoIva);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || emailPrincipal != null) {
      map['email_principal'] = Variable<String>(emailPrincipal);
    }
    if (!nullToAbsent || geoposicion != null) {
      map['geoposicion'] = Variable<String>(geoposicion);
    }
    map['estado'] = Variable<String>(estado);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncErrorMessage != null) {
      map['sync_error_message'] = Variable<String>(syncErrorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClientesLocalCompanion toCompanion(bool nullToAbsent) {
    return ClientesLocalCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      vendedorId: Value(vendedorId),
      nombre: Value(nombre),
      razonSocial: Value(razonSocial),
      tipoDocumento: Value(tipoDocumento),
      numeroDocumento: Value(numeroDocumento),
      tipoIva: Value(tipoIva),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      emailPrincipal: emailPrincipal == null && nullToAbsent
          ? const Value.absent()
          : Value(emailPrincipal),
      geoposicion: geoposicion == null && nullToAbsent
          ? const Value.absent()
          : Value(geoposicion),
      estado: Value(estado),
      syncStatus: Value(syncStatus),
      syncErrorMessage: syncErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(syncErrorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory ClientesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientesLocalData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      vendedorId: serializer.fromJson<int>(json['vendedorId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      razonSocial: serializer.fromJson<String>(json['razonSocial']),
      tipoDocumento: serializer.fromJson<String>(json['tipoDocumento']),
      numeroDocumento: serializer.fromJson<String>(json['numeroDocumento']),
      tipoIva: serializer.fromJson<String>(json['tipoIva']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      emailPrincipal: serializer.fromJson<String?>(json['emailPrincipal']),
      geoposicion: serializer.fromJson<String?>(json['geoposicion']),
      estado: serializer.fromJson<String>(json['estado']),
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
      'organizacionId': serializer.toJson<int>(organizacionId),
      'vendedorId': serializer.toJson<int>(vendedorId),
      'nombre': serializer.toJson<String>(nombre),
      'razonSocial': serializer.toJson<String>(razonSocial),
      'tipoDocumento': serializer.toJson<String>(tipoDocumento),
      'numeroDocumento': serializer.toJson<String>(numeroDocumento),
      'tipoIva': serializer.toJson<String>(tipoIva),
      'telefono': serializer.toJson<String?>(telefono),
      'emailPrincipal': serializer.toJson<String?>(emailPrincipal),
      'geoposicion': serializer.toJson<String?>(geoposicion),
      'estado': serializer.toJson<String>(estado),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncErrorMessage': serializer.toJson<String?>(syncErrorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ClientesLocalData copyWith({
    int? id,
    int? organizacionId,
    int? vendedorId,
    String? nombre,
    String? razonSocial,
    String? tipoDocumento,
    String? numeroDocumento,
    String? tipoIva,
    Value<String?> telefono = const Value.absent(),
    Value<String?> emailPrincipal = const Value.absent(),
    Value<String?> geoposicion = const Value.absent(),
    String? estado,
    String? syncStatus,
    Value<String?> syncErrorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => ClientesLocalData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    vendedorId: vendedorId ?? this.vendedorId,
    nombre: nombre ?? this.nombre,
    razonSocial: razonSocial ?? this.razonSocial,
    tipoDocumento: tipoDocumento ?? this.tipoDocumento,
    numeroDocumento: numeroDocumento ?? this.numeroDocumento,
    tipoIva: tipoIva ?? this.tipoIva,
    telefono: telefono.present ? telefono.value : this.telefono,
    emailPrincipal: emailPrincipal.present
        ? emailPrincipal.value
        : this.emailPrincipal,
    geoposicion: geoposicion.present ? geoposicion.value : this.geoposicion,
    estado: estado ?? this.estado,
    syncStatus: syncStatus ?? this.syncStatus,
    syncErrorMessage: syncErrorMessage.present
        ? syncErrorMessage.value
        : this.syncErrorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  ClientesLocalData copyWithCompanion(ClientesLocalCompanion data) {
    return ClientesLocalData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      vendedorId: data.vendedorId.present
          ? data.vendedorId.value
          : this.vendedorId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      razonSocial: data.razonSocial.present
          ? data.razonSocial.value
          : this.razonSocial,
      tipoDocumento: data.tipoDocumento.present
          ? data.tipoDocumento.value
          : this.tipoDocumento,
      numeroDocumento: data.numeroDocumento.present
          ? data.numeroDocumento.value
          : this.numeroDocumento,
      tipoIva: data.tipoIva.present ? data.tipoIva.value : this.tipoIva,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      emailPrincipal: data.emailPrincipal.present
          ? data.emailPrincipal.value
          : this.emailPrincipal,
      geoposicion: data.geoposicion.present
          ? data.geoposicion.value
          : this.geoposicion,
      estado: data.estado.present ? data.estado.value : this.estado,
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
    return (StringBuffer('ClientesLocalData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('nombre: $nombre, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('numeroDocumento: $numeroDocumento, ')
          ..write('tipoIva: $tipoIva, ')
          ..write('telefono: $telefono, ')
          ..write('emailPrincipal: $emailPrincipal, ')
          ..write('geoposicion: $geoposicion, ')
          ..write('estado: $estado, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    vendedorId,
    nombre,
    razonSocial,
    tipoDocumento,
    numeroDocumento,
    tipoIva,
    telefono,
    emailPrincipal,
    geoposicion,
    estado,
    syncStatus,
    syncErrorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientesLocalData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.vendedorId == this.vendedorId &&
          other.nombre == this.nombre &&
          other.razonSocial == this.razonSocial &&
          other.tipoDocumento == this.tipoDocumento &&
          other.numeroDocumento == this.numeroDocumento &&
          other.tipoIva == this.tipoIva &&
          other.telefono == this.telefono &&
          other.emailPrincipal == this.emailPrincipal &&
          other.geoposicion == this.geoposicion &&
          other.estado == this.estado &&
          other.syncStatus == this.syncStatus &&
          other.syncErrorMessage == this.syncErrorMessage &&
          other.createdAt == this.createdAt);
}

class ClientesLocalCompanion extends UpdateCompanion<ClientesLocalData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<int> vendedorId;
  final Value<String> nombre;
  final Value<String> razonSocial;
  final Value<String> tipoDocumento;
  final Value<String> numeroDocumento;
  final Value<String> tipoIva;
  final Value<String?> telefono;
  final Value<String?> emailPrincipal;
  final Value<String?> geoposicion;
  final Value<String> estado;
  final Value<String> syncStatus;
  final Value<String?> syncErrorMessage;
  final Value<DateTime> createdAt;
  const ClientesLocalCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.vendedorId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.razonSocial = const Value.absent(),
    this.tipoDocumento = const Value.absent(),
    this.numeroDocumento = const Value.absent(),
    this.tipoIva = const Value.absent(),
    this.telefono = const Value.absent(),
    this.emailPrincipal = const Value.absent(),
    this.geoposicion = const Value.absent(),
    this.estado = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ClientesLocalCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required int vendedorId,
    required String nombre,
    required String razonSocial,
    required String tipoDocumento,
    required String numeroDocumento,
    required String tipoIva,
    this.telefono = const Value.absent(),
    this.emailPrincipal = const Value.absent(),
    this.geoposicion = const Value.absent(),
    this.estado = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : organizacionId = Value(organizacionId),
       vendedorId = Value(vendedorId),
       nombre = Value(nombre),
       razonSocial = Value(razonSocial),
       tipoDocumento = Value(tipoDocumento),
       numeroDocumento = Value(numeroDocumento),
       tipoIva = Value(tipoIva);
  static Insertable<ClientesLocalData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<int>? vendedorId,
    Expression<String>? nombre,
    Expression<String>? razonSocial,
    Expression<String>? tipoDocumento,
    Expression<String>? numeroDocumento,
    Expression<String>? tipoIva,
    Expression<String>? telefono,
    Expression<String>? emailPrincipal,
    Expression<String>? geoposicion,
    Expression<String>? estado,
    Expression<String>? syncStatus,
    Expression<String>? syncErrorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (vendedorId != null) 'vendedor_id': vendedorId,
      if (nombre != null) 'nombre': nombre,
      if (razonSocial != null) 'razon_social': razonSocial,
      if (tipoDocumento != null) 'tipo_documento': tipoDocumento,
      if (numeroDocumento != null) 'numero_documento': numeroDocumento,
      if (tipoIva != null) 'tipo_iva': tipoIva,
      if (telefono != null) 'telefono': telefono,
      if (emailPrincipal != null) 'email_principal': emailPrincipal,
      if (geoposicion != null) 'geoposicion': geoposicion,
      if (estado != null) 'estado': estado,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncErrorMessage != null) 'sync_error_message': syncErrorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ClientesLocalCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<int>? vendedorId,
    Value<String>? nombre,
    Value<String>? razonSocial,
    Value<String>? tipoDocumento,
    Value<String>? numeroDocumento,
    Value<String>? tipoIva,
    Value<String?>? telefono,
    Value<String?>? emailPrincipal,
    Value<String?>? geoposicion,
    Value<String>? estado,
    Value<String>? syncStatus,
    Value<String?>? syncErrorMessage,
    Value<DateTime>? createdAt,
  }) {
    return ClientesLocalCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      vendedorId: vendedorId ?? this.vendedorId,
      nombre: nombre ?? this.nombre,
      razonSocial: razonSocial ?? this.razonSocial,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      tipoIva: tipoIva ?? this.tipoIva,
      telefono: telefono ?? this.telefono,
      emailPrincipal: emailPrincipal ?? this.emailPrincipal,
      geoposicion: geoposicion ?? this.geoposicion,
      estado: estado ?? this.estado,
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
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (vendedorId.present) {
      map['vendedor_id'] = Variable<int>(vendedorId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (razonSocial.present) {
      map['razon_social'] = Variable<String>(razonSocial.value);
    }
    if (tipoDocumento.present) {
      map['tipo_documento'] = Variable<String>(tipoDocumento.value);
    }
    if (numeroDocumento.present) {
      map['numero_documento'] = Variable<String>(numeroDocumento.value);
    }
    if (tipoIva.present) {
      map['tipo_iva'] = Variable<String>(tipoIva.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (emailPrincipal.present) {
      map['email_principal'] = Variable<String>(emailPrincipal.value);
    }
    if (geoposicion.present) {
      map['geoposicion'] = Variable<String>(geoposicion.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
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
    return (StringBuffer('ClientesLocalCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('nombre: $nombre, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('numeroDocumento: $numeroDocumento, ')
          ..write('tipoIva: $tipoIva, ')
          ..write('telefono: $telefono, ')
          ..write('emailPrincipal: $emailPrincipal, ')
          ..write('geoposicion: $geoposicion, ')
          ..write('estado: $estado, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FaltantesLocalTable extends FaltantesLocal
    with TableInfo<$FaltantesLocalTable, FaltantesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FaltantesLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendedorIdMeta = const VerificationMeta(
    'vendedorId',
  );
  @override
  late final GeneratedColumn<int> vendedorId = GeneratedColumn<int>(
    'vendedor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observacionMeta = const VerificationMeta(
    'observacion',
  );
  @override
  late final GeneratedColumn<String> observacion = GeneratedColumn<String>(
    'observacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    organizacionId,
    vendedorId,
    productoId,
    fecha,
    observacion,
    syncStatus,
    syncErrorMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'faltantes_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<FaltantesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('vendedor_id')) {
      context.handle(
        _vendedorIdMeta,
        vendedorId.isAcceptableOrUnknown(data['vendedor_id']!, _vendedorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendedorIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('observacion')) {
      context.handle(
        _observacionMeta,
        observacion.isAcceptableOrUnknown(
          data['observacion']!,
          _observacionMeta,
        ),
      );
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
  FaltantesLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FaltantesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      vendedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendedor_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
      observacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacion'],
      ),
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
  $FaltantesLocalTable createAlias(String alias) {
    return $FaltantesLocalTable(attachedDatabase, alias);
  }
}

class FaltantesLocalData extends DataClass
    implements Insertable<FaltantesLocalData> {
  final int id;
  final int organizacionId;
  final int vendedorId;
  final int productoId;
  final String fecha;
  final String? observacion;
  final String syncStatus;
  final String? syncErrorMessage;
  final DateTime createdAt;
  const FaltantesLocalData({
    required this.id,
    required this.organizacionId,
    required this.vendedorId,
    required this.productoId,
    required this.fecha,
    this.observacion,
    required this.syncStatus,
    this.syncErrorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['vendedor_id'] = Variable<int>(vendedorId);
    map['producto_id'] = Variable<int>(productoId);
    map['fecha'] = Variable<String>(fecha);
    if (!nullToAbsent || observacion != null) {
      map['observacion'] = Variable<String>(observacion);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncErrorMessage != null) {
      map['sync_error_message'] = Variable<String>(syncErrorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FaltantesLocalCompanion toCompanion(bool nullToAbsent) {
    return FaltantesLocalCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      vendedorId: Value(vendedorId),
      productoId: Value(productoId),
      fecha: Value(fecha),
      observacion: observacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacion),
      syncStatus: Value(syncStatus),
      syncErrorMessage: syncErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(syncErrorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory FaltantesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FaltantesLocalData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      vendedorId: serializer.fromJson<int>(json['vendedorId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      fecha: serializer.fromJson<String>(json['fecha']),
      observacion: serializer.fromJson<String?>(json['observacion']),
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
      'organizacionId': serializer.toJson<int>(organizacionId),
      'vendedorId': serializer.toJson<int>(vendedorId),
      'productoId': serializer.toJson<int>(productoId),
      'fecha': serializer.toJson<String>(fecha),
      'observacion': serializer.toJson<String?>(observacion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncErrorMessage': serializer.toJson<String?>(syncErrorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FaltantesLocalData copyWith({
    int? id,
    int? organizacionId,
    int? vendedorId,
    int? productoId,
    String? fecha,
    Value<String?> observacion = const Value.absent(),
    String? syncStatus,
    Value<String?> syncErrorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => FaltantesLocalData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    vendedorId: vendedorId ?? this.vendedorId,
    productoId: productoId ?? this.productoId,
    fecha: fecha ?? this.fecha,
    observacion: observacion.present ? observacion.value : this.observacion,
    syncStatus: syncStatus ?? this.syncStatus,
    syncErrorMessage: syncErrorMessage.present
        ? syncErrorMessage.value
        : this.syncErrorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  FaltantesLocalData copyWithCompanion(FaltantesLocalCompanion data) {
    return FaltantesLocalData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      vendedorId: data.vendedorId.present
          ? data.vendedorId.value
          : this.vendedorId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      observacion: data.observacion.present
          ? data.observacion.value
          : this.observacion,
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
    return (StringBuffer('FaltantesLocalData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('productoId: $productoId, ')
          ..write('fecha: $fecha, ')
          ..write('observacion: $observacion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    vendedorId,
    productoId,
    fecha,
    observacion,
    syncStatus,
    syncErrorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaltantesLocalData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.vendedorId == this.vendedorId &&
          other.productoId == this.productoId &&
          other.fecha == this.fecha &&
          other.observacion == this.observacion &&
          other.syncStatus == this.syncStatus &&
          other.syncErrorMessage == this.syncErrorMessage &&
          other.createdAt == this.createdAt);
}

class FaltantesLocalCompanion extends UpdateCompanion<FaltantesLocalData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<int> vendedorId;
  final Value<int> productoId;
  final Value<String> fecha;
  final Value<String?> observacion;
  final Value<String> syncStatus;
  final Value<String?> syncErrorMessage;
  final Value<DateTime> createdAt;
  const FaltantesLocalCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.vendedorId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.observacion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FaltantesLocalCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required int vendedorId,
    required int productoId,
    required String fecha,
    this.observacion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : organizacionId = Value(organizacionId),
       vendedorId = Value(vendedorId),
       productoId = Value(productoId),
       fecha = Value(fecha);
  static Insertable<FaltantesLocalData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<int>? vendedorId,
    Expression<int>? productoId,
    Expression<String>? fecha,
    Expression<String>? observacion,
    Expression<String>? syncStatus,
    Expression<String>? syncErrorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (vendedorId != null) 'vendedor_id': vendedorId,
      if (productoId != null) 'producto_id': productoId,
      if (fecha != null) 'fecha': fecha,
      if (observacion != null) 'observacion': observacion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncErrorMessage != null) 'sync_error_message': syncErrorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FaltantesLocalCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<int>? vendedorId,
    Value<int>? productoId,
    Value<String>? fecha,
    Value<String?>? observacion,
    Value<String>? syncStatus,
    Value<String?>? syncErrorMessage,
    Value<DateTime>? createdAt,
  }) {
    return FaltantesLocalCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      vendedorId: vendedorId ?? this.vendedorId,
      productoId: productoId ?? this.productoId,
      fecha: fecha ?? this.fecha,
      observacion: observacion ?? this.observacion,
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
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (vendedorId.present) {
      map['vendedor_id'] = Variable<int>(vendedorId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (observacion.present) {
      map['observacion'] = Variable<String>(observacion.value);
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
    return (StringBuffer('FaltantesLocalCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('productoId: $productoId, ')
          ..write('fecha: $fecha, ')
          ..write('observacion: $observacion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncErrorMessage: $syncErrorMessage, ')
          ..write('createdAt: $createdAt')
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
  late final $ClientesLocalTable clientesLocal = $ClientesLocalTable(this);
  late final $FaltantesLocalTable faltantesLocal = $FaltantesLocalTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productos,
    pedidosLocal,
    orderItemsLocal,
    clientesLocal,
    faltantesLocal,
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
      required int organizacionId,
      required int clienteId,
      required int vendedorId,
      required int repartoId,
      Value<String> condicionVenta,
      required double total,
      required String fecha,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });
typedef $$PedidosLocalTableUpdateCompanionBuilder =
    PedidosLocalCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<int> clienteId,
      Value<int> vendedorId,
      Value<int> repartoId,
      Value<String> condicionVenta,
      Value<double> total,
      Value<String> fecha,
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

  ColumnFilters<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repartoId => $composableBuilder(
    column: $table.repartoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condicionVenta => $composableBuilder(
    column: $table.condicionVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
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

  ColumnOrderings<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repartoId => $composableBuilder(
    column: $table.repartoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condicionVenta => $composableBuilder(
    column: $table.condicionVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
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

  GeneratedColumn<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repartoId =>
      $composableBuilder(column: $table.repartoId, builder: (column) => column);

  GeneratedColumn<String> get condicionVenta => $composableBuilder(
    column: $table.condicionVenta,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

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
                Value<int> organizacionId = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int> vendedorId = const Value.absent(),
                Value<int> repartoId = const Value.absent(),
                Value<String> condicionVenta = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PedidosLocalCompanion(
                id: id,
                organizacionId: organizacionId,
                clienteId: clienteId,
                vendedorId: vendedorId,
                repartoId: repartoId,
                condicionVenta: condicionVenta,
                total: total,
                fecha: fecha,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required int clienteId,
                required int vendedorId,
                required int repartoId,
                Value<String> condicionVenta = const Value.absent(),
                required double total,
                required String fecha,
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PedidosLocalCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                clienteId: clienteId,
                vendedorId: vendedorId,
                repartoId: repartoId,
                condicionVenta: condicionVenta,
                total: total,
                fecha: fecha,
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
      required int productoId,
      required int cantidad,
      required double precioUnitario,
      Value<double> descuento,
      required double precioTotal,
    });
typedef $$OrderItemsLocalTableUpdateCompanionBuilder =
    OrderItemsLocalCompanion Function({
      Value<int> id,
      Value<int> pedidoLocalId,
      Value<int> productoId,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> descuento,
      Value<double> precioTotal,
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

  ColumnFilters<int> get productoId => $composableBuilder(
    column: $table.productoId,
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

  ColumnFilters<double> get precioTotal => $composableBuilder(
    column: $table.precioTotal,
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

  ColumnOrderings<int> get productoId => $composableBuilder(
    column: $table.productoId,
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

  ColumnOrderings<double> get precioTotal => $composableBuilder(
    column: $table.precioTotal,
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

  GeneratedColumn<int> get productoId => $composableBuilder(
    column: $table.productoId,
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

  GeneratedColumn<double> get precioTotal => $composableBuilder(
    column: $table.precioTotal,
    builder: (column) => column,
  );

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
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> descuento = const Value.absent(),
                Value<double> precioTotal = const Value.absent(),
              }) => OrderItemsLocalCompanion(
                id: id,
                pedidoLocalId: pedidoLocalId,
                productoId: productoId,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                descuento: descuento,
                precioTotal: precioTotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pedidoLocalId,
                required int productoId,
                required int cantidad,
                required double precioUnitario,
                Value<double> descuento = const Value.absent(),
                required double precioTotal,
              }) => OrderItemsLocalCompanion.insert(
                id: id,
                pedidoLocalId: pedidoLocalId,
                productoId: productoId,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                descuento: descuento,
                precioTotal: precioTotal,
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
typedef $$ClientesLocalTableCreateCompanionBuilder =
    ClientesLocalCompanion Function({
      Value<int> id,
      required int organizacionId,
      required int vendedorId,
      required String nombre,
      required String razonSocial,
      required String tipoDocumento,
      required String numeroDocumento,
      required String tipoIva,
      Value<String?> telefono,
      Value<String?> emailPrincipal,
      Value<String?> geoposicion,
      Value<String> estado,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });
typedef $$ClientesLocalTableUpdateCompanionBuilder =
    ClientesLocalCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<int> vendedorId,
      Value<String> nombre,
      Value<String> razonSocial,
      Value<String> tipoDocumento,
      Value<String> numeroDocumento,
      Value<String> tipoIva,
      Value<String?> telefono,
      Value<String?> emailPrincipal,
      Value<String?> geoposicion,
      Value<String> estado,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });

class $$ClientesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesLocalTable> {
  $$ClientesLocalTableFilterComposer({
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

  ColumnFilters<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoDocumento => $composableBuilder(
    column: $table.tipoDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroDocumento => $composableBuilder(
    column: $table.numeroDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoIva => $composableBuilder(
    column: $table.tipoIva,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailPrincipal => $composableBuilder(
    column: $table.emailPrincipal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geoposicion => $composableBuilder(
    column: $table.geoposicion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
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
}

class $$ClientesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesLocalTable> {
  $$ClientesLocalTableOrderingComposer({
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

  ColumnOrderings<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoDocumento => $composableBuilder(
    column: $table.tipoDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroDocumento => $composableBuilder(
    column: $table.numeroDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoIva => $composableBuilder(
    column: $table.tipoIva,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailPrincipal => $composableBuilder(
    column: $table.emailPrincipal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geoposicion => $composableBuilder(
    column: $table.geoposicion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
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

class $$ClientesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesLocalTable> {
  $$ClientesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoDocumento => $composableBuilder(
    column: $table.tipoDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroDocumento => $composableBuilder(
    column: $table.numeroDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoIva =>
      $composableBuilder(column: $table.tipoIva, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get emailPrincipal => $composableBuilder(
    column: $table.emailPrincipal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geoposicion => $composableBuilder(
    column: $table.geoposicion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

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
}

class $$ClientesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesLocalTable,
          ClientesLocalData,
          $$ClientesLocalTableFilterComposer,
          $$ClientesLocalTableOrderingComposer,
          $$ClientesLocalTableAnnotationComposer,
          $$ClientesLocalTableCreateCompanionBuilder,
          $$ClientesLocalTableUpdateCompanionBuilder,
          (
            ClientesLocalData,
            BaseReferences<
              _$AppDatabase,
              $ClientesLocalTable,
              ClientesLocalData
            >,
          ),
          ClientesLocalData,
          PrefetchHooks Function()
        > {
  $$ClientesLocalTableTableManager(_$AppDatabase db, $ClientesLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<int> vendedorId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> razonSocial = const Value.absent(),
                Value<String> tipoDocumento = const Value.absent(),
                Value<String> numeroDocumento = const Value.absent(),
                Value<String> tipoIva = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> emailPrincipal = const Value.absent(),
                Value<String?> geoposicion = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientesLocalCompanion(
                id: id,
                organizacionId: organizacionId,
                vendedorId: vendedorId,
                nombre: nombre,
                razonSocial: razonSocial,
                tipoDocumento: tipoDocumento,
                numeroDocumento: numeroDocumento,
                tipoIva: tipoIva,
                telefono: telefono,
                emailPrincipal: emailPrincipal,
                geoposicion: geoposicion,
                estado: estado,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required int vendedorId,
                required String nombre,
                required String razonSocial,
                required String tipoDocumento,
                required String numeroDocumento,
                required String tipoIva,
                Value<String?> telefono = const Value.absent(),
                Value<String?> emailPrincipal = const Value.absent(),
                Value<String?> geoposicion = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientesLocalCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                vendedorId: vendedorId,
                nombre: nombre,
                razonSocial: razonSocial,
                tipoDocumento: tipoDocumento,
                numeroDocumento: numeroDocumento,
                tipoIva: tipoIva,
                telefono: telefono,
                emailPrincipal: emailPrincipal,
                geoposicion: geoposicion,
                estado: estado,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesLocalTable,
      ClientesLocalData,
      $$ClientesLocalTableFilterComposer,
      $$ClientesLocalTableOrderingComposer,
      $$ClientesLocalTableAnnotationComposer,
      $$ClientesLocalTableCreateCompanionBuilder,
      $$ClientesLocalTableUpdateCompanionBuilder,
      (
        ClientesLocalData,
        BaseReferences<_$AppDatabase, $ClientesLocalTable, ClientesLocalData>,
      ),
      ClientesLocalData,
      PrefetchHooks Function()
    >;
typedef $$FaltantesLocalTableCreateCompanionBuilder =
    FaltantesLocalCompanion Function({
      Value<int> id,
      required int organizacionId,
      required int vendedorId,
      required int productoId,
      required String fecha,
      Value<String?> observacion,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });
typedef $$FaltantesLocalTableUpdateCompanionBuilder =
    FaltantesLocalCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<int> vendedorId,
      Value<int> productoId,
      Value<String> fecha,
      Value<String?> observacion,
      Value<String> syncStatus,
      Value<String?> syncErrorMessage,
      Value<DateTime> createdAt,
    });

class $$FaltantesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $FaltantesLocalTable> {
  $$FaltantesLocalTableFilterComposer({
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

  ColumnFilters<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacion => $composableBuilder(
    column: $table.observacion,
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
}

class $$FaltantesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $FaltantesLocalTable> {
  $$FaltantesLocalTableOrderingComposer({
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

  ColumnOrderings<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacion => $composableBuilder(
    column: $table.observacion,
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

class $$FaltantesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $FaltantesLocalTable> {
  $$FaltantesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get observacion => $composableBuilder(
    column: $table.observacion,
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
}

class $$FaltantesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FaltantesLocalTable,
          FaltantesLocalData,
          $$FaltantesLocalTableFilterComposer,
          $$FaltantesLocalTableOrderingComposer,
          $$FaltantesLocalTableAnnotationComposer,
          $$FaltantesLocalTableCreateCompanionBuilder,
          $$FaltantesLocalTableUpdateCompanionBuilder,
          (
            FaltantesLocalData,
            BaseReferences<
              _$AppDatabase,
              $FaltantesLocalTable,
              FaltantesLocalData
            >,
          ),
          FaltantesLocalData,
          PrefetchHooks Function()
        > {
  $$FaltantesLocalTableTableManager(
    _$AppDatabase db,
    $FaltantesLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FaltantesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FaltantesLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FaltantesLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<int> vendedorId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<String?> observacion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FaltantesLocalCompanion(
                id: id,
                organizacionId: organizacionId,
                vendedorId: vendedorId,
                productoId: productoId,
                fecha: fecha,
                observacion: observacion,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required int vendedorId,
                required int productoId,
                required String fecha,
                Value<String?> observacion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> syncErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FaltantesLocalCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                vendedorId: vendedorId,
                productoId: productoId,
                fecha: fecha,
                observacion: observacion,
                syncStatus: syncStatus,
                syncErrorMessage: syncErrorMessage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FaltantesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FaltantesLocalTable,
      FaltantesLocalData,
      $$FaltantesLocalTableFilterComposer,
      $$FaltantesLocalTableOrderingComposer,
      $$FaltantesLocalTableAnnotationComposer,
      $$FaltantesLocalTableCreateCompanionBuilder,
      $$FaltantesLocalTableUpdateCompanionBuilder,
      (
        FaltantesLocalData,
        BaseReferences<_$AppDatabase, $FaltantesLocalTable, FaltantesLocalData>,
      ),
      FaltantesLocalData,
      PrefetchHooks Function()
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
  $$ClientesLocalTableTableManager get clientesLocal =>
      $$ClientesLocalTableTableManager(_db, _db.clientesLocal);
  $$FaltantesLocalTableTableManager get faltantesLocal =>
      $$FaltantesLocalTableTableManager(_db, _db.faltantesLocal);
}
