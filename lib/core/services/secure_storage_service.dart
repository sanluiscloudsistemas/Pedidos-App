import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _keyToken = 'jwt_auth_token';
  static const String _keyUser = 'saved_user_name';
  static const String _keyOrg = 'saved_org_id';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  bool get _isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Guarda el token JWT en el almacenamiento seguro cifrado (o SharedPreferences en Windows).
  Future<void> saveToken(String token) async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
    } else {
      await _storage.write(key: _keyToken, value: token);
    }
  }

  /// Recupera el token JWT guardado.
  Future<String?> getToken() async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } else {
      return await _storage.read(key: _keyToken);
    }
  }

  /// Elimina el token JWT almacenado.
  Future<void> deleteToken() async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
    } else {
      await _storage.delete(key: _keyToken);
    }
  }

  /// Guarda datos básicos del usuario para persistir la sesión local.
  Future<void> saveUserData({
    required String usuario,
    required String organizacion,
  }) async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, usuario);
      await prefs.setString(_keyOrg, organizacion);
    } else {
      await _storage.write(key: _keyUser, value: usuario);
      await _storage.write(key: _keyOrg, value: organizacion);
    }
  }

  /// Obtiene los datos del usuario guardados localmente.
  Future<Map<String, String>?> getUserData() async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      final usuario = prefs.getString(_keyUser);
      final org = prefs.getString(_keyOrg);
      if (usuario != null && org != null) {
        return {'usuario': usuario, 'organizacion': org};
      }
      return null;
    } else {
      final usuario = await _storage.read(key: _keyUser);
      final org = await _storage.read(key: _keyOrg);
      if (usuario != null && org != null) {
        return {'usuario': usuario, 'organizacion': org};
      }
      return null;
    }
  }

  /// Guarda la preferencia de autenticación biométrica del usuario.
  Future<void> setBiometricEnabled(bool enabled) async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyBiometricEnabled, enabled);
    } else {
      await _storage.write(
          key: _keyBiometricEnabled, value: enabled ? 'true' : 'false');
    }
  }

  /// Verifica si la autenticación biométrica está habilitada.
  Future<bool> isBiometricEnabled() async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyBiometricEnabled) ?? false;
    } else {
      final val = await _storage.read(key: _keyBiometricEnabled);
      return val == 'true';
    }
  }

  /// Borra toda la información guardada al cerrar sesión.
  Future<void> clearAll() async {
    if (_isWindows) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUser);
      await prefs.remove(_keyOrg);
      await prefs.remove(_keyBiometricEnabled);
    } else {
      await _storage.deleteAll();
    }
  }
}
