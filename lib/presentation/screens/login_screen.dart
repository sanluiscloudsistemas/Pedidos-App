import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/auth_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Los 'mandos a distancia' para el formulario
  final _formKey = GlobalKey<FormState>();
  
  // 2. Controladores para leer lo que escribe el usuario
  final _orgController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    // Es vital limpiar los controladores para no gastar memoria
    _orgController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso Preventas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Conectamos nuestro 'control remoto' al formulario
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _orgController,
                decoration: const InputDecoration(
                  labelText: 'Organización',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              
              // Widget que reacciona al estado de carga
              Consumer<AuthNotifier>(
                builder: (context, auth, child) {
                  if (auth.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handleLogin(context);
                        }
                      },
                      child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
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
      _orgController.text,
      _userController.text,
      _passController.text,
    );

    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido: ${authNotifier.authResponse?.session}')),
      );
      // TODO: Navegar a la pantalla de Home
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.errorMessage ?? 'Error desconocido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
