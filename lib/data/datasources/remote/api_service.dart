import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/dto/auth_response_dto.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('BASE_URL'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<AuthResponse> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  }) async {
    try {
      final response = await _dio.post(
        dotenv.get('LOGIN_PATH'),
        data: {
          'organizacion': organizacion,
          'usuario': usuario,
          'contrasenia': contrasenia,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Manejo de errores de red o servidor
      throw Exception('Error en la autenticación: ${e.message}');
    }
  }
}
