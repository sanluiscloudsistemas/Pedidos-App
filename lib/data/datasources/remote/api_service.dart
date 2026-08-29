import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/dto/auth_response_dto.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('BASE_URL'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  String? _authToken;
  String? _sisorgId;
  String? _sisorgCodigo;

  String? get currentAuthToken => _authToken;
  String? get currentSisorgId => _sisorgId;
  String? get currentSisorgCodigo => _sisorgCodigo;

  /// Asigna el token JWT en las cabeceras de todas las solicitudes de Dio.
  void setAuthToken(String? token) {
    _authToken = token;
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Establece explícitamente el sisorg_id y/o sisorg_codigo obtenida en login o almacenamiento.
  void setOrganizationInfo({String? sisorgId, String? sisorgCodigo}) {
    if (sisorgId != null && sisorgId.isNotEmpty) {
      _sisorgId = sisorgId;
    }
    if (sisorgCodigo != null && sisorgCodigo.isNotEmpty) {
      _sisorgCodigo = sisorgCodigo;
    }
  }

  /// Extrae el SISORG_ID o SISORG_CODIGO desde los claims del payload del token JWT.
  String? getSisorgIdFromToken() {
    if (_authToken == null || _authToken!.isEmpty) return null;
    try {
      final parts = _authToken!.split('.');
      if (parts.length != 3) return null;
      final normalized = base64.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(payloadString);
      if (payload is Map<String, dynamic>) {
        final val = payload['sisorg_id'] ??
            payload['SISORG_ID'] ??
            payload['sisorg_codigo'] ??
            payload['SISORG_CODIGO'] ??
            payload['organizacion_id'] ??
            payload['organizacion'];
        if (val != null && val.toString().isNotEmpty) {
          return val.toString();
        }
      }
    } catch (_) {}
    return null;
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
        'organizacion': organizacion.trim().toUpperCase(),
        'usuario': usuario.trim().toUpperCase(),
        'contrasenia': contrasenia,
      };

      if (expMinutos != 480) {
        payload['exp_minutos'] = expMinutos;
      }

      final response = await _dio.post(
        ApiEndpoints.login,
        data: payload,
      );

      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.jwtToken != null) {
        setAuthToken(authResponse.jwtToken);
      }

      if (authResponse.sisorgId != null) {
        _sisorgId = authResponse.sisorgId;
      }
      if (authResponse.sisorgCodigo != null) {
        _sisorgCodigo = authResponse.sisorgCodigo;
      }

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

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
        ApiEndpoints.pedidos,
        data: payload,
      );
    } on DioException catch (e) {
      throw Exception('Error al enviar pedido: ${e.message}');
    }
  }

  Future<Response> postCliente(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        ApiEndpoints.clientes,
        data: payload,
      );
    } on DioException catch (e) {
      throw Exception('Error al enviar cliente: ${e.message}');
    }
  }

  Future<Response> getClientes({dynamic sisorgId}) async {
    try {
      final orgId = sisorgId ??
          _sisorgId ??
          _sisorgCodigo ??
          getSisorgIdFromToken() ??
          dotenv.maybeGet('SISORG_CODIGO');

      if (orgId == null || orgId.toString().isEmpty) {
        throw Exception(
          'No se pudo determinar el SISORG_ID / SISORG_CODIGO. Inicie sesión nuevamente.',
        );
      }

      return await _dio.get(
        ApiEndpoints.clientes,
        queryParameters: {'sisorg_id': orgId},
      );
    } on DioException catch (e) {
      throw Exception('Error al obtener clientes: ${e.message}');
    }
  }

  Future<Response> postFaltante(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        ApiEndpoints.faltantes,
        data: payload,
      );
    } on DioException catch (e) {
      throw Exception('Error al enviar faltante: ${e.message}');
    }
  }

  Future<Response> getCatalogo({dynamic sisorgId}) async {
    try {
      final orgId = sisorgId ??
          _sisorgId ??
          _sisorgCodigo ??
          getSisorgIdFromToken() ??
          dotenv.maybeGet('SISORG_CODIGO');

      if (orgId == null || orgId.toString().isEmpty) {
        throw Exception(
          'No se pudo determinar el SISORG_ID / SISORG_CODIGO. Inicie sesión nuevamente.',
        );
      }

      return await _dio.get(
        ApiEndpoints.catalogo,
        queryParameters: {'sisorg_id': orgId},
      );
    } on DioException catch (e) {
      throw Exception('Error al obtener catálogo: ${e.message}');
    }
  }
}
