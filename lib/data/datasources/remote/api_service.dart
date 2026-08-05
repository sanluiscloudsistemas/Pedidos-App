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

  /// Asigna el token JWT en las cabeceras de todas las solicitudes de Dio.
  void setAuthToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<AuthResponse> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  }) async {
    try {
      final int expMinutos = int.tryParse(
              dotenv.maybeGet('JWT_EXPIRATION_MINUTES') ?? '480') ??
          480;

      final response = await _dio.post(
        dotenv.get('LOGIN_PATH'),
        data: {
          'organizacion': organizacion,
          'usuario': usuario,
          'contrasenia': contrasenia,
          'exp_minutos': expMinutos,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.jwtToken != null) {
        setAuthToken(authResponse.jwtToken);
      }

      return authResponse;
    } on DioException catch (e) {
      throw Exception('Error en la autenticación: ${e.message}');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw Exception('Error en petición POST a $path: ${e.message}');
    }
  }
}
