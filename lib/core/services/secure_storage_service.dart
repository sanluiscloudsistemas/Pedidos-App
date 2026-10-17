import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _keyToken = 'jwt_auth_token';
  static const String _keyUser = 'saved_user_name';
  static const String _keyOrg = 'saved_org_id';
  static const String _keySisorgId = 'saved_sisorg_id';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyCredHash = 'saved_cred_hash';
  static const String _keySessionTime = 'saved_session_time';

  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  bool get _isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(aOptions: _androidOptions);

  /// Guarda el token JWT/sesión en almacenamiento seguro y SharedPreferences como respaldo.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    if (!_isWindows) {
      try {
        await _storage.write(key: _keyToken, value: token);
      } catch (_) {}
    }
  }

  /// Recupera el token JWT/sesión guardado.
  Future<String?> getToken() async {
    if (!_isWindows) {
      try {
        final val = await _storage.read(key: _keyToken);
        if (val != null && val.isNotEmpty) return val;
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Elimina el token almacenado.
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    if (!_isWindows) {
      try {
        await _storage.delete(key: _keyToken);
      } catch (_) {}
    }
  }

  /// Guarda la marca de tiempo de inicio de sesión.
  Future<void> saveSessionTimestamp(DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySessionTime, dt.toIso8601String());
  }

  /// Obtiene la marca de tiempo de inicio de sesión.
  Future<DateTime?> getSessionTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keySessionTime);
    if (str != null && str.isNotEmpty) {
      return DateTime.tryParse(str);
    }
    return null;
  }

  /// Guarda datos básicos del usuario para persistir la sesión local.
  Future<void> saveUserData({
    required String usuario,
    required String organizacion,
    String? sisorgId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, usuario);
    await prefs.setString(_keyOrg, organizacion);
    if (sisorgId != null && sisorgId.isNotEmpty) {
      await prefs.setString(_keySisorgId, sisorgId);
    }

    if (!_isWindows) {
      try {
        await _storage.write(key: _keyUser, value: usuario);
        await _storage.write(key: _keyOrg, value: organizacion);
        if (sisorgId != null && sisorgId.isNotEmpty) {
          await _storage.write(key: _keySisorgId, value: sisorgId);
        }
      } catch (_) {}
    }
  }

  /// Obtiene los datos del usuario guardados localmente.
  Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString(_keyUser);
    final org = prefs.getString(_keyOrg);
    final sisorgId = prefs.getString(_keySisorgId);

    if (usuario != null && org != null) {
      return {
        'usuario': usuario,
        'organizacion': org,
        if (sisorgId != null) 'sisorgId': sisorgId,
      };
    }

    if (!_isWindows) {
      try {
        final u = await _storage.read(key: _keyUser);
        final o = await _storage.read(key: _keyOrg);
        final s = await _storage.read(key: _keySisorgId);
        if (u != null && o != null) {
          return {
            'usuario': u,
            'organizacion': o,
            if (s != null) 'sisorgId': s,
          };
        }
      } catch (_) {}
    }
    return null;
  }

  /// Guarda la preferencia de autenticación biométrica del usuario.
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, enabled);
    if (!_isWindows) {
      try {
        await _storage.write(
            key: _keyBiometricEnabled, value: enabled ? 'true' : 'false');
      } catch (_) {}
    }
  }

  /// Verifica si la autenticación biométrica está habilitada.
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final prefVal = prefs.getBool(_keyBiometricEnabled);
    if (prefVal != null) return prefVal;

    if (!_isWindows) {
      try {
        final val = await _storage.read(key: _keyBiometricEnabled);
        return val == 'true';
      } catch (_) {}
    }
    return false;
  }

  /// Guarda el hash seguro de las credenciales para permitir login offline.
  Future<void> saveCredentialsHash(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCredHash, hash);
    if (!_isWindows) {
      try {
        await _storage.write(key: _keyCredHash, value: hash);
      } catch (_) {}
    }
  }

  /// Recupera el hash de credenciales almacenado.
  Future<String?> getCredentialsHash() async {
    final prefs = await SharedPreferences.getInstance();
    final prefVal = prefs.getString(_keyCredHash);
    if (prefVal != null && prefVal.isNotEmpty) return prefVal;

    if (!_isWindows) {
      try {
        final val = await _storage.read(key: _keyCredHash);
        if (val != null && val.isNotEmpty) return val;
      } catch (_) {}
    }
    return null;
  }

  /// Elimina el hash de credenciales.
  Future<void> deleteCredentialsHash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCredHash);
    if (!_isWindows) {
      try {
        await _storage.delete(key: _keyCredHash);
      } catch (_) {}
    }
  }

  /// Borra toda la información guardada al cerrar sesión.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyOrg);
    await prefs.remove(_keySisorgId);
    await prefs.remove(_keyBiometricEnabled);
    await prefs.remove(_keyCredHash);
    await prefs.remove(_keySessionTime);

    if (!_isWindows) {
      try {
        await _storage.deleteAll();
      } catch (_) {}
    }
  }
}
