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
  String? _sisperId;
  String? _sisdepId;
  String? _depositoId;

  String? get currentAuthToken => _authToken;
  String? get currentSisorgId => _sisorgId;
  String? get currentSisorgCodigo => _sisorgCodigo;
  String? get currentDepositoId => _depositoId;
  String? get sisorgId => _sisorgId ?? _sisorgCodigo ?? getSisorgIdFromToken() ?? dotenv.maybeGet('SISORG_CODIGO') ?? '14';
  String? get sisperId => _sisperId ?? getSisperIdFromToken() ?? dotenv.maybeGet('SISPER_ID') ?? '19565';
  String? get sisdepId => _sisdepId ?? getSisdepIdFromToken() ?? dotenv.maybeGet('SISDEP_ID') ?? sisperId;
  String? get depositoId => _depositoId ?? getDepositoIdFromToken() ?? sisdepId ?? dotenv.maybeGet('DEPOSITO_ID');

  /// Asigna el token JWT en las cabeceras de todas las solicitudes de Dio.
  void setAuthToken(String? token) {
    _authToken = token;
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Establece explícitamente el sisorg_id, sisorg_codigo, sisper_id, sisdep_id o deposito_id.
  void setOrganizationInfo({
    String? sisorgId,
    String? sisorgCodigo,
    String? sisperId,
    String? sisdepId,
    String? depositoId,
  }) {
    if (sisorgId != null && sisorgId.isNotEmpty) {
      _sisorgId = sisorgId;
    }
    if (sisorgCodigo != null && sisorgCodigo.isNotEmpty) {
      _sisorgCodigo = sisorgCodigo;
    }
    if (sisperId != null && sisperId.isNotEmpty) {
      _sisperId = sisperId;
    }
    if (sisdepId != null && sisdepId.isNotEmpty) {
      _sisdepId = sisdepId;
    }
    if (depositoId != null && depositoId.isNotEmpty) {
      _depositoId = depositoId;
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

  /// Extrae el SISPER_ID o vendedor_id desde los claims del payload del token JWT.
  String? getSisperIdFromToken() {
    if (_authToken == null || _authToken!.isEmpty) return null;
    try {
      final parts = _authToken!.split('.');
      if (parts.length != 3) return null;
      final normalized = base64.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(payloadString);
      if (payload is Map<String, dynamic>) {
        final val = payload['sisper_id'] ??
            payload['SISPER_ID'] ??
            payload['vendedor_id'] ??
            payload['usuario_id'] ??
            payload['sisper'];
        if (val != null && val.toString().isNotEmpty) {
          return val.toString();
        }
      }
    } catch (_) {}
    return null;
  }

  /// Extrae el SISDEP_ID o dependencia_id desde los claims del payload del token JWT.
  String? getSisdepIdFromToken() {
    if (_authToken == null || _authToken!.isEmpty) return null;
    try {
      final parts = _authToken!.split('.');
      if (parts.length != 3) return null;
      final normalized = base64.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(payloadString);
      if (payload is Map<String, dynamic>) {
        final val = payload['sisdep_id'] ??
            payload['SISDEP_ID'] ??
            payload['dependencia_id'] ??
            payload['sisdep'];
        if (val != null && val.toString().isNotEmpty) {
          return val.toString();
        }
      }
    } catch (_) {}
    return null;
  }

  /// Extrae el DEPOSITO_ID desde los claims del payload del token JWT.
  String? getDepositoIdFromToken() {
    if (_authToken == null || _authToken!.isEmpty) return null;
    try {
      final parts = _authToken!.split('.');
      if (parts.length != 3) return null;
      final normalized = base64.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(payloadString);
      if (payload is Map<String, dynamic>) {
        final val = payload['deposito_id'] ??
            payload['DEPOSITO_ID'] ??
            payload['comdep_id'] ??
            payload['comdep_id_ori'] ??
            payload['sisdep_id'];
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
      if (authResponse.sisperId != null) {
        _sisperId = authResponse.sisperId;
      }
      if (authResponse.sisdepId != null) {
        _sisdepId = authResponse.sisdepId;
      }
      if (authResponse.depositoId != null) {
        _depositoId = authResponse.depositoId;
      } else if (authResponse.sisdepId != null) {
        _depositoId = authResponse.sisdepId;
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
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final msg = data['message'] ?? data['title'] ?? data['error'] ?? data['cause'];
          if (msg != null && msg.toString().isNotEmpty) {
            throw Exception('Error al enviar pedido (${e.response?.statusCode}): $msg');
          }
        } else if (data is String && data.isNotEmpty) {
          throw Exception('Error al enviar pedido (${e.response?.statusCode}): $data');
        }
      }
      throw Exception('Error al enviar pedido: ${e.message}');
    }
  }

  Future<Response> getPedidos({
    dynamic sisorgId,
    dynamic sisperId,
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      final orgId = sisorgId ??
          _sisorgId ??
          _sisorgCodigo ??
          getSisorgIdFromToken() ??
          dotenv.maybeGet('SISORG_CODIGO');

      final headers = <String, dynamic>{};
      if (orgId != null && orgId.toString().isNotEmpty) {
        headers['sisorg_id'] = orgId;
      }
      if (sisperId != null && sisperId.toString().isNotEmpty) {
        headers['sisper_id'] = sisperId;
      }

      return await _dio.get(
        ApiEndpoints.pedidos,
        options: Options(headers: headers),
        queryParameters: {
          'sisorg_id': orgId,
          if (sisperId != null) 'sisper_id': sisperId,
          'offset': offset,
          'limit': limit,
        },
      );
    } on DioException catch (e) {
      throw Exception('Error al obtener pedidos: ${e.message}');
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

  Future<Response> getClientes({
    dynamic sisorgId,
    int offset = 0,
    int limit = 25,
  }) async {
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
        queryParameters: {
          'sisorg_id': orgId,
          'offset': offset,
          'limit': limit,
        },
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

  Future<Response> getRepartos({
    dynamic sisorgId,
    int offset = 0,
    int limit = 100,
  }) async {
    try {
      final orgId = sisorgId ??
          _sisorgId ??
          _sisorgCodigo ??
          getSisorgIdFromToken() ??
          dotenv.maybeGet('SISORG_CODIGO') ??
          '14';

      return await _dio.get(
        ApiEndpoints.repartos,
        queryParameters: {
          'sisorg_id': orgId,
          'offset': offset,
          'limit': limit,
        },
      );
    } on DioException catch (e) {
      throw Exception('Error al obtener repartos: ${e.message}');
    }
  }
}
