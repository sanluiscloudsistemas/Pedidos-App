import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/status_pill_tag.dart';
import 'mis_pedidos_screen.dart';

/// Pantalla del Detalle de un Pedido (`Pedido <codigo>`)
class PedidoDetailScreen extends StatelessWidget {
  final PedidoItemModel pedido;

  const PedidoDetailScreen({
    super.key,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    final double itemsTotal = pedido.items.fold<double>(0.0, (acc, it) => acc + it.precioTotal);
    final double displayTotal = itemsTotal > 0 ? itemsTotal : pedido.monto;
    final formattedMonto = '\$ ${displayTotal.toStringAsFixed(2).replaceAll('.', ',')}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con Código y Tags de Origen y Estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pedido ${pedido.codigo}',
                      style: AppStyles.sectionTitleStyle.copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildOriginPill(pedido.isOffline),
                      const SizedBox(width: 6),
                      if (pedido.estado.isNotEmpty)
                        StatusPillTag.active(label: pedido.estado),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Cajas de información estructurada del pedido
              _buildDetailBox('Código', pedido.codigo),
              _buildDetailBox('Origen', pedido.isOffline ? 'MODO OFFLINE (Local Hive)' : 'MODO ONLINE (API REST)'),
              if (pedido.id != null && pedido.id!.isNotEmpty && pedido.id != pedido.codigo)
                _buildDetailBox('ID de Comprobante (BD)', pedido.id!),
              _buildDetailBox('Cliente', pedido.cliente),
              _buildDetailBox('Fecha Generación', pedido.fechaGeneracion, hasRedCorner: true),
              if (pedido.fechaEntrega.isNotEmpty)
                _buildDetailBox('Fecha de Entrega', pedido.fechaEntrega),
              if (pedido.estadoFecha.isNotEmpty)
                _buildDetailBox('Fecha del Estado', pedido.estadoFecha),
              _buildDetailBox('Monto Total', formattedMonto),
              if (pedido.condicionVenta.isNotEmpty)
                _buildDetailBox('Condición de Venta', pedido.condicionVenta),
              if (pedido.reparto.isNotEmpty)
                _buildDetailBox('Reparto', pedido.reparto),
              _buildDetailBox('Estado', pedido.estado),

              const SizedBox(height: 12),

              // Título de la sección de Ítems / Productos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Productos / Ítems del Pedido',
                    style: AppStyles.sectionTitleStyle.copyWith(fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${pedido.items.length} ${pedido.items.length == 1 ? "ítem" : "ítems"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tabla o mensaje de Ítems
              if (pedido.items.isEmpty)
                _buildEmptyItemsCard(formattedMonto)
              else
                _buildItemsTable(displayTotal),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Tabla de productos con diseño idéntico al asistente de nuevo pedido
  Widget _buildItemsTable(double displayTotal) {
    final totalCantidades = pedido.items.fold<int>(0, (acc, it) => acc + it.cantidad);
    final totalDescuentos = pedido.items.fold<double>(0.0, (acc, it) => acc + it.descuento);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 18, color: AppColors.primaryRed),
                const SizedBox(width: 8),
                const Text(
                  'Detalle de Productos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF212121),
                  ),
                ),
                const Spacer(),
                Text(
                  '${pedido.items.length} líneas',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowHeight: 38,
              dataRowMinHeight: 46,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
              columns: const [
                DataColumn(label: Text('Código', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Descripción', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cant.', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Unitario', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Desc.', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Total', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold))),
              ],
              rows: [
                ...pedido.items.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.codigo.isNotEmpty ? item.codigo : '-', style: const TextStyle(fontSize: 12))),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          item.descripcion.isNotEmpty ? item.descripcion : 'Producto #${item.codigo}',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text('${item.cantidad}', style: const TextStyle(fontSize: 12))),
                    DataCell(Text('\$ ${item.precioUnitario.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 12))),
                    DataCell(Text(
                      item.descuento > 0 ? '\$ ${item.descuento.toStringAsFixed(2).replaceAll('.', ',')}' : '0',
                      style: const TextStyle(fontSize: 12),
                    )),
                    DataCell(Text(
                      '\$ ${item.precioTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    )),
                  ]);
                }),
                // Fila de Totales
                DataRow(cells: [
                  const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  const DataCell(SizedBox.shrink()),
                  DataCell(Text('$totalCantidades', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  const DataCell(SizedBox.shrink()),
                  DataCell(Text(
                    totalDescuentos > 0 ? '\$ ${totalDescuentos.toStringAsFixed(2).replaceAll('.', ',')}' : '0',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  )),
                  DataCell(
                    Text(
                      '\$ ${displayTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF212121)),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total de ítems: ${pedido.items.length}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
                Text(
                  'Monto Total: \$ ${displayTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tarjeta para cuando el pedido no cuenta con líneas de detalle cargadas
  Widget _buildEmptyItemsCard(String formattedMonto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: AppStyles.cardDecoration(
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
      ),
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined, size: 44, color: AppColors.textSecondary),
          const SizedBox(height: 10),
          const Text(
            'Sin líneas de productos registradas',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total comprobante: $formattedMonto',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginPill(bool isOffline) {
    final bg = isOffline ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9);
    final border = isOffline ? const Color(0xFFFFB74D) : const Color(0xFFA5D6A7);
    final color = isOffline ? const Color(0xFFE65100) : const Color(0xFF2E7D32);
    final icon = isOffline ? Icons.cloud_off : Icons.cloud_done;
    final label = isOffline ? 'OFFLINE' : 'ONLINE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBox(String label, String value, {bool hasRedCorner = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppStyles.cardDecoration(
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
      ),
      child: Stack(
        children: [
          if (hasRedCorner)
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                size: const Size(12, 12),
                painter: _RedCornerPainter(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.subtitleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? ' ' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RedCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryRed;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
