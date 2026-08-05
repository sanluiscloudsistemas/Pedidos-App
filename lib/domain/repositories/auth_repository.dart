import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Realiza el login online contra Oracle APEX y guarda el JWT devuelto.
  Future<UserEntity?> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  });

  /// Inicia sesión utilizando la autenticación biométrica local (offline / online).
  Future<UserEntity?> loginWithBiometrics();

  /// Verifica y recupera el usuario actual si existe un JWT válido (< 8 horas o .env config).
  Future<UserEntity?> getCurrentUser();

  /// Cierra la sesión activa y elimina el JWT guardado.
  Future<void> logout();

  /// Habilita o deshabilita el ingreso por biometría.
  Future<void> setBiometricEnabled(bool enabled);

  /// Indica si la biometría está habilitada para el usuario.
  Future<bool> isBiometricEnabled();
}
