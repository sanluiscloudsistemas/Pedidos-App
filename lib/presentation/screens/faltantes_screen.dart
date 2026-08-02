import 'package:flutter/material.dart';

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
                    'Faltantes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Buscador superior con selector e icono Ir
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                      color: const Color(0xFFFAFAFA),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, size: 18, color: Color(0xFF616161)),
                        Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF616161)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCCCCCC)),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text(
                        'Ir',
                        style: TextStyle(color: Color(0xFF424242), fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tabla de Productos Faltantes
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
                          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            f.productoDescripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF212121),
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
                            style: const TextStyle(fontSize: 12, color: Color(0xFF616161)),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 90,
                          child: Text(
                            f.fecha,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
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
