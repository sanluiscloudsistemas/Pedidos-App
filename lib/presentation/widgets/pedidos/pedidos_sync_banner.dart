import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../notifiers/sync_notifier.dart';

/// Banner de notificación para pedidos pendientes de sincronización local (Offline-First)
class PedidosSyncBanner extends StatelessWidget {
  final SyncNotifier syncNotifier;

  const PedidosSyncBanner({
    super.key,
    required this.syncNotifier,
  });

  @override
  Widget build(BuildContext context) {
    if (syncNotifier.pendingSyncCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.warningOrange),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: AppColors.warningOrange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Hay ${syncNotifier.pendingSyncCount} pedido(s) guardado(s) offline pendiente(s) de sincronizar.',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFE65100),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (syncNotifier.isSyncing)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.warningOrange,
              ),
            )
          else
            TextButton(
              onPressed: () {
                if (!syncNotifier.connectivityNotifier.isConnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No es posible sincronizar: el dispositivo se encuentra offline o sin conexión.',
                      ),
                      backgroundColor: AppColors.warningOrange,
                    ),
                  );
                  return;
                }
                syncNotifier.syncPendingOrdersNow();
              },
              child: Text(
                syncNotifier.connectivityNotifier.isConnected ? 'Sincronizar' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: syncNotifier.connectivityNotifier.isConnected
                      ? AppColors.primaryRed
                      : AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
