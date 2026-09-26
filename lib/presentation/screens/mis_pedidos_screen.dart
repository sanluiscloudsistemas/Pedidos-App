import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/datasources/remote/api_service.dart';
import '../../data/models/pedido_item_model.dart';
import '../notifiers/pedidos_notifier.dart';
import '../notifiers/sync_notifier.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/pedidos/pedidos_card_view.dart';
import '../widgets/pedidos/pedidos_filter_bar.dart';
import '../widgets/pedidos/pedidos_sync_banner.dart';
import '../widgets/pedidos/pedidos_table_view.dart';
import 'pedido_detail_screen.dart';

// Re-exportar modelos para compatibilidad con el resto del proyecto y pruebas
export '../../data/models/pedido_item_model.dart';

/// Pantalla orquestadora del listado de Pedidos (`Mis Pedidos`)
class MisPedidosScreen extends StatelessWidget {
  final String? clienteNombre;

  const MisPedidosScreen({
    super.key,
    this.clienteNombre,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = context.read<ApiService>();

    return ChangeNotifierProvider<PedidosNotifier>(
      create: (_) => PedidosNotifier(
        apiService: apiService,
        initialSearchQuery: clienteNombre,
      )..cargarPedidos(isRefresh: true),
      child: const _MisPedidosView(),
    );
  }
}

class _MisPedidosView extends StatefulWidget {
  const _MisPedidosView();

  @override
  State<_MisPedidosView> createState() => _MisPedidosViewState();
}

class _MisPedidosViewState extends State<_MisPedidosView> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final notifier = context.read<PedidosNotifier>();
    _searchController = TextEditingController(text: notifier.searchQuery);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final notifier = context.read<PedidosNotifier>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !notifier.isLoading &&
        !notifier.isLoadingMore &&
        notifier.hasMore &&
        notifier.searchQuery.isEmpty) {
      notifier.cargarMasPedidos();
    }
  }

  void _abrirDetallePedido(BuildContext context, PedidoItemModel p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PedidoDetailScreen(pedido: p),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final syncNotifier = context.watch<SyncNotifier>();
    final pedidosNotifier = context.watch<PedidosNotifier>();

    final allPedidos = pedidosNotifier.getCombinedPedidos(syncNotifier.localOrders);
    final pedidosList = pedidosNotifier.getFilteredPedidos(syncNotifier.localOrders);

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner de sincronización offline pendiente
              PedidosSyncBanner(syncNotifier: syncNotifier),

              // Barra de búsqueda, filtros de estado y resumen de totales
              PedidosFilterBar(
                searchController: _searchController,
                pedidosNotifier: pedidosNotifier,
                allPedidos: allPedidos,
                filteredCount: pedidosList.length,
                onReset: () {
                  _searchController.clear();
                  pedidosNotifier.resetFilters();
                },
              ),
              const SizedBox(height: 12),

              // Cuerpo con contenido visual (Loading, Error o Listado)
              _buildContent(context, pedidosNotifier, pedidosList),

              if (pedidosNotifier.isLoadingMore)
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

  Widget _buildContent(
    BuildContext context,
    PedidosNotifier notifier,
    List<PedidoItemModel> pedidosList,
  ) {
    if (notifier.isLoading && notifier.pedidosRemotos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64.0),
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    if (notifier.errorMessage != null && notifier.pedidosRemotos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 16.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: AppColors.primaryRed, size: 48),
              const SizedBox(height: 12),
              Text(
                notifier.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textDark),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => notifier.cargarPedidos(isRefresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return PedidosCardView(
            pedidosList: pedidosList,
            onSelectPedido: (p) => _abrirDetallePedido(context, p),
          );
        } else {
          return PedidosTableView(
            pedidosList: pedidosList,
            onSelectPedido: (p) => _abrirDetallePedido(context, p),
          );
        }
      },
    );
  }
}
