import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CheckSessionUseCase {
  final AuthRepository repository;

  CheckSessionUseCase(this.repository);

  Future<UserEntity?> execute() {
    return repository.getCurrentUser();
  }

  Future<Map<String, String>?> getSavedUserData() {
    return repository.getSavedUserData();
  }
}
