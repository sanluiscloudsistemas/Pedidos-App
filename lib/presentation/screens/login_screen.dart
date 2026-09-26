import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final _orgController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _canUseBiometrics = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSavedDataAndBiometrics();
    });
  }

  Future<void> _initSavedDataAndBiometrics() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final hasBiometrics = await authNotifier.isBiometricAvailable();
    final canBio = await authNotifier.canUseBiometrics();

    if (!mounted) return;

    setState(() {
      _canUseBiometrics = hasBiometrics || canBio;
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
              TextFormField(
                controller: _orgController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Organización',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business, color: AppColors.primaryRed),
                ),
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
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

                          // El botón con icono de huella es SOLO visible si la aplicación está offline
                          if (!_canUseBiometrics || !isOffline) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wifi_off,
                                    size: 13,
                                    color: Colors.orange.shade800,
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      'Modo Offline: Presione para capturar su huella digital',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.orange.shade900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

    final success = await authNotifier.login(
      _orgController.text.trim().toUpperCase(),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authNotifier.errorMessage ?? 'Error desconocido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}

