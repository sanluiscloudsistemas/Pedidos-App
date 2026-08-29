import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../notifiers/auth_notifier.dart';
import 'home_screen.dart';


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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryRed,
                child: Icon(Icons.shopping_bag, size: 40, color: Colors.white),
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

                  return SizedBox(
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
                      //child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                      child: const Text('Conectar', style: TextStyle(fontSize: 18)),
                    ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar(content: Text('Bienvenido: ${authNotifier.authResponse?.session}'+' - '+ '${authNotifier.authResponse?.usuario}')),
          SnackBar(content: Text('Bienvenido: ${authNotifier.authResponse?.usuario}')),

        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );

      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.errorMessage ?? 'Error desconocido'),
          backgroundColor: Colors.red,
        ),
      );
      //debugPrint('No conecta');
    }
  }
}
