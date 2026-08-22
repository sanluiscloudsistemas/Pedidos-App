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

      final Map<String, dynamic> payload = {
        'organizacion': organizacion,
        'usuario': usuario,
        'contrasenia': contrasenia,
      };

      // Incluir exp_minutos solo si fue configurado diferente a 480 para compatibilidad
      if (expMinutos != 480) {
        payload['exp_minutos'] = expMinutos;
      }

      final response = await _dio.post(
        dotenv.get('LOGIN_PATH'),
        data: payload,
      );

      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.jwtToken != null) {
        setAuthToken(authResponse.jwtToken);
      }

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        // HTTP 555 en ORDS es un error de recurso PL/SQL o error retornado por la BD
        if (statusCode == 555 || statusCode == 401 || statusCode == 500) {
          if (responseData is Map<String, dynamic>) {
            final message = responseData['message'] ?? responseData['resultado'] ?? responseData['error'];
            if (message != null && message.toString().isNotEmpty) {
              throw Exception('Error $statusCode de APEX: $message');
            }
          }
          if (statusCode == 555) {
            throw Exception(
                'Error 555 en ORDS: Ocurrió un error en el procedimiento PL/SQL de Oracle APEX. Verifique si el script SQL ya fue aplicado por el DBA o si las credenciales son válidas.');
          }
        }
      }
      throw Exception('Error en la autenticación: ${e.message}');
    }
  }

  Future<Response> postPedido(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        '/mobile/pedidos',
        data: payload,
      );
    } on DioException catch (e) {
      throw Exception('Error al enviar pedido: ${e.message}');
    }
  }

  Future<Response> postCliente(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        '/mobile/clientes',
        data: payload,
      );
    } on DioException catch (e) {
      throw Exception('Error al enviar cliente: ${e.message}');
    }
  }

  Future<Response> postFaltante(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        '/mobile/faltantes',
        data: payload,
      );
    } on DioException catch (e) {
      throw Exception('Error al enviar faltante: ${e.message}');
    }
  }
}
