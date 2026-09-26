import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/models/pedido_item_model.dart';
import 'pedido_badges.dart';

/// Vista en formato de tarjetas apiladas para dispositivos móviles
class PedidosCardView extends StatelessWidget {
  final List<PedidoItemModel> pedidosList;
  final void Function(PedidoItemModel) onSelectPedido;

  const PedidosCardView({
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

    return Column(
      children: pedidosList.map((p) => _buildCard(context, p)).toList(),
    );
  }

  Widget _buildCard(BuildContext context, PedidoItemModel p) {
    final formattedMonto = '\$ ${p.monto.toStringAsFixed(2).replaceAll('.', ',')}';

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
          // Código de Pedido, Origen y Pill de Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () => onSelectPedido(p),
                        child: Text(
                          'PEDIDO: ${p.codigo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1976D2),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF1976D2),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PedidoOriginBadge(isOffline: p.isOffline),
                  ],
                ),
              ),
              PedidoStatusBadge(estado: p.estado),
            ],
          ),
          const Divider(height: 12, color: AppColors.cardBorder),

          // Fecha Generación
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Fecha: ${p.fechaFormateada}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Cliente
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  p.cliente,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Monto Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monto Total:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Text(
                formattedMonto,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
