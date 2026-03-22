import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  });

  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
