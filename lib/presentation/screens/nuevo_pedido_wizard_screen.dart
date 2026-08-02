import 'package:flutter/material.dart';

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
  late String _selectedCliente;
  String _selectedCondicionVenta = 'CONTADO';

  final List<String> _clientesDisponibles = const [
    'ABIBE JULIO (CF) (2068)',
    'CALDERON ELIANA (CF) (1051)',
    'DOMINGUEZ CARLOS MATIAS (FA) (0193)',
    'PIÑEYRO IRMA BRANKA (FA) (0016)',
    'BARROSO VILMA (FA) (1480)',
    'SUP. CHINO - DAI BIHUI (FA) (1114)',
  ];

  final List<String> _condicionesVenta = const [
    'CONTADO',
    'CTA CTE',
    'CHEQUE 30 DIAS',
  ];

  // Paso 2 State
  final List<OrderItemDraft> _items = [];
  final TextEditingController _productoController = TextEditingController(text: '651');
  final TextEditingController _cantidadController = TextEditingController(text: '5');
  final TextEditingController _descuentoController = TextEditingController();

  // Paso 3 State
  String _selectedReparto = 'FER II 31-07-26';

  final List<String> _repartosDisponibles = const [
    'FER II 31-07-26',
    'SAMUEL 31-07-26',
    'ALEXIS 31-07-26',
    'FERNANDO 31-07-26',
    'SIN DEPOSITO 30-07-26',
    'LUIS DEPOSITO 30-07-26',
    'LUCAS 31-07-26',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCliente = widget.clienteInicial ?? _clientesDisponibles.first;
    // Agregar un item por defecto de muestra si está vacío
    _items.add(
      const OrderItemDraft(
        codigo: '651',
        descripcion: '651 - TALLARIN MEDIANO SEM. DON EMILIO 500 GR DON EMILIO',
        cantidad: 5,
        precioUnitario: 2100.00,
      ),
    );
  }

  @override
  void dispose() {
    _productoController.dispose();
    _cantidadController.dispose();
    _descuentoController.dispose();
    super.dispose();
  }

  double get _totalMonto => _items.fold(0.0, (sum, item) => sum + item.total);

  void _agregarProducto() {
    final codigo = _productoController.text.trim();
    final cant = int.tryParse(_cantidadController.text.trim()) ?? 1;
    final desc = double.tryParse(_descuentoController.text.trim()) ?? 0.0;

    if (codigo.isEmpty) return;

    setState(() {
      _items.add(
        OrderItemDraft(
          codigo: codigo,
          descripcion: '$codigo - PRODUCTO GENERAL REGULAR DE PRUEBA',
          cantidad: cant,
          precioUnitario: 2100.00,
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

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => setState(() => _currentStep = 2),
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
        _buildDropdownBox(
          label: 'Cliente',
          value: _selectedCliente,
          items: _clientesDisponibles,
          onChanged: (val) => setState(() => _selectedCliente = val!),
        ),
        const SizedBox(height: 16),
        _buildDropdownBox(
          label: 'Cliente',
          value: _selectedCondicionVenta,
          items: _condicionesVenta,
          onChanged: (val) => setState(() => _selectedCondicionVenta = val!),
        ),
      ],
    );
  }

  // PASO 2: Carga de Productos
  Widget _buildStep2() {
    final formattedTotal = '\$${_totalMonto.toStringAsFixed(0)}';

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
              onPressed: () => setState(() => _currentStep = 3),
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

        // Campo Producto
        const Text('Producto', style: TextStyle(fontSize: 12, color: Color(0xFF616161))),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextField(
            controller: _productoController,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(),
              hintText: 'Código o nombre',
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Campo Cantidad
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
        const SizedBox(height: 12),

        // Campo Descuento
        const Text('Descuento', style: TextStyle(fontSize: 12, color: Color(0xFF616161))),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextField(
            controller: _descuentoController,
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
                    DataColumn(label: Text('Descripcion', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                  ],
                  rows: [
                    ..._items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      return DataRow(cells: [
                        DataCell(Text(item.codigo, style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${item.cantidad}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('\$${item.precioUnitario.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(item.descuento > 0 ? '\$${item.descuento.toStringAsFixed(2)}' : '', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('\$${item.total.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                        DataCell(
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.cancel, color: Color(0xFFD32F2F), size: 18),
                            onPressed: () => _eliminarProducto(idx),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 140,
                            child: Text(item.descripcion, style: const TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                        const DataCell(SizedBox.shrink()),
                      ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '1 - ${_items.length}',
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
                backgroundColor: const Color(0xFFD32F2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Pedido creado y guardado con éxito!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildReadOnlyDetailBox('Cliente', _selectedCliente),
        _buildReadOnlyDetailBox('Condición de Venta', _selectedCondicionVenta),
        _buildReadOnlyDetailBox('TOTAL', _totalMonto.toStringAsFixed(0)),

        const SizedBox(height: 12),
        _buildDropdownBox(
          label: 'Reparto',
          value: _selectedReparto,
          items: _repartosDisponibles,
          onChanged: (val) => setState(() => _selectedReparto = val!),
        ),
      ],
    );
  }

  Widget _buildDropdownBox({
    required String label,
    required String value,
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
              value: value,
              isExpanded: true,
              style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w500),
              items: items.map((it) {
                return DropdownMenuItem(value: it, child: Text(it));
              }).toList(),
              onChanged: onChanged,
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
