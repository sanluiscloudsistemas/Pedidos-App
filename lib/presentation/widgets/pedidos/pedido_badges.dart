import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Badge visual para mostrar si el pedido es de origen OFFLINE u ONLINE
class PedidoOriginBadge extends StatelessWidget {
  final bool isOffline;

  const PedidoOriginBadge({
    super.key,
    required this.isOffline,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isOffline ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9);
    final border = isOffline ? const Color(0xFFFFB74D) : const Color(0xFFA5D6A7);
    final color = isOffline ? const Color(0xFFE65100) : const Color(0xFF2E7D32);
    final icon = isOffline ? Icons.cloud_off : Icons.cloud_done;
    final label = isOffline ? 'OFFLINE' : 'ONLINE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
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
}

/// Badge visual para mostrar el estado comercial del pedido (NUEVO, PENDIENTE, FINALIZADO)
class PedidoStatusBadge extends StatelessWidget {
  final String estado;

  const PedidoStatusBadge({
    super.key,
    required this.estado,
  });

  static Color getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'FINALIZADO':
        return const Color(0xFF2E7D32); // Verde oscuro
      case 'NUEVO':
        return const Color(0xFF1976D2); // Azul
      case 'PENDIENTE':
        return AppColors.warningOrange; // Naranja
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getEstadoColor(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        estado,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
