import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';
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
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buscador Superior
              SearchFilterBar(
                controller: _searchController,
                hintText: 'Buscar cliente por nombre, CUIT o código...',
                onSearch: () => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Dropdown Acciones y Recuento
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: AppStyles.cardDecoration(
                        backgroundColor: Colors.white,
                        borderColor: AppColors.cardBorder,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedAccion,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
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
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Summary Header con botón Crear
              ListHeaderSummary(
                count: clientesList.length,
                label: 'clientes',
                actionButtonText: 'Crear',
                onActionButtonPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abriendo formulario de creación de cliente...')),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Tabla de Clientes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 40,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 70,
                  border: TableBorder.all(color: AppColors.cardBorder, width: 1),
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(label: SizedBox(width: 24)),
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
                          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
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
                                color: AppColors.textDark,
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
                          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                        ),
                      ),
                      DataCell(
                        Text(
                          c.tipoIva,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
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
