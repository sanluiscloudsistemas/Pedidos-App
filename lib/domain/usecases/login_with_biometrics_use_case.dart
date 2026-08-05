import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithBiometricsUseCase {
  final AuthRepository repository;

  LoginWithBiometricsUseCase(this.repository);

  Future<UserEntity?> execute() {
    return repository.loginWithBiometrics();
  }
}
