import 'package:flutter/material.dart';

import 'cliente_detail_screen.dart';
import 'nuevo_pedido_wizard_screen.dart';

/// Modelo de datos para un Cliente
class ClienteModel {
  final String codigo;
  final String nombre;
  final String documento;
  final String tipoIva;

  const ClienteModel({
    required this.codigo,
    required this.nombre,
    required this.documento,
    required this.tipoIva,
  });
}

/// Pantalla de Clientes (`Mis Clientes` / Clientes asignados)
class MisClientesScreen extends StatefulWidget {
  const MisClientesScreen({super.key});

  @override
  State<MisClientesScreen> createState() => _MisClientesScreenState();
}

class _MisClientesScreenState extends State<MisClientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedAccion = 'Acciones';

  final List<ClienteModel> _clientesOriginales = const [
    ClienteModel(
      codigo: '1051',
      nombre: 'CALDERON ELIANA (CF)',
      documento: 'CUIL : 1051',
      tipoIva: 'CONSUMIDOR FINAL',
    ),
    ClienteModel(
      codigo: '0193',
      nombre: 'DOMINGUEZ CARLOS MATIAS (FA)',
      documento: 'CUIT : 23334283119',
      tipoIva: 'RESP. INSCRIPTO',
    ),
    ClienteModel(
      codigo: '0016',
      nombre: 'PIÑEYRO IRMA BRANKA (FA)',
      documento: 'CUIT : 27059203792',
      tipoIva: 'RESP. INSCRIPTO',
    ),
    ClienteModel(
      codigo: '1480',
      nombre: 'BARROSO VILMA (FA)',
      documento: 'CUIT : 27201371762',
      tipoIva: 'MONOTRIBUTO',
    ),
    ClienteModel(
      codigo: '1114',
      nombre: 'SUP. CHINO - DAI BIHUI (FA)',
      documento: 'CUIT : 20957975896',
      tipoIva: 'RESP. INSCRIPTO',
    ),
    ClienteModel(
      codigo: '1198',
      nombre: 'CAMINOS ARACELI (CF)',
      documento: 'CUIL : 1198',
      tipoIva: 'CONSUMIDOR FINAL',
    ),
    ClienteModel(
      codigo: '0695',
      nombre: 'CABRERA ANALIA (FA)',
      documento: 'CUIT : 27322538680',
      tipoIva: 'RESP. INSCRIPTO',
    ),
    ClienteModel(
      codigo: '1119',
      nombre: 'FERNANDEZ JUAN CARLOS (FA)',
      documento: 'CUIT : 20319009249',
      tipoIva: 'MONOTRIBUTO',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClienteModel> get _clientesFiltrados {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return _clientesOriginales;

    return _clientesOriginales.where((c) {
      return c.nombre.toLowerCase().contains(query) ||
          c.codigo.toLowerCase().contains(query) ||
          c.documento.toLowerCase().contains(query) ||
          c.tipoIva.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final clientesList = _clientesFiltrados;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buscador superior con dropdown e icono Ir
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
              const SizedBox(height: 12),

              // Dropdown Acciones
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAccion,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF616161)),
                    style: const TextStyle(color: Color(0xFF424242), fontSize: 14),
                    items: const [
                      DropdownMenuItem(value: 'Acciones', child: Text('Acciones')),
                      DropdownMenuItem(value: 'exportar', child: Text('Exportar Clientes')),
                      DropdownMenuItem(value: 'actualizar', child: Text('Actualizar Datos')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedAccion = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botón Primario Rojo "Crear"
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abriendo formulario de creación de cliente...')),
                    );
                  },
                  child: const Text(
                    'Crear',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tabla de Clientes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 40,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 70,
                  border: TableBorder.all(color: const Color(0xFFEEEEEE), width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(
                      label: SizedBox(width: 24),
                    ),
                    DataColumn(
                      label: Text(
                        'Codigo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Pedido',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cliente',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Documento',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Tipo Iva',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
                      ),
                    ),
                  ],
                  rows: clientesList.map((c) {
                    return DataRow(cells: [
                      DataCell(
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit_note, size: 20, color: Color(0xFF1976D2)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClienteDetailScreen(
                                  cliente: ClienteDetailModel(
                                    codigo: c.codigo,
                                    nombre: c.nombre,
                                    documento: c.documento,
                                    tipoIva: c.tipoIva,
                                    telefono: '2664261198',
                                    estado: 'HABILITADO',
                                    fecha: '04/12/2014 03:01:16',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      DataCell(
                        Text(
                          c.codigo,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add_shopping_cart, size: 20, color: Color(0xFF1976D2)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NuevoPedidoWizardScreen(clienteInicial: c.nombre),
                              ),
                            );
                          },
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClienteDetailScreen(
                                  cliente: ClienteDetailModel(
                                    codigo: c.codigo,
                                    nombre: c.nombre,
                                    documento: c.documento,
                                    tipoIva: c.tipoIva,
                                    telefono: '2664261198',
                                    estado: 'HABILITADO',
                                    fecha: '04/12/2014 03:01:16',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              c.nombre,
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
                      ),
                      DataCell(
                        Text(
                          c.documento,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                        ),
                      ),
                      DataCell(
                        Text(
                          c.tipoIva,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF424242),
                            fontWeight: FontWeight.w500,
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
