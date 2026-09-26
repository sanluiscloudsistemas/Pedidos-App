import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/datasources/remote/api_service.dart';
import '../notifiers/connectivity_notifier.dart';
import '../notifiers/sync_notifier.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import 'mis_clientes_screen.dart';

/// Modelo borrador para un Item de Pedido
class OrderItemDraft {
  final String codigo;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento;

  double get total => (precioUnitario * cantidad) - descuento;

  const OrderItemDraft({
    required this.codigo,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
  });
}

/// Modelo para una opción de Reparto obtenida de la API
class RepartoOption {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String zona;
  final String estado;

  const RepartoOption({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.zona,
    required this.estado,
  });

  factory RepartoOption.fromJson(Map<String, dynamic> json) {
    return RepartoOption(
      id: json['id'] is int ? json['id'] as int : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      codigo: json['codigo']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      zona: json['zona']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
    );
  }

  String get label {
    if (nombre.isNotEmpty) {
      return '$nombre (ID: $id)';
    }
    if (descripcion.isNotEmpty) {
      return '$descripcion (ID: $id)';
    }
    return 'REPARTO $codigo (ID: $id)';
  }
}

/// Wizard de Creación de Pedidos (`Nuevo Pedido`)
class NuevoPedidoWizardScreen extends StatefulWidget {
  final String? clienteInicial;

  const NuevoPedidoWizardScreen({
    super.key,
    this.clienteInicial,
  });

  @override
  State<NuevoPedidoWizardScreen> createState() => _NuevoPedidoWizardScreenState();
}

class _NuevoPedidoWizardScreenState extends State<NuevoPedidoWizardScreen> {
  int _currentStep = 1;

  // Paso 1 State
  String? _selectedCliente;
  String _selectedCondicionVenta = 'CONTADO';

  List<ClienteModel> _clientesModelList = [];
  final List<String> _clientesDisponibles = [];
  bool _isLoadingClientes = true;

  // Condición de venta restringida únicamente a CONTADO y CTA CTE
  final List<String> _condicionesVenta = const [
    'CONTADO',
    'CTA CTE',
  ];

  // Paso 2 State
  final List<OrderItemDraft> _items = [];
  final TextEditingController _productoController = TextEditingController(text: '123');
  final TextEditingController _cantidadController = TextEditingController(text: '1');
  final TextEditingController _precioController = TextEditingController(text: '10000.00');
  final TextEditingController _descuentoController = TextEditingController(text: '0');

  // Paso 3 State
  String? _selectedReparto;
  List<RepartoOption> _repartosModelList = [];
  final List<String> _repartosDisponibles = [];
  bool _isLoadingRepartos = true;

  int _extraerRepartoId(String? repartoStr) {
    if (repartoStr == null || repartoStr.isEmpty) return 96461;
    final found = _repartosModelList.where((r) => r.label == repartoStr).firstOrNull;
    if (found != null && found.id > 0) return found.id;

    final match = RegExp(r'ID:\s*(\d+)').firstMatch(repartoStr);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 96461;
    }
    final numMatch = RegExp(r'\d+').firstMatch(repartoStr);
    if (numMatch != null) {
      return int.tryParse(numMatch.group(0)!) ?? 96461;
    }
    return 96461;
  }

  String _mapCondicionVenta(String condicion) {
    final upper = condicion.toUpperCase().trim();
    if (upper.contains('CONT') || upper == 'CNT') {
      return 'CNT';
    }
    if (upper.contains('CTA') || upper.contains('CTE') || upper == 'CC') {
      return 'CC';
    }
    return upper.isNotEmpty ? upper : 'CNT';
  }

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    _cargarRepartos();
  }

  @override
  void dispose() {
    _productoController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _descuentoController.dispose();
    super.dispose();
  }

  Future<void> _cargarClientes() async {
    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.getClientes(limit: 200);

      final data = response.data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        final List itemsJson = data['items'];
        final clientes = itemsJson
            .map((item) => ClienteModel.fromJson(item as Map<String, dynamic>))
            .toList();

        setState(() {
          _clientesModelList = clientes;
          _clientesDisponibles.clear();
          for (final c in clientes) {
            final label = c.codigo.isNotEmpty ? '${c.codigo} - ${c.nombre}' : c.nombre;
            if (label.isNotEmpty && !_clientesDisponibles.contains(label)) {
              _clientesDisponibles.add(label);
            }
          }

          if (widget.clienteInicial != null && widget.clienteInicial!.isNotEmpty) {
            final match = _clientesDisponibles.firstWhere(
              (label) => label.toLowerCase().contains(widget.clienteInicial!.toLowerCase()),
              orElse: () => _clientesDisponibles.isNotEmpty ? _clientesDisponibles.first : '',
            );
            if (match.isNotEmpty) {
              _selectedCliente = match;
            } else if (_clientesDisponibles.isNotEmpty) {
              _selectedCliente = _clientesDisponibles.first;
            }
          } else if (_clientesDisponibles.isNotEmpty) {
            _selectedCliente = _clientesDisponibles.first;
          }
          _isLoadingClientes = false;
        });
      } else {
        setState(() => _isLoadingClientes = false);
      }
    } catch (_) {
      setState(() => _isLoadingClientes = false);
    }
  }

  Future<void> _cargarRepartos() async {
    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.getRepartos(limit: 100);

      final data = response.data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        final List itemsJson = data['items'];
        final repartos = itemsJson
            .map((item) => RepartoOption.fromJson(item as Map<String, dynamic>))
            .toList();

        setState(() {
          _repartosModelList = repartos;
          _repartosDisponibles.clear();
          for (final r in repartos) {
            final label = r.label;
            if (label.isNotEmpty && !_repartosDisponibles.contains(label)) {
              _repartosDisponibles.add(label);
            }
          }
          if (_repartosDisponibles.isNotEmpty) {
            _selectedReparto = _repartosDisponibles.first;
          }
          _isLoadingRepartos = false;
        });
      } else {
        setState(() {
          if (_repartosDisponibles.isEmpty) {
            _repartosDisponibles.add('REPARTO GENERAL (ID: 96461)');
            _selectedReparto = _repartosDisponibles.first;
          }
          _isLoadingRepartos = false;
        });
      }
    } catch (_) {
      setState(() {
        if (_repartosDisponibles.isEmpty) {
          _repartosDisponibles.add('REPARTO GENERAL (ID: 96461)');
          _selectedReparto = _repartosDisponibles.first;
        }
        _isLoadingRepartos = false;
      });
    }
  }

  void _abrirPopupBusquedaCliente(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final query = searchQuery.toLowerCase().trim();
            final filtrados = _clientesModelList.where((c) {
              if (query.isEmpty) return true;
              return c.nombre.toLowerCase().contains(query) ||
                  c.codigo.toLowerCase().contains(query) ||
                  c.documento.toLowerCase().contains(query) ||
                  c.tipoIva.toLowerCase().contains(query);
            }).toList();

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 500,
                height: 550,
                child: Column(
                  children: [
                    // Header del Popup
                    Container(
                      color: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Seleccionar Cliente',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.pop(dialogContext),
                          ),
                        ],
                      ),
                    ),

                    // Campo de búsqueda en tiempo real
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre, código o documento...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (val) {
                          setDialogState(() {
                            searchQuery = val;
                          });
                        },
                      ),
                    ),

                    const Divider(height: 1),

                    // Lista de clientes filtrados
                    Expanded(
                      child: filtrados.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron clientes',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filtrados.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final c = filtrados[index];
                                final label = c.codigo.isNotEmpty ? '${c.codigo} - ${c.nombre}' : c.nombre;
                                final isSelected = _selectedCliente == label;

                                return ListTile(
                                  dense: true,
                                  tileColor: isSelected ? const Color(0xFFE3F2FD) : null,
                                  title: Text(
                                    c.nombre,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? const Color(0xFF1976D2) : AppColors.textDark,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Código: ${c.codigo}${c.documento.isNotEmpty ? " | Doc: ${c.documento}" : ""}${c.tipoIva.isNotEmpty ? " | ${c.tipoIva}" : ""}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle, color: Color(0xFF1976D2), size: 20)
                                      : const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                                  onTap: () {
                                    setState(() {
                                      _selectedCliente = label;
                                    });
                                    Navigator.pop(dialogContext);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double get _totalMonto => _items.fold(0.0, (sum, item) => sum + item.total);

  void _agregarProducto() {
    final codigo = _productoController.text.trim();
    final cant = int.tryParse(_cantidadController.text.trim()) ?? 1;
    final precio = double.tryParse(_precioController.text.trim()) ?? 10000.00;
    final desc = double.tryParse(_descuentoController.text.trim()) ?? 0.0;

    if (codigo.isEmpty) return;

    setState(() {
      _items.add(
        OrderItemDraft(
          codigo: codigo,
          descripcion: 'PRODUCTO ID: $codigo',
          cantidad: cant,
          precioUnitario: precio,
          descuento: desc,
        ),
      );
      _descuentoController.clear();
    });
  }

  void _eliminarProducto(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _confirmarPedido(BuildContext context) async {
    if (_isSubmitting) return;

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe agregar al menos un producto al pedido.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final apiService = context.read<ApiService>();
      final syncNotifier = Provider.of<SyncNotifier>(context, listen: false);
      final isOnline = Provider.of<ConnectivityNotifier>(context, listen: false).isConnected;

      final now = DateTime.now();
      final fechaDisplay = DateFormatter.formatDdMonYyyyHhMiSs(now);
      final fechaOracle = DateFormatter.formatOracleTimestamp(now);

      final orgId = int.tryParse(apiService.sisorgId ?? '') ?? 14;
      final sisperId = int.tryParse(apiService.sisperId ?? '') ?? 19565;
      final depId = int.tryParse(apiService.sisdepId ?? '') ?? sisperId;
      final depositoId = int.tryParse(apiService.depositoId ?? '') ?? depId;

      int clienteId = 19568;
      if (_selectedCliente != null && _clientesModelList.isNotEmpty) {
        final found = _clientesModelList.firstWhere(
          (c) => '${c.codigo} - ${c.nombre}' == _selectedCliente || c.nombre == _selectedCliente,
          orElse: () => _clientesModelList.first,
        );
        clienteId = found.clienteId ?? int.tryParse(found.codigo) ?? 19568;
      }

      final repartoId = _extraerRepartoId(_selectedReparto);
      final condicionCode = _mapCondicionVenta(_selectedCondicionVenta);

      final itemsPayload = _items.map((it) {
        return {
          'producto_codigo': it.codigo,
          'cantidad': it.cantidad,
          'precio_unitario': it.precioUnitario,
          'descuento': it.descuento,
          'precio_total': it.total,
        };
      }).toList();

      final payload = {
        'pedido': {
          'organizacion_id': orgId,
          'cliente_id': clienteId,
          'vendedor_id': sisperId,
          'dependencia_id': depId,
          'deposito_id': depositoId,
          'reparto_id': repartoId,
          'fecha': fechaOracle,
          'condicionventa': condicionCode,
          'total': _totalMonto,
          'estado': 'NUEVO',
        },
        'items': itemsPayload,
      };

      final clientName = _selectedCliente ?? 'Cliente $clienteId';
      final repName = _selectedReparto ?? (repartoId > 0 ? 'Reparto $repartoId' : '');

      final itemsMapList = _items
          .map((it) => {
                'productoId': int.tryParse(it.codigo) ?? 0,
                'producto_codigo': it.codigo,
                'descripcion': it.descripcion,
                'cantidad': it.cantidad,
                'precioUnitario': it.precioUnitario,
                'descuento': it.descuento,
                'precioTotal': it.total,
              })
          .toList();

      if (isOnline) {
        await apiService.postPedido(payload);
        // Guardar copia local con estado SYNCED registrando que fue creado online y con estado comercial NUEVO
        await syncNotifier.saveOrderOffline(
          organizacionId: orgId,
          clienteId: clienteId,
          clienteNombre: clientName,
          vendedorId: sisperId,
          repartoId: repartoId,
          repartoNombre: repName,
          condicionVenta: condicionCode,
          total: _totalMonto,
          fecha: fechaDisplay,
          syncStatus: 'SYNCED',
          isCreatedOnline: true,
          estado: 'NUEVO',
          items: itemsMapList,
        );
      } else {
        await syncNotifier.saveOrderOffline(
          organizacionId: orgId,
          clienteId: clienteId,
          clienteNombre: clientName,
          vendedorId: sisperId,
          repartoId: repartoId,
          repartoNombre: repName,
          condicionVenta: condicionCode,
          total: _totalMonto,
          fecha: fechaDisplay,
          syncStatus: 'PENDING_SYNC',
          isCreatedOnline: false,
          estado: 'NUEVO',
          items: itemsMapList,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isOnline
                  ? '¡Pedido #POST enviado exitosamente a la nube!'
                  : '¡Pedido guardado en SQLite local! Se sincronizará automáticamente al reconectar.',
            ),
            backgroundColor: isOnline ? Colors.green : AppColors.warningOrange,
            duration: const Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar pedido: $e'),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreventaAppBar(
        title: 'NUEVO PEDIDO',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: _buildStepContent(),
            ),
          ),
          _buildBottomStepper(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  // PASO 1: Selección de Cliente y Condición de Venta
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCCCCCC)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF424242))),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                if (_selectedCliente == null || _selectedCliente!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seleccione un cliente para continuar.')),
                  );
                  return;
                }
                setState(() => _currentStep = 2);
              },
              icon: const SizedBox.shrink(),
              label: Row(
                children: const [
                  Text('Productos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (_isLoadingClientes)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
          )
        else
          _buildClientSelectorBox(),
        const SizedBox(height: 16),
        _buildDropdownBox(
          label: 'Condición de Venta',
          value: _selectedCondicionVenta,
          items: _condicionesVenta,
          onChanged: (val) {
            if (val != null) setState(() => _selectedCondicionVenta = val);
          },
        ),
      ],
    );
  }

  Widget _buildClientSelectorBox() {
    return InkWell(
      onTap: () => _abrirPopupBusquedaCliente(context),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4A89DC), width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cliente', style: TextStyle(fontSize: 11, color: Color(0xFF757575))),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedCliente ?? 'Seleccione un cliente...',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedCliente != null ? const Color(0xFF212121) : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.search, color: Color(0xFF1976D2), size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // PASO 2: Carga de Productos
  Widget _buildStep2() {
    final formattedTotal = '\$${_totalMonto.toStringAsFixed(2).replaceAll('.', ',')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              onPressed: () => setState(() => _currentStep = 1),
              child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF616161)),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 18, color: Color(0xFF616161)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TOTAL : \$', style: TextStyle(fontSize: 11, color: Color(0xFF757575))),
                Text(
                  formattedTotal.replaceAll('\$', '').trim(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              onPressed: () {
                if (_items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Agregue al menos un producto.')),
                  );
                  return;
                }
                setState(() => _currentStep = 3);
              },
              icon: const SizedBox.shrink(),
              label: Row(
                children: const [
                  Text('Reparto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Campo Producto ID
        const Text('ID Producto', style: TextStyle(fontSize: 12, color: Color(0xFF616161))),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextField(
            controller: _productoController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(),
              hintText: 'ID o código de producto',
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Campo Cantidad y Precio Unitario
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cantidad', style: TextStyle(fontSize: 12, color: Color(0xFF616161))),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: TextField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Precio Unitario', style: TextStyle(fontSize: 12, color: Color(0xFF616161))),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: TextField(
                      controller: _precioController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Campo Descuento
        const Text('Descuento', style: TextStyle(fontSize: 12, color: Color(0xFF616161))),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextField(
            controller: _descuentoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(),
              hintText: 'Descuento',
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Botón Agregar Producto
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCCCCCC)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: _agregarProducto,
            icon: const Text('Agregar Producto', style: TextStyle(color: Color(0xFF424242), fontSize: 13)),
            label: const Icon(Icons.add_shopping_cart, size: 16, color: Color(0xFF616161)),
          ),
        ),
        const SizedBox(height: 16),

        // Tabla de Productos
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Productos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF212121)),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 14,
                  headingRowHeight: 38,
                  dataRowMinHeight: 48,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                  columns: const [
                    DataColumn(label: Text('Codigo', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                    DataColumn(label: Text('Cant.', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                    DataColumn(label: Text('Unitario', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                    DataColumn(label: Text('Desc.', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                    DataColumn(label: Text('Total', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                    DataColumn(label: Text('Accion', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                  ],
                  rows: [
                    ..._items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      return DataRow(cells: [
                        DataCell(Text(item.codigo, style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${item.cantidad}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('\$${item.precioUnitario.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(item.descuento > 0 ? '\$${item.descuento.toStringAsFixed(2)}' : '0', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('\$${item.total.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                        DataCell(
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.cancel, color: Color(0xFFD32F2F), size: 18),
                            onPressed: () => _eliminarProducto(idx),
                          ),
                        ),
                      ]);
                    }),
                    if (_items.isNotEmpty)
                      DataRow(cells: [
                        const DataCell(SizedBox.shrink()),
                        const DataCell(SizedBox.shrink()),
                        const DataCell(SizedBox.shrink()),
                        const DataCell(SizedBox.shrink()),
                        DataCell(
                          Text(
                            '\$${_totalMonto.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF212121)),
                          ),
                        ),
                        const DataCell(SizedBox.shrink()),
                      ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total de ítems: ${_items.length}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // PASO 3: Selección de Reparto y Confirmación
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              onPressed: () => setState(() => _currentStep = 2),
              child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF616161)),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 18, color: Color(0xFF616161)),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: _isSubmitting ? null : () => _confirmarPedido(context),
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildReadOnlyDetailBox('Cliente', _selectedCliente ?? 'Sin cliente'),
        _buildReadOnlyDetailBox('Condición de Venta', _selectedCondicionVenta),
        _buildReadOnlyDetailBox('TOTAL', '\$ ${_totalMonto.toStringAsFixed(2)}'),

        const SizedBox(height: 12),
        _buildDropdownBox(
          label: 'Reparto',
          value: _repartosDisponibles.isEmpty ? null : _selectedReparto,
          items: _repartosDisponibles,
          onChanged: (val) {
            if (val != null) setState(() => _selectedReparto = val);
          },
        ),
      ],
    );
  }

  Widget _buildDropdownBox({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4A89DC), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF757575))),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: (items.contains(value)) ? value : null,
              hint: Text(
                _isLoadingRepartos ? 'Cargando repartos...' : 'Seleccione una opción',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w500),
              items: items.isEmpty
                  ? null
                  : items.map((it) {
                      return DropdownMenuItem<String>(value: it, child: Text(it));
                    }).toList(),
              onChanged: items.isEmpty ? null : onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyDetailBox(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF757575))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomStepper() {
    return Container(
      height: 50,
      color: const Color(0xFFFAFAFA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(step: 1),
          _buildLine(),
          _buildDot(step: 2),
          _buildLine(),
          _buildDot(step: 3),
        ],
      ),
    );
  }

  Widget _buildDot({required int step}) {
    if (step < _currentStep) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    } else if (step == _currentStep) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFD32F2F),
          shape: BoxShape.circle,
        ),
      );
    } else {
      return Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          color: Color(0xFFCCCCCC),
          shape: BoxShape.circle,
        ),
      );
    }
  }

  Widget _buildLine() {
    return Container(
      width: 50,
      height: 2,
      color: const Color(0xFFE0E0E0),
    );
  }
}
