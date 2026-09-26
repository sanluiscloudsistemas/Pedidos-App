import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/models/pedido_item_model.dart';
import '../../notifiers/pedidos_notifier.dart';
import '../common/list_header_summary.dart';
import '../common/search_filter_bar.dart';

/// Barra de búsqueda, panel desplegable de filtros y encabezado con contador de resultados
class PedidosFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final PedidosNotifier pedidosNotifier;
  final List<PedidoItemModel> allPedidos;
  final int filteredCount;
  final VoidCallback onReset;

  const PedidosFilterBar({
    super.key,
    required this.searchController,
    required this.pedidosNotifier,
    required this.allPedidos,
    required this.filteredCount,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final finalizadoCount = allPedidos
        .where((p) => p.estado.toUpperCase() == 'FINALIZADO')
        .length;
    final nuevoCount = allPedidos
        .where((p) => p.estado.toUpperCase() == 'NUEVO')
        .length;
    final pendienteCount = allPedidos
        .where((p) => p.estado.toUpperCase() == 'PENDIENTE')
        .length;
    final offlineCount = allPedidos.where((p) => p.isOffline).length;
    final onlineCount = allPedidos.where((p) => !p.isOffline).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Buscador de Pedidos / Cliente
        SearchFilterBar(
          controller: searchController,
          hintText: 'Buscar pedido por cliente o código...',
          onSearch: () => pedidosNotifier.setSearchQuery(searchController.text),
        ),
        const SizedBox(height: 12),

        // Sección Filtros: Estado
        Container(
          decoration: AppStyles.cardDecoration(
            backgroundColor: Colors.white,
            borderColor: AppColors.cardBorder,
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            shape: const Border(),
            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            title: Row(
              children: const [
                Icon(Icons.check_box_outlined, size: 18, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Text(
                  'Estado',
                  style: AppStyles.sectionTitleStyle,
                ),
              ],
            ),
            children: [
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'FINALIZADO ($finalizadoCount)',
                  style: const TextStyle(fontSize: 13),
                ),
                value: pedidosNotifier.filterFinalizado,
                onChanged: (val) => pedidosNotifier.setFilterFinalizado(val ?? false),
              ),
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'NUEVO ($nuevoCount)',
                  style: const TextStyle(fontSize: 13),
                ),
                value: pedidosNotifier.filterNuevo,
                onChanged: (val) => pedidosNotifier.setFilterNuevo(val ?? false),
              ),
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'PENDIENTE ($pendienteCount)',
                  style: const TextStyle(fontSize: 13),
                ),
                value: pedidosNotifier.filterPendiente,
                onChanged: (val) => pedidosNotifier.setFilterPendiente(val ?? false),
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                  children: [
                    const Icon(Icons.cloud_off, size: 16, color: Color(0xFFE65100)),
                    const SizedBox(width: 6),
                    Text(
                      'MODO OFFLINE ($offlineCount)',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                value: pedidosNotifier.filterSoloOffline,
                onChanged: (_) => pedidosNotifier.toggleFilterSoloOffline(),
              ),
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                  children: [
                    const Icon(Icons.cloud_done, size: 16, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 6),
                    Text(
                      'MODO ONLINE / API ($onlineCount)',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                value: pedidosNotifier.filterSoloOnline,
                onChanged: (_) => pedidosNotifier.toggleFilterSoloOnline(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Recuento total de filas y botón restablecer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListHeaderSummary(
              count: filteredCount,
              label: 'pedidos',
            ),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
              label: const Text(
                'Restablecer',
                style: TextStyle(color: AppColors.textDark, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
