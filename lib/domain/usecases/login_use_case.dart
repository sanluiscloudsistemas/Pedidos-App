import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity?> execute({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  }) {
    return repository.login(
      organizacion: organizacion,
      usuario: usuario,
      contrasenia: contrasenia,
    );
  }
}
