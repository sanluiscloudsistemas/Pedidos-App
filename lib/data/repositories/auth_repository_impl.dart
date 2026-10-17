import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../core/services/biometric_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/utils/hash_util.dart';
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
        String finalUsuario = usuario;
        try {
          final decodedToken = JwtDecoder.decode(token);
          if (decodedToken.containsKey('sub')) {
            finalUsuario = decodedToken['sub'].toString();
          }
        } catch (_) {}

        // Guardar token, timestamp de sesión, datos de usuario y hash seguro de credenciales
        await _secureStorage.saveToken(token);
        await _secureStorage.saveSessionTimestamp(DateTime.now());
        await _secureStorage.saveUserData(
          usuario: finalUsuario,
          organizacion: organizacion,
          sisorgId: response.sisorgId,
        );

        final credHash = HashUtil.hashCredentials(
          organizacion,
          finalUsuario,
          contrasenia,
        );
        await _secureStorage.saveCredentialsHash(credHash);

        _apiService.setAuthToken(token);
        _apiService.setOrganizationInfo(
          sisorgId: response.sisorgId,
          sisorgCodigo: response.sisorgCodigo,
        );

        return UserEntity(
          token: token,
          usuario: finalUsuario,
          organizacion: organizacion,
          isOfflineSession: false,
        );
      }
      return null;
    } catch (e) {
      if (_isNetworkError(e)) {
        // Fallback de autenticación offline mediante hash seguro
        final savedHash = await _secureStorage.getCredentialsHash();
        final inputHash = HashUtil.hashCredentials(
          organizacion,
          usuario,
          contrasenia,
        );

        if (savedHash != null && savedHash == inputHash) {
          final user = await getCurrentUser();
          if (user != null) {
            return user;
          } else {
            throw Exception(
              'Sin conexión a internet y la sesión local previa ha caducado. Conéctese a la red para renovar sus credenciales.',
            );
          }
        } else {
          throw Exception(
            'Sin conexión a internet y las credenciales ingresadas no coinciden con las últimas registradas en este dispositivo.',
          );
        }
      }
      rethrow;
    }
  }

  bool _isNetworkError(dynamic e) {
    if (e is DioException) {
      return e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException;
    }
    final msg = e.toString().toLowerCase();
    return msg.contains('socket') ||
        msg.contains('connection') ||
        msg.contains('network') ||
        msg.contains('timed out') ||
        msg.contains('failed host lookup');
  }

  @override
  Future<UserEntity?> loginWithBiometrics() async {
    final bool available = await isBiometricAvailable();
    if (!available) {
      throw Exception('La autenticación biométrica no está disponible en este dispositivo.');
    }

    final bool authenticated = await _biometricService.authenticate(
      reason: 'Ingresa a Preventas usando tu huella o rostro',
    );

    if (!authenticated) {
      return null;
    }

    // Para ingreso biométrico (modo offline), se valida la existencia de la sesión previa guardada
    final token = await _secureStorage.getToken();
    final userData = await _secureStorage.getUserData();

    if (token == null || token.isEmpty || userData == null) {
      throw Exception(
        'No se encontró una sesión previa válida. Ingresa con tu usuario y contraseña para iniciar.',
      );
    }

    final usuario = userData['usuario'] ?? 'Usuario';
    final organizacion = userData['organizacion'] ?? '';
    final sisorgId = userData['sisorgId'];

    _apiService.setAuthToken(token);
    if (sisorgId != null && sisorgId.isNotEmpty) {
      _apiService.setOrganizationInfo(sisorgId: sisorgId);
    }

    return UserEntity(
      token: token,
      usuario: usuario,
      organizacion: organizacion,
      isOfflineSession: true,
    );
  }

  @override
  Future<bool> isBiometricAvailable() async {
    return await _biometricService.isBiometricAvailable();
  }

  @override
  Future<bool> canUseBiometrics() async {
    final available = await isBiometricAvailable();
    if (!available) return false;

    final token = await _secureStorage.getToken();
    final userData = await _secureStorage.getUserData();
    return token != null && token.isNotEmpty && userData != null;
  }

  @override
  Future<Map<String, String>?> getSavedUserData() async {
    return await _secureStorage.getUserData();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    // Validar expiración del JWT o de la sesión local (regla de las 8hs / .env)
    bool isExpired = false;
    try {
      // 1. Si es un JWT estándar de 3 partes, validar su fecha interna de expiración
      isExpired = JwtDecoder.isExpired(token);
    } catch (_) {
      // 2. Si el token no es un JWT estándar (ej. session ID numérico o alfanumérico de Oracle APEX),
      // se valida el tiempo transcurrido desde el inicio de sesión local (defecto: 480 min / 8 hs)
      final sessionTime = await _secureStorage.getSessionTimestamp();
      if (sessionTime != null) {
        final expMinutes = int.tryParse(dotenv.maybeGet('JWT_EXPIRATION_MINUTES') ?? '480') ?? 480;
        final elapsed = DateTime.now().difference(sessionTime).inMinutes;
        isExpired = elapsed >= expMinutes;
      } else {
        isExpired = false;
      }
    }

    if (isExpired) {
      // Limpiar sesión caducada
      await _secureStorage.deleteToken();
      _apiService.setAuthToken(null);
      return null;
    }

    final userData = await _secureStorage.getUserData();
    String finalUsuario = userData?['usuario'] ?? 'Usuario';
    final organizacion = userData?['organizacion'] ?? '';
    final sisorgId = userData?['sisorgId'];

    try {
      final decodedToken = JwtDecoder.decode(token);
      if (decodedToken.containsKey('sub')) {
        finalUsuario = decodedToken['sub'].toString();
      }
    } catch (_) {}

    _apiService.setAuthToken(token);
    _apiService.setOrganizationInfo(sisorgId: sisorgId);

    return UserEntity(
      token: token,
      usuario: finalUsuario,
      organizacion: organizacion,
      isOfflineSession: true, // Indica que la sesión fue recuperada localmente
    );
  }

  @override
  Future<void> logout() async {
    // Al cerrar sesión se desvincula el token activo en memoria.
    // Se conservan el token y los datos locales para habilitar el reingreso biométrico u offline.
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

