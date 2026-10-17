import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../notifiers/auth_notifier.dart';
import 'home_screen.dart';

/// Pantalla dedicada para la captura y validación biométrica de la huella digital
/// cuando el dispositivo opera en modo fuera de línea (Offline).
class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isAuthenticating = false;
  String? _errorMessage;
  bool _isSuccess = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Dispara automáticamente el escaneo biométrico al montar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBiometricScan();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _startBiometricScan() async {
    if (_isAuthenticating || _isSuccess) return;

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final success = await authNotifier.loginWithBiometrics();

    if (!mounted) return;

    if (success) {
      setState(() {
        _isAuthenticating = false;
        _isSuccess = true;
      });

      // Breve pausa para mostrar la retroalimentación positiva al usuario
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        _isAuthenticating = false;
        _errorMessage = authNotifier.errorMessage ??
            'No se reconoció la huella. Por favor intente nuevamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: const Text(
          'Autenticación Biométrica',
          style: AppStyles.appBarTitleStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Región interactiva de captura de huella
              GestureDetector(
                onTap: _isAuthenticating ? null : _startBiometricScan,
                child: ScaleTransition(
                  scale: _isAuthenticating
                      ? _scaleAnimation
                      : const AlwaysStoppedAnimation(1.0),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isSuccess
                          ? Colors.green.shade50
                          : (_errorMessage != null
                              ? Colors.red.shade50
                              : AppColors.primaryRed.withOpacity(0.08)),
                      border: Border.all(
                        color: _isSuccess
                            ? Colors.green
                            : (_errorMessage != null
                                ? AppColors.primaryRed
                                : AppColors.primaryRed),
                        width: 3.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isSuccess
                                  ? Colors.green
                                  : AppColors.primaryRed)
                              .withOpacity(0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isSuccess
                          ? const Icon(
                              Icons.check_circle,
                              size: 70,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.fingerprint,
                              size: 75,
                              color: _errorMessage != null
                                  ? AppColors.primaryRed
                                  : AppColors.primaryRed,
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Textos descriptivos de instrucción
              Text(
                _isSuccess
                    ? '¡Huella verificada con éxito!'
                    : (_isAuthenticating
                        ? 'Esperando lectura de huella...'
                        : 'Región de captura de huella'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _isSuccess
                    ? 'Iniciando sesión en modo offline...'
                    : 'Presione sobre el sensor de huella digital de su dispositivo para validar su identidad y acceder al sistema.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // Mensaje de error si la huella falló
              if (_errorMessage != null && !_isSuccess) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.primaryRed, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              if (_isAuthenticating)
                const CircularProgressIndicator(color: AppColors.primaryRed),

              const Spacer(),

              // Botón de reintento manual
              if (!_isSuccess) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: AppStyles.primaryButtonStyle.copyWith(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    onPressed:
                        _isAuthenticating ? null : _startBiometricScan,
                    icon: const Icon(Icons.fingerprint, size: 24),
                    label: Text(
                      _errorMessage != null
                          ? 'Reintentar captura de huella'
                          : 'Capturar huella digital',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Volver al ingreso con contraseña',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
