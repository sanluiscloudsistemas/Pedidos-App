import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// Importaciones de la arquitectura de la app
import 'data/datasources/local/app_database.dart';
import 'data/datasources/remote/api_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/sync_repository_impl.dart';
import 'domain/usecases/login_use_case.dart';
import 'domain/usecases/check_session_use_case.dart';
import 'presentation/notifiers/auth_notifier.dart';
import 'presentation/notifiers/connectivity_notifier.dart';
import 'presentation/notifiers/sync_notifier.dart';
import 'presentation/screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // 1. Fuentes de datos
  final apiService = ApiService();
  final appDatabase = AppDatabase();
  
  // 2. Repositorios
  final authRepository = AuthRepositoryImpl(apiService: apiService);
  final syncRepository = SyncRepositoryImpl(db: appDatabase, apiService: apiService);
  
  // 3. Casos de uso
  final loginUseCase = LoginUseCase(authRepository);
  final checkSessionUseCase = CheckSessionUseCase(authRepository);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<AppDatabase>.value(value: appDatabase),
        ChangeNotifierProvider(create: (_) => AuthNotifier(loginUseCase, checkSessionUseCase)),
        ChangeNotifierProvider(create: (_) => ConnectivityNotifier()),
        ChangeNotifierProxyProvider<ConnectivityNotifier, SyncNotifier>(
          create: (ctx) => SyncNotifier(
            syncRepository: syncRepository,
            connectivityNotifier: Provider.of<ConnectivityNotifier>(ctx, listen: false),
          ),
          update: (ctx, connectivity, previousSync) =>
              previousSync ??
              SyncNotifier(
                syncRepository: syncRepository,
                connectivityNotifier: connectivity,
              ),
        ),
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
      home: const AuthWrapper(),
    );
  }
}
