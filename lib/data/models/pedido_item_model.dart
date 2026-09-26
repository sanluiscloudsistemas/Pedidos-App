import '../../core/utils/date_formatter.dart';

/// Modelo para un ítem dentro de un pedido
class PedidoDetalleItem {
  final String codigo;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double precioTotal;

  const PedidoDetalleItem({
    required this.codigo,
    this.descripcion = '',
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
    required this.precioTotal,
  });

  factory PedidoDetalleItem.fromJson(Map<String, dynamic> json) {
    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString().replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '.').trim()) ?? 0.0;
    }

    final cantRaw = json['cantidad'] ?? json['CANTIDAD'] ?? json['cant'] ?? json['CANT'];
    final cant = cantRaw is int
        ? cantRaw
        : (int.tryParse(cantRaw?.toString() ?? '') ?? 1);

    final unit = parseNum(
      json['precio_unitario'] ??
      json['PRECIO_UNITARIO'] ??
      json['monto_unitario'] ??
      json['MONTO_UNITARIO'] ??
      json['precio'] ??
      json['PRECIO']
    );

    final desc = parseNum(json['descuento'] ?? json['DESCUENTO']);

    final totalRaw = json['precio_total'] ??
        json['PRECIO_TOTAL'] ??
        json['monto_total'] ??
        json['MONTO_TOTAL'] ??
        json['total'] ??
        json['TOTAL'];
    final total = parseNum(totalRaw) > 0 ? parseNum(totalRaw) : (cant * unit) - desc;

    final codigoStr = json['producto_codigo']?.toString() ??
        json['PRODUCTO_CODIGO']?.toString() ??
        json['propro_codigo']?.toString() ??
        json['PROPRO_CODIGO']?.toString() ??
        json['producto_id']?.toString() ??
        json['PRODUCTO_ID']?.toString() ??
        json['propro_id']?.toString() ??
        json['PROPRO_ID']?.toString() ??
        json['codigo']?.toString() ??
        json['CODIGO']?.toString() ??
        json['id']?.toString() ??
        json['ID']?.toString() ??
        '';

    final descStr = json['descripcion']?.toString() ??
        json['DESCRIPCION']?.toString() ??
        json['producto_descripcion']?.toString() ??
        json['PRODUCTO_DESCRIPCION']?.toString() ??
        json['producto']?.toString() ??
        json['PRODUCTO']?.toString() ??
        json['nombre']?.toString() ??
        json['NOMBRE']?.toString() ??
        (codigoStr.isNotEmpty ? 'Producto #$codigoStr' : '');

    return PedidoDetalleItem(
      codigo: codigoStr,
      descripcion: descStr,
      cantidad: cant,
      precioUnitario: unit,
      descuento: desc,
      precioTotal: total,
    );
  }
}

/// Modelo de datos para un Pedido en la vista de lista
class PedidoItemModel {
  final String fechaGeneracion;
  final String fechaEntrega;
  final String estadoFecha;
  final String? estadoColor;
  final String? id;
  final String codigo;
  final String cliente;
  final double monto;
  final String estado;
  final String condicionVenta;
  final String reparto;
  final List<PedidoDetalleItem> items;
  final bool isOffline;
  final DateTime? fechaCreacion;

  const PedidoItemModel({
    required this.fechaGeneracion,
    this.fechaEntrega = '',
    this.estadoFecha = '',
    this.estadoColor,
    this.id,
    required this.codigo,
    required this.cliente,
    required this.monto,
    required this.estado,
    this.condicionVenta = 'CONTADO',
    this.reparto = '',
    this.items = const [],
    this.isOffline = false,
    this.fechaCreacion,
  });

  DateTime get effectiveFechaGeneracion {
    final parsed = parseDate(fechaGeneracion);
    if (parsed != null && parsed.millisecondsSinceEpoch > 0) {
      if (parsed.hour == 0 && parsed.minute == 0 && parsed.second == 0 && fechaCreacion != null) {
        return DateTime(
          parsed.year,
          parsed.month,
          parsed.day,
          fechaCreacion!.hour,
          fechaCreacion!.minute,
          fechaCreacion!.second,
          fechaCreacion!.millisecond,
        );
      }
      return parsed;
    }
    return fechaCreacion ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Alias de compatibilidad
  DateTime get effectiveFechaCreacion => effectiveFechaGeneracion;

  /// Fecha unificada en formato DD MON YYYY HH24:MI:SS (ej. '26 SEP 2026 14:05:30')
  String get fechaFormateada {
    final date = effectiveFechaGeneracion;
    if (date.millisecondsSinceEpoch == 0) return fechaGeneracion;
    return DateFormatter.formatDdMonYyyyHhMiSs(date);
  }

  static DateTime? parseDate(dynamic val) {
    return DateFormatter.parseFlexible(val);
  }

  static int compareDesc(PedidoItemModel a, PedidoItemModel b) {
    final dateA = a.effectiveFechaGeneracion;
    final dateB = b.effectiveFechaGeneracion;

    final dateCmp = dateB.compareTo(dateA);
    if (dateCmp != 0) {
      return dateCmp;
    }

    final idA = int.tryParse(a.id ?? '') ?? int.tryParse(a.codigo.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final idB = int.tryParse(b.id ?? '') ?? int.tryParse(b.codigo.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final idCmp = idB.compareTo(idA);
    if (idCmp != 0) {
      return idCmp;
    }

    return b.codigo.compareTo(a.codigo);
  }

  PedidoItemModel copyWith({
    String? fechaGeneracion,
    String? fechaEntrega,
    String? estadoFecha,
    String? estadoColor,
    String? id,
    String? codigo,
    String? cliente,
    double? monto,
    String? estado,
    String? condicionVenta,
    String? reparto,
    List<PedidoDetalleItem>? items,
    bool? isOffline,
    DateTime? fechaCreacion,
  }) {
    return PedidoItemModel(
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      estadoFecha: estadoFecha ?? this.estadoFecha,
      estadoColor: estadoColor ?? this.estadoColor,
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      cliente: cliente ?? this.cliente,
      monto: monto ?? this.monto,
      estado: estado ?? this.estado,
      condicionVenta: condicionVenta ?? this.condicionVenta,
      reparto: reparto ?? this.reparto,
      items: items ?? this.items,
      isOffline: isOffline ?? this.isOffline,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  factory PedidoItemModel.fromJson(Map<String, dynamic> json) {
    double parseMonto(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) {
        final clean = val.replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '.').trim();
        return double.tryParse(clean) ?? 0.0;
      }
      return 0.0;
    }

    final List<PedidoDetalleItem> parsedItems = [];
    final rawItems = json['items'] ??
        json['ITEMS'] ??
        json['detalles'] ??
        json['DETALLES'] ??
        json['lineas'] ??
        json['LINEAS'] ??
        json['productos'] ??
        json['PRODUCTOS'] ??
        json['detalle'] ??
        json['DETALLE'];

    if (rawItems is List) {
      for (final it in rawItems) {
        if (it is Map<String, dynamic>) {
          parsedItems.add(PedidoDetalleItem.fromJson(it));
        } else if (it is Map) {
          parsedItems.add(PedidoDetalleItem.fromJson(Map<String, dynamic>.from(it)));
        }
      }
    }

    final fechaGen = json['fecha_de_generacion']?.toString().trim() ??
        json['FECHA_DE_GENERACION']?.toString().trim() ??
        json['fecha_generacion']?.toString().trim() ??
        json['FECHA_GENERACION']?.toString().trim() ??
        json['fecha']?.toString().trim() ??
        json['FECHA']?.toString().trim() ??
        json['fecha_creacion']?.toString().trim() ??
        json['FECHA_CREACION']?.toString().trim() ??
        '';

    final rawCreated = json['fecha_de_generacion'] ??
        json['FECHA_DE_GENERACION'] ??
        json['fecha_generacion'] ??
        json['FECHA_GENERACION'] ??
        json['fecha_creacion'] ??
        json['FECHA_CREACION'] ??
        json['created_at'] ??
        json['CREATED_AT'] ??
        json['fecha'] ??
        json['FECHA'];

    final parsedFechaCreacion = parseDate(rawCreated);

    final fechaEnt = json['fecha_entrega']?.toString().trim() ??
        json['FECHA_ENTREGA']?.toString().trim() ??
        '';

    final estadoFec = json['estado_fecha']?.toString().trim() ??
        json['ESTADO_FECHA']?.toString().trim() ??
        '';

    final estadoCol = json['estado_color']?.toString().trim() ??
        json['ESTADO_COLOR']?.toString().trim();

    final idVal = json['id']?.toString().trim() ??
        json['ID']?.toString().trim() ??
        json['pedido_id']?.toString().trim() ??
        json['PEDIDO_ID']?.toString().trim() ??
        json['comcom_id']?.toString().trim() ??
        json['COMCOM_ID']?.toString().trim();

    final codigoVal = json['codigo']?.toString().trim() ??
        json['CODIGO']?.toString().trim() ??
        (idVal != null && idVal.isNotEmpty ? idVal : '');

    final clienteNombre = json['cliente']?.toString().trim() ??
        json['CLIENTE']?.toString().trim() ??
        json['cliente_nombre']?.toString().trim() ??
        json['CLIENTE_NOMBRE']?.toString().trim() ??
        (json['cliente_id'] != null
            ? 'Cliente ID: ${json['cliente_id']}'
            : (json['CLIENTE_ID'] != null ? 'Cliente ID: ${json['CLIENTE_ID']}' : 'Sin cliente'));

    final montoVal = parseMonto(
      json['monto'] ??
      json['MONTO'] ??
      json['total'] ??
      json['TOTAL']
    );

    final estadoVal = json['estado']?.toString().trim() ??
        json['ESTADO']?.toString().trim() ??
        'NUEVO';

    final condVenta = json['condicion_venta']?.toString().trim() ??
        json['CONDICION_VENTA']?.toString().trim() ??
        json['condicionventa']?.toString().trim() ??
        json['CONDICIONVENTA']?.toString().trim() ??
        'CONTADO';

    final repartoVal = json['reparto']?.toString().trim() ??
        json['REPARTO']?.toString().trim() ??
        (json['sisrep_id'] != null
            ? 'Reparto ID: ${json['sisrep_id']}'
            : (json['SISREP_ID'] != null
                ? 'Reparto ID: ${json['SISREP_ID']}'
                : (json['reparto_id'] != null
                    ? 'Reparto ID: ${json['reparto_id']}'
                    : (json['REPARTO_ID'] != null ? 'Reparto ID: ${json['REPARTO_ID']}' : ''))));

    return PedidoItemModel(
      fechaGeneracion: fechaGen,
      fechaEntrega: fechaEnt,
      estadoFecha: estadoFec,
      estadoColor: estadoCol,
      id: idVal,
      codigo: codigoVal,
      cliente: clienteNombre,
      monto: montoVal,
      estado: estadoVal,
      condicionVenta: condVenta,
      reparto: repartoVal,
      items: parsedItems,
      fechaCreacion: parsedFechaCreacion,
    );
  }
}
