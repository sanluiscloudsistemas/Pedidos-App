import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// Importaciones de la nueva arquitectura
import 'data/datasources/remote/api_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_use_case.dart';
import 'presentation/notifiers/auth_notifier.dart';
import 'presentation/screens/login_screen.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de cargar el .env
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carga las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");
  
  // 1. Instanciamos las fuentes de datos
  final apiService = ApiService();
  
  // 2. Instanciamos los repositorios
  final authRepository = AuthRepositoryImpl(apiService);
  
  // 3. Instanciamos los casos de uso
  final loginUseCase = LoginUseCase(authRepository);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier(loginUseCase)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preventas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
