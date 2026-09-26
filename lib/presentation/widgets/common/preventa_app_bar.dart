import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/connectivity_notifier.dart';
import '../../screens/login_screen.dart';

/// Cabecera (AppBar) unificada reutilizable en todas las pantallas de la aplicación.
/// Incluye soporte para apertura de Drawer lateral, Breadcrumb retroceso posicionado a la derecha del menú hamburguesa,
/// indicador dinámico de conexión a Internet (Verde con conexión, Blanco sin conexión),
/// acciones globales de ayuda/nube y el menú de perfil de usuario ("Mi Perfil" / "Cerrar Sesión").
class PreventaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool isConnected;
  final VoidCallback? onBackPressed;
  final List<Widget>? extraActions;

  const PreventaAppBar({
    super.key,
    this.title = 'P E D I D O S - I A',
    this.showBackButton = false,
    this.isConnected = true,
    this.onBackPressed,
    this.extraActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _handleLogout(BuildContext context) async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    await authNotifier.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showProfileDialog(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final user = authNotifier.authResponse?.usuario ?? 'Preventista';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.person, color: AppColors.primaryRed),
            SizedBox(width: 8),
            Text('Mi Perfil'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario Activo: $user', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Rol: Preventista de Campo'),
            Text('Estado Red: ${isConnected ? "Conectado (Online)" : "Sin Conexión (Offline)"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = showBackButton || Navigator.canPop(context);

    // Obtener estado de conectividad en tiempo real desde Provider (con fallback a la propiedad isConnected)
    final connectivityNotifier = Provider.of<ConnectivityNotifier?>(context);
    final activeConnected = connectivityNotifier?.isConnected ?? isConnected;

    // Indicador de conexión reutilizando el icono de download/nube:
    // Verde (0xFF4CAF50) cuando hay conexión y Blanco (Colors.white) cuando no hay conexión.
    final connectionColor = activeConnected ? const Color(0xFF4CAF50) : Colors.white;
    final connectionTooltip = activeConnected
        ? 'Conectado a Internet (Sincronización activa)'
        : 'Sin conexión a Internet (Modo Offline)';

    return AppBar(
      backgroundColor: AppColors.primaryRed,
      elevation: 1,
      titleSpacing: 0,
      leadingWidth: canPop ? 100 : 50,
      leading: Builder(
        builder: (scaffoldContext) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Botón de Menú Hamburguesa (SIEMPRE a la izquierda)
              Container(
                width: 36,
                height: 36,
                margin: EdgeInsets.only(
                  left: 6,
                  top: 8,
                  bottom: 8,
                  right: canPop ? 3 : 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Menú Preventas',
                  icon: const Icon(Icons.menu, color: Colors.white, size: 18),
                  onPressed: () {
                    Scaffold.of(scaffoldContext).openDrawer();
                  },
                ),
              ),
              // 2. Botón de Retroceso / Breadcrumb (A LA DERECHA del menú hamburguesa)
              if (canPop)
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(left: 3, top: 8, bottom: 8, right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.darkRed,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Volver atrás',
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    onPressed: () {
                      if (onBackPressed != null) {
                        onBackPressed!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
      title: Text(
        title,
        style: AppStyles.appBarTitleStyle,
      ),
      actions: [
        if (extraActions != null) ...extraActions!,
        
        // Indicador de conexión reutilizando el icono de download / sincronización
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(),
          tooltip: connectionTooltip,
          icon: Icon(
            Icons.cloud_download_outlined,
            color: connectionColor,
            size: 20,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  activeConnected
                      ? 'Conexión activa: Sincronizando datos con el servidor...'
                      : 'Modo Offline: Sin conexión a Internet. Los cambios se guardarán localmente.',
                ),
                duration: const Duration(seconds: 3),
                action: kDebugMode
                    ? SnackBarAction(
                        label: 'Probar Offline (Debug)',
                        textColor: Colors.amber,
                        onPressed: () {
                          connectivityNotifier?.toggleManualSimulatedState();
                        },
                      )
                    : null,
              ),
            );
          },
        ),
        
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(),
          tooltip: 'Mensajes',
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
          onPressed: () {},
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.help_outline, color: Colors.white, size: 16),
            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 12),
          ],
        ),
        const SizedBox(width: 4),
        // Menú de Perfil de Usuario ("Mi Perfil" / "Cerrar Sesión")
        PopupMenuButton<String>(
          tooltip: 'Opciones de Usuario',
          padding: EdgeInsets.zero,
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person_outline, color: Colors.white, size: 18),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
            ],
          ),
          onSelected: (value) {
            if (value == 'profile') {
              _showProfileDialog(context);
            } else if (value == 'logout') {
              _handleLogout(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, color: AppColors.primaryRed, size: 18),
                  SizedBox(width: 8),
                  Text('Mi Perfil'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}
