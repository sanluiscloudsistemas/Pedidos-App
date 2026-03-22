import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/api_service.dart';
import '../models/dto/auth_response_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

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

      if (response.session != null) {
        return UserEntity(
          session: response.session!,
          usuario: usuario,
          organizacion: organizacion,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // TODO: Implementar persistencia de sesión local (ej: Secure Storage)
    return null;
  }

  @override
  Future<void> logout() async {
    // TODO: Limpiar sesión local
  }
}
