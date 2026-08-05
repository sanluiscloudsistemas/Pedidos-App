import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';

/// Modelo de datos para un Producto Faltante
class FaltanteItemModel {
  final String codigo;
  final String productoDescripcion;
  final String observacion;
  final String fecha;

  const FaltanteItemModel({
    required this.codigo,
    required this.productoDescripcion,
    this.observacion = '',
    required this.fecha,
  });
}

/// Pantalla de Productos Faltantes (`Faltantes`)
class FaltantesScreen extends StatefulWidget {
  const FaltantesScreen({super.key});

  @override
  State<FaltantesScreen> createState() => _FaltantesScreenState();
}

class _FaltantesScreenState extends State<FaltantesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<FaltanteItemModel> _faltantesOriginales = const [
    FaltanteItemModel(
      codigo: '294',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ CLASICO ARPAN X 500 GR. - ,5 Kilos',
      observacion: '',
      fecha: 'Hace 3 meses',
    ),
    FaltanteItemModel(
      codigo: '297',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ DORADO ARPAN X 500 GR. - 5 Kilos',
      observacion: '',
      fecha: 'Hace 5 semanas',
    ),
    FaltanteItemModel(
      codigo: '296',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ PROVENZAL ARPAN X 500 GR. - ,5 Kilos',
      observacion: '',
      fecha: 'Hace 5 semanas',
    ),
    FaltanteItemModel(
      codigo: '295',
      productoDescripcion: 'ARPAN - REBOZADORES - ARPAN - REBOZADOR DE ARROZ SEMILLAS ARPAN X 500 GR. - ,5 Kilos',
      observacion: '',
      fecha: 'Hace 3 meses',
    ),
    FaltanteItemModel(
      codigo: '299',
      productoDescripcion: 'ARPAN - TALITAS - ARPAN - TALITAS DE ARROZ CLASICAS ARPAN X 90 GR. - ,9 Kilos',
      observacion: '',
      fecha: 'Hace 3 meses',
    ),
    FaltanteItemModel(
      codigo: '298',
      productoDescripcion: 'ARPAN - TALITAS - ARPAN - TALITAS DE ARROZ SABOR FRUTOS DEL BOSQUE ARPAN X 90 GR. - ,9 Kilos',
      observacion: '',
      fecha: 'Hace 3 meses',
    ),
    FaltanteItemModel(
      codigo: '190',
      productoDescripcion: 'ARROZ - ARROZ TIO CARLOS - TIO CARLOS - ARROZ TIO CARLOS INTEGRAL X 1 KG. - 1 Kilos',
      observacion: '',
      fecha: 'Hace 4 semanas',
    ),
    FaltanteItemModel(
      codigo: '957',
      productoDescripcion: 'CELUSAL - SAL - CELUSAL - SAL ENTREFINA ESTUCHE X 1 KG. - 1 Kilos',
      observacion: '',
      fecha: 'Hace 3 meses',
    ),
    FaltanteItemModel(
      codigo: '970',
      productoDescripcion: 'CELUSAL - SALEROS - CELUSAL - SALERO SAL ENTREFINA X 1 KG. - 1 Kilos',
      observacion: '',
      fecha: 'Hace 3 meses',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaltanteItemModel> get _faltantesFiltrados {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return _faltantesOriginales;

    return _faltantesOriginales.where((f) {
      return f.productoDescripcion.toLowerCase().contains(query) ||
          f.codigo.toLowerCase().contains(query) ||
          f.observacion.toLowerCase().contains(query) ||
          f.fecha.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final faltantesList = _faltantesFiltrados;

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
              // Buscador superior con botón "Ir"
              SearchFilterBar(
                controller: _searchController,
                hintText: 'Buscar producto faltante por descripción o código...',
                onSearch: () => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Summary Header con recuento de faltantes
              ListHeaderSummary(
                count: faltantesList.length,
                label: 'faltantes',
              ),
              const SizedBox(height: 12),

              // Tabla de Productos Faltantes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 40,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 80,
                  border: TableBorder.all(color: AppColors.cardBorder, width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Codigo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text(
                            'Producto Descripcion ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                          ),
                          Icon(Icons.swap_vert, size: 16, color: Color(0xFF1976D2)),
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Observacion',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Fecha',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                  ],
                  rows: faltantesList.map((f) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          f.codigo,
                          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            f.productoDescripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Text(
                            f.observacion,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 90,
                          child: Text(
                            f.fecha,
                            style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                            maxLines: 2,
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
