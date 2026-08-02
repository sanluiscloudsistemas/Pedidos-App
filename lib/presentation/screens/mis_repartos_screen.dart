import 'package:flutter/material.dart';

/// Modelo de datos para un Reparto
class RepartoModel {
  final String fecha;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String zona;
  final String estado;

  const RepartoModel({
    required this.fecha,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.zona,
    required this.estado,
  });
}

/// Pantalla de Repartos del Preventista (`Mis Repartos`)
class MisRepartosScreen extends StatefulWidget {
  const MisRepartosScreen({super.key});

  @override
  State<MisRepartosScreen> createState() => _MisRepartosScreenState();
}

class _MisRepartosScreenState extends State<MisRepartosScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _filterFinalizado = false;
  bool _filterAbierto = true;
  bool _filterEnCarga = false;

  final List<RepartoModel> _repartosOriginales = const [
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95521',
      nombre: 'FER II 31-07-26',
      descripcion: 'FER II 31-07-26',
      zona: 'FER (LUNES - JUEVES) B° PUERTAS DEL SOL Y EVA PERON',
      estado: 'ABIERTO',
    ),
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95522',
      nombre: 'SAMUEL 31-07-26',
      descripcion: 'SAMUEL 31-07-26',
      zona: 'SAMUEL (LUNES - JUEVES) NORTE SL',
      estado: 'ABIERTO',
    ),
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95523',
      nombre: 'ALEXIS 31-07-26',
      descripcion: 'ALEXIS 31-07-26',
      zona: 'ALEXIS (LUNES - JUEVES) B° CGT Y ALREDEDORES',
      estado: 'ABIERTO',
    ),
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95501',
      nombre: 'FERNANDO 31-07-26',
      descripcion: 'DSFSFS',
      zona: 'FER (LUNES - JUEVES) B° PUERTAS DEL SOL Y EVA PERON',
      estado: 'ABIERTO',
    ),
    RepartoModel(
      fecha: '30/07/2026 00:00:00',
      codigo: '95525',
      nombre: 'SIN DEPOSITO',
      descripcion: 'SIN DEPOSITO',
      zona: 'DEPOSITO',
      estado: 'ABIERTO',
    ),
    RepartoModel(
      fecha: '29/07/2026 00:00:00',
      codigo: '95480',
      nombre: 'REPARTO ANTERIOR',
      descripcion: 'REPARTO FINALIZADO',
      zona: 'CENTRO SL',
      estado: 'FINALIZADO',
    ),
    RepartoModel(
      fecha: '31/07/2026 00:00:00',
      codigo: '95530',
      nombre: 'REPARTO NOCTURNO',
      descripcion: 'EN PREPARACION',
      zona: 'SUR SL',
      estado: 'EN CARGA',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RepartoModel> get _repartosFiltrados {
    return _repartosOriginales.where((r) {
      final query = _searchController.text.toLowerCase().trim();
      final matchSearch = query.isEmpty ||
          r.nombre.toLowerCase().contains(query) ||
          r.codigo.toLowerCase().contains(query) ||
          r.zona.toLowerCase().contains(query) ||
          r.descripcion.toLowerCase().contains(query);

      final hasStatusFilter = _filterFinalizado || _filterAbierto || _filterEnCarga;
      if (!hasStatusFilter) return matchSearch;

      final matchState = (_filterFinalizado && r.estado == 'FINALIZADO') ||
          (_filterAbierto && r.estado == 'ABIERTO') ||
          (_filterEnCarga && r.estado == 'EN CARGA');

      return matchSearch && matchState;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _filterFinalizado = false;
      _filterAbierto = false;
      _filterEnCarga = false;
      _searchController.clear();
    });
  }

  int _countByEstado(String estado) {
    return _repartosOriginales.where((r) => r.estado == estado).length;
  }

  @override
  Widget build(BuildContext context) {
    final repartosList = _repartosFiltrados;

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
                    'Mis Repartos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Buscador de Repartos
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar...',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filterFinalizado = false;
                            _filterAbierto = false;
                            _filterEnCarga = false;
                          });
                        },
                        child: const Text(
                          'Borrar',
                          style: TextStyle(color: Color(0xFF1976D2), fontSize: 13),
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
                      title: Text('ABIERTO (${_countByEstado("ABIERTO")})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      value: _filterAbierto,
                      onChanged: (val) => setState(() => _filterAbierto = val ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('EN CARGA (${_countByEstado("EN CARGA")})', style: const TextStyle(fontSize: 13)),
                      value: _filterEnCarga,
                      onChanged: (val) => setState(() => _filterEnCarga = val ?? false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recuento total, Filtros Activos y Restablecer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recuento Total de Filas ${repartosList.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF212121),
                    ),
                  ),
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
              const SizedBox(height: 8),

              // Chips / Tags de Filtro Activo (ej. Estado ABIERTO [X])
              Wrap(
                spacing: 8,
                children: [
                  if (_filterAbierto)
                    _buildActiveFilterChip('Estado  ABIERTO', () {
                      setState(() => _filterAbierto = false);
                    }),
                  if (_filterFinalizado)
                    _buildActiveFilterChip('Estado  FINALIZADO', () {
                      setState(() => _filterFinalizado = false);
                    }),
                  if (_filterEnCarga)
                    _buildActiveFilterChip('Estado  EN CARGA', () {
                      setState(() => _filterEnCarga = false);
                    }),
                ],
              ),
              const SizedBox(height: 12),

              // Tabla de Repartos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 40,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 80,
                  border: TableBorder.all(color: const Color(0xFFEEEEEE), width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(
                      label: Row(
                        children: [
                          Text('Fecha ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                          Icon(Icons.swap_vert, size: 16, color: Color(0xFF1976D2)),
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                    DataColumn(
                      label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                    DataColumn(
                      label: Text('Descripcion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                    DataColumn(
                      label: Text('Zona', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                  ],
                  rows: repartosList.map((r) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          r.fecha,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                        ),
                      ),
                      DataCell(
                        Text(
                          r.codigo,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 130,
                          child: Text(
                            r.nombre,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 130,
                          child: Text(
                            r.descripcion,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 180,
                          child: Text(
                            r.zona,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF424242),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
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

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Color(0xFF616161)),
          ),
        ],
      ),
    );
  }
}
