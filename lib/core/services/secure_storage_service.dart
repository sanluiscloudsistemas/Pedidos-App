import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _keyToken = 'jwt_auth_token';
  static const String _keyUser = 'saved_user_name';
  static const String _keyOrg = 'saved_org_id';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Guarda el token JWT en el almacenamiento seguro cifrado.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Recupera el token JWT guardado.
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Elimina el token JWT almacenado.
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// Guarda datos básicos del usuario para persistir la sesión local.
  Future<void> saveUserData({
    required String usuario,
    required String organizacion,
  }) async {
    await _storage.write(key: _keyUser, value: usuario);
    await _storage.write(key: _keyOrg, value: organizacion);
  }

  /// Obtiene los datos del usuario guardados localmente.
  Future<Map<String, String>?> getUserData() async {
    final usuario = await _storage.read(key: _keyUser);
    final org = await _storage.read(key: _keyOrg);
    if (usuario != null && org != null) {
      return {'usuario': usuario, 'organizacion': org};
    }
    return null;
  }

  /// Guarda la preferencia de autenticación biométrica del usuario.
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
        key: _keyBiometricEnabled, value: enabled ? 'true' : 'false');
  }

  /// Verifica si la autenticación biométrica está habilitada.
  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _keyBiometricEnabled);
    return val == 'true';
  }

  /// Borra toda la información guardada al cerrar sesión.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
