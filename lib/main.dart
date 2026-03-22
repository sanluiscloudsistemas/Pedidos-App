import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'presentation/notifiers/auth_notifier.dart';
import 'presentation/screens/login_screen.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de cargar el .env
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carga las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
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
      title: 'Preventas Oracle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
