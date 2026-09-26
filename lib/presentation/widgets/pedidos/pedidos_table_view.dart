import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/pedido_item_model.dart';
import 'pedido_badges.dart';

/// Vista en formato DataTable horizontal para pantallas medianas y grandes (Desktop / Tablet)
class PedidosTableView extends StatelessWidget {
  final List<PedidoItemModel> pedidosList;
  final void Function(PedidoItemModel) onSelectPedido;

  const PedidosTableView({
    super.key,
    required this.pedidosList,
    required this.onSelectPedido,
  });

  @override
  Widget build(BuildContext context) {
    if (pedidosList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'No se encontraron pedidos',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowHeight: 40,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 64,
        border: TableBorder.all(color: AppColors.cardBorder, width: 1),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
        columns: const [
          DataColumn(
            label: Text('Fecha Generacion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Origen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Codigo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1976D2))),
          ),
          DataColumn(
            label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            numeric: true,
            label: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          DataColumn(
            label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
        rows: pedidosList.map((p) {
          final formattedMonto = '\$${p.monto.toStringAsFixed(2).replaceAll('.', ',')}';
          return DataRow(cells: [
            DataCell(Text(p.fechaFormateada, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
            DataCell(PedidoOriginBadge(isOffline: p.isOffline)),
            DataCell(
              InkWell(
                onTap: () => onSelectPedido(p),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    p.codigo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF1976D2),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 180,
                child: Text(
                  p.cliente,
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
            DataCell(Text(formattedMonto, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
            DataCell(PedidoStatusBadge(estado: p.estado)),
          ]);
        }).toList(),
      ),
    );
  }
}
