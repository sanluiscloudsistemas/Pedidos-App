import '../repositories/auth_repository.dart';

/// Caso de uso para cerrar la sesión activa del usuario y limpiar credenciales
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}
