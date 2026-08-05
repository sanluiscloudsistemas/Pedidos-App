import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';
import '../widgets/common/status_pill_tag.dart';

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
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buscador de Repartos por zona o código
              SearchFilterBar(
                controller: _searchController,
                hintText: 'Buscar reparto por nombre, código o zona...',
                onSearch: () => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Etiquetas Pills de Filtro Interactivo por Estado
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPillTag.active(
                    label: 'ABIERTO (${_countByEstado("ABIERTO")})',
                    isSelected: _filterAbierto,
                    onTap: () => setState(() => _filterAbierto = !_filterAbierto),
                  ),
                  StatusPillTag.pending(
                    label: 'EN CARGA (${_countByEstado("EN CARGA")})',
                    isSelected: _filterEnCarga,
                    onTap: () => setState(() => _filterEnCarga = !_filterEnCarga),
                  ),
                  StatusPillTag.inactive(
                    label: 'FINALIZADO (${_countByEstado("FINALIZADO")})',
                    isSelected: _filterFinalizado,
                    onTap: () => setState(() => _filterFinalizado = !_filterFinalizado),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Header y botón de restablecer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListHeaderSummary(
                    count: repartosList.length,
                    label: 'repartos',
                  ),
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
                    label: const Text(
                      'Restablecer',
                      style: TextStyle(color: AppColors.textDark, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tabla de Repartos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 40,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 75,
                  border: TableBorder.all(color: AppColors.cardBorder, width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(
                      label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                    DataColumn(
                      label: Text('Descripcion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('Zona', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
                    ),
                  ],
                  rows: repartosList.map((r) {
                    return DataRow(cells: [
                      DataCell(Text(r.fecha, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
                      DataCell(Text(r.codigo, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
                      DataCell(
                        Text(
                          r.nombre,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 140,
                          child: Text(
                            r.descripcion,
                            style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            r.zona,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2)),
                            maxLines: 2,
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
}
