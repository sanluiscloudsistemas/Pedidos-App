import '../datasources/remote/api_service.dart';
import '../models/dto/auth_response_dto.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<AuthResponse> login(String organizacion, String usuario, String contrasenia) async {
    // Aquí podrías añadir lógica adicional como validar antes de enviar,
    // o guardar la sesión en una base de datos local (Drift) si el resultado es exitoso.
    return await _apiService.login(
      organizacion: organizacion,
      usuario: usuario,
      contrasenia: contrasenia,
    );
  }
}
