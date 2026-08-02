import 'package:flutter/material.dart';

import 'nuevo_pedido_wizard_screen.dart';

/// Modelo de datos para un Pedido en la vista de lista
class PedidoItemModel {
  final String fechaGeneracion;
  final String codigo;
  final String cliente;
  final double monto;
  final String estado;

  const PedidoItemModel({
    required this.fechaGeneracion,
    required this.codigo,
    required this.cliente,
    required this.monto,
    required this.estado,
  });
}

/// Pantalla de Listado de Pedidos (`Mis Pedidos` / Pedidos Actuales del Cliente)
class MisPedidosScreen extends StatefulWidget {
  final String? clienteNombre;

  const MisPedidosScreen({
    super.key,
    this.clienteNombre,
  });

  @override
  State<MisPedidosScreen> createState() => _MisPedidosScreenState();
}

class _MisPedidosScreenState extends State<MisPedidosScreen> {
  bool _filterFinalizado = false;
  bool _filterNuevo = false;
  bool _filterPendiente = false;
  final TextEditingController _searchController = TextEditingController();

  final List<PedidoItemModel> _pedidosOriginales = const [
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513003',
      cliente: '0720 BERARDI OLIVA CYNTHIA BELEN (FA)',
      monto: 30550.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513004',
      cliente: '0306 AGUERO CECILIA (FA)',
      monto: 41000.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513005',
      cliente: '3699 MIRANDA ROMINA SOLEDAD (CF)',
      monto: 30640.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513007',
      cliente: '0400 DISTRIBUIDORA MAG SRL CAIDOS (FA)',
      monto: 220500.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513008',
      cliente: '1335 DISTRIBUIDORA MAG SRL SARMIENTO (FA)',
      monto: 393000.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '29/07/2026',
      codigo: '513009',
      cliente: '1335 DISTRIBUIDORA MAG SRL (FA)',
      monto: 67200.00,
      estado: 'FINALIZADO',
    ),
    PedidoItemModel(
      fechaGeneracion: '30/07/2026',
      codigo: '513010',
      cliente: '0720 BERARDI OLIVA CYNTHIA BELEN (FA)',
      monto: 15800.00,
      estado: 'NUEVO',
    ),
    PedidoItemModel(
      fechaGeneracion: '30/07/2026',
      codigo: '513011',
      cliente: '0306 AGUERO CECILIA (FA)',
      monto: 28400.00,
      estado: 'PENDIENTE',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.clienteNombre != null) {
      _searchController.text = widget.clienteNombre!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PedidoItemModel> get _pedidosFiltrados {
    return _pedidosOriginales.where((p) {
      // Filtro de Búsqueda por texto (Cliente o Código)
      final query = _searchController.text.toLowerCase().trim();
      final matchSearch = query.isEmpty ||
          p.cliente.toLowerCase().contains(query) ||
          p.codigo.toLowerCase().contains(query);

      // Filtro por casillas de Estado
      final hasStatusFilter = _filterFinalizado || _filterNuevo || _filterPendiente;
      if (!hasStatusFilter) return matchSearch;

      final matchState = (_filterFinalizado && p.estado == 'FINALIZADO') ||
          (_filterNuevo && p.estado == 'NUEVO') ||
          (_filterPendiente && p.estado == 'PENDIENTE');

      return matchSearch && matchState;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _filterFinalizado = false;
      _filterNuevo = false;
      _filterPendiente = false;
      _searchController.clear();
    });
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'FINALIZADO':
        return const Color(0xFFD32F2F); // Rojo corporativo
      case 'NUEVO':
        return const Color(0xFF1976D2); // Azul
      case 'PENDIENTE':
        return const Color(0xFFF57C00); // Naranja
      default:
        return const Color(0xFF616161);
    }
  }

  int _countByEstado(String estado) {
    return _pedidosOriginales.where((p) => p.estado == estado).length;
  }

  @override
  Widget build(BuildContext context) {
    final pedidosList = _pedidosFiltrados;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 1,
        titleSpacing: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFB71C1C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 20),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'PEDIDOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
            onPressed: () {},
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.help_outline, color: Colors.white, size: 18),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              SizedBox(width: 8),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person_outline, color: Colors.white, size: 18),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb Navigation
              Row(
                children: const [
                  Icon(Icons.chevron_left, size: 18, color: Color(0xFF757575)),
                  Text(
                    'Inicio',
                    style: TextStyle(color: Color(0xFF757575), fontSize: 13),
                  ),
                  Text(
                    '  \\  ',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                  ),
                  Text(
                    'Mis Pedidos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Buscador de Pedidos / Cliente
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar cliente o código...',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF757575)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sección Filtros: Estado
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  shape: const Border(),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  title: Row(
                    children: const [
                      Icon(Icons.check_box_outlined, size: 18, color: Color(0xFF616161)),
                      SizedBox(width: 8),
                      Text(
                        'Estado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('FINALIZADO (${_countByEstado("FINALIZADO")})', style: const TextStyle(fontSize: 13)),
                      value: _filterFinalizado,
                      onChanged: (val) => setState(() => _filterFinalizado = val ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('NUEVO (${_countByEstado("NUEVO")})', style: const TextStyle(fontSize: 13)),
                      value: _filterNuevo,
                      onChanged: (val) => setState(() => _filterNuevo = val ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('PENDIENTE (${_countByEstado("PENDIENTE")})', style: const TextStyle(fontSize: 13)),
                      value: _filterPendiente,
                      onChanged: (val) => setState(() => _filterPendiente = val ?? false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recuento total de filas y botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recuento Total de Filas ${pedidosList.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF212121),
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          side: const BorderSide(color: Color(0xFFCCCCCC)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NuevoPedidoWizardScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.assignment_add, size: 16, color: Color(0xFF616161)),
                        label: const Text(
                          'Pedido',
                          style: TextStyle(color: Color(0xFF424242), fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _resetFilters,
                        icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF616161)),
                        label: const Text(
                          'Restablecer',
                          style: TextStyle(color: Color(0xFF424242), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tabla de Datos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 40,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 64,
                  border: TableBorder.all(color: const Color(0xFFEEEEEE), width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(
                      label: Text('Fecha\nGeneracion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('Estado\nColor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                  rows: pedidosList.map((p) {
                    final formattedMonto = '\$${p.monto.toStringAsFixed(2).replaceAll('.', ',')}';
                    return DataRow(cells: [
                      DataCell(Text(p.fechaGeneracion, style: const TextStyle(fontSize: 12))),
                      DataCell(Text(p.codigo, style: const TextStyle(fontSize: 12))),
                      DataCell(
                        InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.text = p.cliente;
                            });
                          },
                          child: SizedBox(
                            width: 180,
                            child: Text(
                              p.cliente,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1976D2),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(formattedMonto, style: const TextStyle(fontSize: 12))),
                      DataCell(
                        Text(
                          p.estado,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getEstadoColor(p.estado),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
