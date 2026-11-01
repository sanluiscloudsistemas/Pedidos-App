import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/connectivity_notifier.dart';
import 'home_screen.dart';
import 'biometric_auth_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _orgController;
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _canUseBiometrics = false;
  bool _hasSavedSession = false;
  String? _savedUsername;

  String? _getEnvOrg() {
    try {
      final val = dotenv.maybeGet('SISORG_CODIGO')?.trim();
      return (val != null && val.isNotEmpty) ? val : null;
    } catch (_) {
      return null;
    }
  }

  bool get _hasConfiguredOrg => _getEnvOrg() != null;

  @override
  void initState() {
    super.initState();
    _orgController = TextEditingController(text: _getEnvOrg() ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSavedDataAndBiometrics();
    });
  }

  Future<void> _initSavedDataAndBiometrics() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final hasBiometrics = await authNotifier.isBiometricAvailable();
    final canBio = await authNotifier.canUseBiometrics();
    final savedUser = await authNotifier.getSavedUserData();

    if (!mounted) return;

    setState(() {
      _canUseBiometrics = hasBiometrics || canBio;
      _savedUsername = savedUser?['usuario'];
      _hasSavedSession = savedUser != null && (_savedUsername?.isNotEmpty ?? false);
    });
  }

  @override
  void dispose() {
    _orgController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: const Text('Ingreso Preventas', style: AppStyles.appBarTitleStyle),
        actions: [
          Builder(
            builder: (ctx) {
              ConnectivityNotifier? conn;
              try {
                conn = Provider.of<ConnectivityNotifier>(ctx);
              } catch (_) {
                conn = null;
              }
              if (conn == null) return const SizedBox.shrink();
              final isConnected = conn.isConnected;
              return IconButton(
                icon: Icon(
                  Icons.cloud,
                  color: isConnected ? const Color(0xFF4CAF50) : Colors.white,
                ),
                tooltip: isConnected
                    ? 'Conexión activa a Internet'
                    : 'Sin conexión a Internet (Modo Offline)',
                onPressed: () {
                  if (kDebugMode) {
                    conn?.toggleManualSimulatedState();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'resources/Logo_SLC_ico.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!_hasConfiguredOrg) ...[
                TextFormField(
                  controller: _orgController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Organización',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business, color: AppColors.primaryRed),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _userController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: AppColors.primaryRed),
                ),
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primaryRed),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              Consumer<AuthNotifier>(
                builder: (context, auth, child) {
                  if (auth.isLoading) {
                    return const CircularProgressIndicator(color: AppColors.primaryRed);
                  }

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: AppStyles.primaryButtonStyle.copyWith(
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handleLogin(context);
                            }
                          },
                          child: const Text('Conectar', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      Builder(
                        builder: (ctx) {
                          ConnectivityNotifier? conn;
                          try {
                            conn = Provider.of<ConnectivityNotifier>(ctx);
                          } catch (_) {
                            conn = null;
                          }
                          final isOffline = conn != null ? !conn.isConnected : false;

                          // Las opciones offline son visibles si la aplicación está offline o se detectó caída de servidor
                          if (!isOffline && !_canUseBiometrics && !_hasSavedSession) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              if (isOffline) ...[
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.orange.shade300),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cloud_off,
                                        size: 16,
                                        color: Colors.orange.shade800,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Modo Offline activo (sin conexión con el servidor)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (_canUseBiometrics && isOffline) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primaryRed,
                                      side: const BorderSide(
                                        color: AppColors.primaryRed,
                                        width: 1.8,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      elevation: 1,
                                    ),
                                    icon: const Icon(
                                      Icons.fingerprint,
                                      size: 30,
                                      color: AppColors.primaryRed,
                                    ),
                                    label: const Text(
                                      'Ingresar con Huella Digital',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const BiometricAuthScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                              if (_hasSavedSession && isOffline) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primaryRed,
                                      side: const BorderSide(
                                        color: AppColors.primaryRed,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.account_circle,
                                      size: 26,
                                      color: AppColors.primaryRed,
                                    ),
                                    label: Text(
                                      _savedUsername != null && _savedUsername!.isNotEmpty
                                          ? 'Ingresar como $_savedUsername (Modo Offline)'
                                          : 'Ingresar con Sesión Guardada (Modo Offline)',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                    onPressed: () => _handleSavedSessionLogin(context),
                                  ),
                                ),
                              ],
                              if (isOffline) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Los pedidos creados en modo offline se sincronizarán al recuperar la conexión.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange.shade800,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    ConnectivityNotifier? conn;
    try {
      conn = Provider.of<ConnectivityNotifier>(context, listen: false);
    } catch (_) {
      conn = null;
    }

    final org = _getEnvOrg() ?? _orgController.text.trim().toUpperCase();

    final success = await authNotifier.login(
      org,
      _userController.text.trim().toUpperCase(),
      _passController.text,
    );

    if (success) {
      if (context.mounted) {
        final isOffline = authNotifier.currentUser?.isOfflineSession ?? false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isOffline
                  ? 'Bienvenido: ${authNotifier.currentUser?.usuario} (Sesión Offline)'
                  : 'Bienvenido: ${authNotifier.currentUser?.usuario}',
            ),
            backgroundColor: isOffline ? Colors.orange.shade800 : null,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (context.mounted) {
        final errorMsg = authNotifier.errorMessage ?? 'Error desconocido';
        final isServerDown = errorMsg.toLowerCase().contains('servidor') ||
            errorMsg.toLowerCase().contains('conexión') ||
            errorMsg.toLowerCase().contains('offline');

        if (isServerDown) {
          conn?.setServerUnreachable(true);
          await _initSavedDataAndBiometrics();
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: isServerDown ? Colors.orange.shade800 : Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  void _handleSavedSessionLogin(BuildContext context) async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final success = await authNotifier.loginWithSavedSession();

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bienvenido: ${authNotifier.currentUser?.usuario} (Sesión Offline Guardada)',
          ),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authNotifier.errorMessage ?? 'No se pudo restaurar la sesión guardada.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}

