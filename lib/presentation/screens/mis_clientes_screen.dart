import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../data/datasources/remote/api_service.dart';
import '../widgets/common/list_header_summary.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/search_filter_bar.dart';
import 'cliente_detail_screen.dart';
import 'nuevo_pedido_wizard_screen.dart';

/// Modelo de datos para un Cliente
class ClienteModel {
  final int? clienteId;
  final String codigo;
  final String nombre;
  final String documento;
  final String tipoIva;
  final String? tipoDocumento;
  final String? numeroDocumento;
  final String? telefono;
  final String? emailPrincipal;
  final String? emailSecundario;
  final String? estado;
  final String? localidad;
  final String? direccion;
  final String? geoposicion;
  final String? vendedor;
  final int? vendedorId;
  final String? zona;
  final double? ctaCteMonto;
  final String? comprobantePrincipal;

  const ClienteModel({
    this.clienteId,
    required this.codigo,
    required this.nombre,
    required this.documento,
    required this.tipoIva,
    this.tipoDocumento,
    this.numeroDocumento,
    this.telefono,
    this.emailPrincipal,
    this.emailSecundario,
    this.estado,
    this.localidad,
    this.direccion,
    this.geoposicion,
    this.vendedor,
    this.vendedorId,
    this.zona,
    this.ctaCteMonto,
    this.comprobantePrincipal,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    final tipoDoc = json['tipo_documento']?.toString().trim() ?? '';
    final numDoc = json['numero_documento']?.toString().trim() ?? '';
    final docCombined = (tipoDoc.isNotEmpty && numDoc.isNotEmpty)
        ? '$tipoDoc $numDoc'
        : (numDoc.isNotEmpty ? numDoc : tipoDoc);

    return ClienteModel(
      clienteId: (json['cliente_id'] as num?)?.toInt(),
      codigo: json['codigo']?.toString().trim() ?? '',
      nombre: json['nombre']?.toString().trim() ?? '',
      documento: docCombined,
      tipoIva: json['tipo_iva']?.toString().trim() ?? '',
      tipoDocumento: tipoDoc,
      numeroDocumento: numDoc,
      telefono: json['telefono']?.toString().trim(),
      emailPrincipal: json['email_principal']?.toString().trim(),
      emailSecundario: json['email_secundario']?.toString().trim(),
      estado: json['estado']?.toString().trim() ?? 'HABILITADO',
      localidad: json['localidad']?.toString().trim(),
      direccion: json['direccion']?.toString().trim(),
      geoposicion: json['geoposicion']?.toString().trim(),
      vendedor: json['vendedor']?.toString().trim(),
      vendedorId: (json['vendedor_id'] as num?)?.toInt(),
      zona: json['zona']?.toString().trim(),
      ctaCteMonto: (json['cta_cte_monto'] as num?)?.toDouble(),
      comprobantePrincipal: json['comprobante_principal']?.toString().trim(),
    );
  }
}

/// Pantalla de Clientes (`Mis Clientes` / Clientes asignados)
class MisClientesScreen extends StatefulWidget {
  const MisClientesScreen({super.key});

  @override
  State<MisClientesScreen> createState() => _MisClientesScreenState();
}

class _MisClientesScreenState extends State<MisClientesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ClienteModel> _clientesOriginales = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 25;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _cargarClientes(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore &&
        _searchController.text.trim().isEmpty) {
      _cargarMasClientes();
    }
  }

  Future<void> _cargarClientes({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _offset = 0;
        _hasMore = true;
      });
    }

    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.getClientes(
        offset: _offset,
        limit: _limit,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        final List itemsJson = data['items'];
        final clientesNuevos = itemsJson
            .map((item) => ClienteModel.fromJson(item as Map<String, dynamic>))
            .toList();

        final hasMoreServer = data['hasMore'] == true || clientesNuevos.length >= _limit;

        setState(() {
          if (isRefresh) {
            _clientesOriginales = clientesNuevos;
          } else {
            _clientesOriginales.addAll(clientesNuevos);
          }
          _offset = _clientesOriginales.length;
          _hasMore = hasMoreServer && clientesNuevos.isNotEmpty;
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Formato de respuesta no válido.';
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        if (isRefresh) {
          _errorMessage = 'Error al cargar clientes: $e';
        }
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _cargarMasClientes() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    await _cargarClientes(isRefresh: false);
  }

  // Filtrados por busqueda de cliente por nombre, CUIT o código...
  List<ClienteModel> get _clientesFiltrados {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return _clientesOriginales;

    return _clientesOriginales.where((c) {
      return c.nombre.toLowerCase().contains(query) ||
          c.codigo.toLowerCase().contains(query) ||
          c.documento.toLowerCase().contains(query) ||
          c.tipoIva.toLowerCase().contains(query) ||
          (c.direccion != null && c.direccion!.toLowerCase().contains(query));
    }).toList();
  }

  ClienteDetailModel _mapToDetailModel(ClienteModel c) {
    return ClienteDetailModel(
      codigo: c.codigo,
      nombre: c.nombre,
      documento: c.documento.isNotEmpty ? c.documento : (c.numeroDocumento ?? ''),
      tipoIva: c.tipoIva,
      telefono: c.telefono ?? 'Sin teléfono',
      emailPrincipal: c.emailPrincipal ?? '',
      emailSecundario: c.emailSecundario ?? '',
      estado: c.estado ?? 'HABILITADO',
      fecha: c.direccion != null && c.localidad != null
          ? '${c.direccion}, ${c.localidad}'
          : (c.direccion ?? c.localidad ?? ''),
    );
  }

  String _formatDireccion(ClienteModel c) {
    final dir = c.direccion?.trim() ?? '';
    final loc = c.localidad?.trim() ?? '';
    if (dir.isNotEmpty && loc.isNotEmpty) {
      return '$dir, $loc';
    }
    return dir.isNotEmpty ? dir : loc;
  }

  LatLng? _parseGeoposicion(String? geo) {
    if (geo == null || geo.trim().isEmpty) return null;
    final parts = geo.split(',');
    if (parts.length >= 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  void _mostrarMapaPopup(BuildContext context, ClienteModel c) {
    final coords = _parseGeoposicion(c.geoposicion);
    final direccionTexto = _formatDireccion(c);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 450,
            height: 480,
            child: Column(
              children: [
                // Header del Popup
                Container(
                  color: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Ubicación: ${c.nombre}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Información de Dirección y Coordenadas
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppColors.primaryRed),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              direccionTexto.isNotEmpty ? direccionTexto : 'Sin dirección registrada',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (c.geoposicion != null && c.geoposicion!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Geoposición: ${c.geoposicion}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Mapa de OpenStreetMap o mensaje sin geolocalización
                Expanded(
                  child: coords != null
                      ? FlutterMap(
                          options: MapOptions(
                            initialCenter: coords,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.sanluiscloud.preventa',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: coords,
                                  width: 50,
                                  height: 50,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primaryRed,
                                    size: 42,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.all(24.0),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_off, size: 48, color: AppColors.textSecondary),
                              SizedBox(height: 12),
                              Text(
                                'Este cliente no cuenta con coordenadas de geolocalización registradas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientCard(ClienteModel c) {
    final direccionTexto = _formatDireccion(c);
    final tieneGeo = c.geoposicion != null && c.geoposicion!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: AppStyles.cardDecoration(
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila Superior: Icono Detalle, Código e Icono Pedido
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.edit_note, size: 22, color: Color(0xFF1976D2)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClienteDetailScreen(
                            cliente: _mapToDetailModel(c),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CÓDIGO: ${c.codigo}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.add_shopping_cart, size: 22, color: Color(0xFF1976D2)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NuevoPedidoWizardScreen(clienteInicial: c.nombre),
                    ),
                  );
                },
              ),
            ],
          ),
          const Divider(height: 12, color: AppColors.cardBorder),

          // Nombre del Cliente (Texto estático)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cliente: ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Expanded(
                child: Text(
                  c.nombre,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Dirección con botón de Mapa en Popup
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Dirección: ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Expanded(
                child: Text(
                  direccionTexto.isNotEmpty ? direccionTexto : 'Sin dirección',
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.map_outlined,
                  size: 20,
                  color: tieneGeo ? const Color(0xFF1976D2) : AppColors.textSecondary,
                ),
                onPressed: () => _mostrarMapaPopup(context, c),
                tooltip: 'Ver ubicación en mapa',
              ),
            ],
          ),

          // Documento y Tipo IVA
          if (c.documento.isNotEmpty || c.tipoIva.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (c.documento.isNotEmpty)
                  Text(
                    'Doc: ${c.documento}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                if (c.tipoIva.isNotEmpty)
                  Text(
                    c.tipoIva,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableView(List<ClienteModel> clientesList) {
    return SingleChildScrollView(
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
              'CODIGO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
            ),
          ),
          DataColumn(
            label: Text(
              'PEDIDO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
            ),
          ),
          DataColumn(
            label: Text(
              'CLIENTE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
            ),
          ),
          DataColumn(
            label: Text(
              'DIRECCION',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2)),
            ),
          ),
        ],
        rows: clientesList.map((c) {
          final direccionTexto = _formatDireccion(c);
          final tieneGeo = c.geoposicion != null && c.geoposicion!.trim().isNotEmpty;

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
                        cliente: _mapToDetailModel(c),
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
              SizedBox(
                width: 180,
                child: Text(
                  c.nombre,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 220,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        direccionTexto,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.map_outlined,
                        size: 18,
                        color: tieneGeo ? const Color(0xFF1976D2) : AppColors.textSecondary,
                      ),
                      onPressed: () => _mostrarMapaPopup(context, c),
                      tooltip: 'Ver ubicación en mapa',
                    ),
                  ],
                ),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildBody(List<ClienteModel> clientesList) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64.0),
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    if (_errorMessage != null && _clientesOriginales.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textDark),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _cargarClientes(isRefresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Buscador Superior
        SearchFilterBar(
          controller: _searchController,
          hintText: 'Buscar cliente por nombre, CUIT o código...',
          onSearch: () => setState(() {}),
        ),
        const SizedBox(height: 12),

        ListHeaderSummary(
          count: clientesList.length,
          label: '   Lista de Clientes',
          actionButtonText: 'Mapa',
        ),
        const SizedBox(height: 12),

        // Vista adaptable: Tarjetas verticales en móviles (<600px) o DataTable en pantallas más anchas
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              if (clientesList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'No se encontraron clientes',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                );
              }
              return Column(
                children: clientesList.map((c) => _buildClientCard(c)).toList(),
              );
            } else {
              return _buildTableView(clientesList);
            }
          },
        ),
      ],
    );
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
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildBody(clientesList),
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primaryRed),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
