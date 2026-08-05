import 'package:jwt_decoder/jwt_decoder.dart';
import '../../core/services/biometric_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/api_service.dart';
import '../models/dto/auth_response_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SecureStorageService _secureStorage;
  final BiometricService _biometricService;

  AuthRepositoryImpl({
    required ApiService apiService,
    SecureStorageService? secureStorage,
    BiometricService? biometricService,
  })  : _apiService = apiService,
        _secureStorage = secureStorage ?? SecureStorageService(),
        _biometricService = biometricService ?? BiometricService();

  @override
  Future<UserEntity?> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  }) async {
    try {
      final AuthResponse response = await _apiService.login(
        organizacion: organizacion,
        usuario: usuario,
        contrasenia: contrasenia,
      );

      final token = response.jwtToken;
      if (token != null && token.isNotEmpty) {
        // Guardar token y credenciales en SecureStorage
        await _secureStorage.saveToken(token);
        await _secureStorage.saveUserData(
          usuario: usuario,
          organizacion: organizacion,
        );

        _apiService.setAuthToken(token);

        return UserEntity(
          token: token,
          usuario: usuario,
          organizacion: organizacion,
          isOfflineSession: false,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> loginWithBiometrics() async {
    final bool isEnabled = await _secureStorage.isBiometricEnabled();
    if (!isEnabled) {
      throw Exception('La autenticación biométrica no está activada en la app.');
    }

    final bool authenticated = await _biometricService.authenticate(
      reason: 'Ingresa a Preventas usando tu huella o rostro',
    );

    if (!authenticated) {
      return null;
    }

    // Verificar si existe un JWT guardado y aún es válido
    final user = await getCurrentUser();
    if (user == null) {
      throw Exception(
          'La sesión de 8 horas ha expirado o no existe. Ingresa con tu usuario y contraseña.');
    }

    return user;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    // Validar expiración del JWT (regla de las 8hs / .env)
    bool isExpired = true;
    try {
      isExpired = JwtDecoder.isExpired(token);
    } catch (_) {
      // Si el formato del token no es un JWT estándar, expira por seguridad
      isExpired = true;
    }

    if (isExpired) {
      // Limpiar sesión caducada
      await _secureStorage.deleteToken();
      _apiService.setAuthToken(null);
      return null;
    }

    final userData = await _secureStorage.getUserData();
    final usuario = userData?['usuario'] ?? 'Usuario';
    final organizacion = userData?['organizacion'] ?? '';

    _apiService.setAuthToken(token);

    return UserEntity(
      token: token,
      usuario: usuario,
      organizacion: organizacion,
      isOfflineSession: true, // Indica que la sesión fue recuperada localmente
    );
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearAll();
    _apiService.setAuthToken(null);
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.setBiometricEnabled(enabled);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await _secureStorage.isBiometricEnabled();
  }
}
