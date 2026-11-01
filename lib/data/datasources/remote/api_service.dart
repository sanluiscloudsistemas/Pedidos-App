import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/dto/auth_response_dto.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.isInitialized ? (dotenv.maybeGet('BASE_URL') ?? 'http://localhost') : 'http://localhost',
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
  String? get currentSisperId => _sisperId ?? getSisperIdFromToken();
  String? get sisorgId =>
      (int.tryParse(_sisorgId ?? '') != null ? _sisorgId : null) ??
      (int.tryParse(getSisorgIdFromToken() ?? '') != null ? getSisorgIdFromToken() : null) ??
      (dotenv.isInitialized ? dotenv.maybeGet('SISORG_ID') : null) ??
      (int.tryParse(_sisorgCodigo ?? '') != null ? _sisorgCodigo : null) ??
      '14';
  String? get sisperId => _sisperId ?? getSisperIdFromToken() ?? (dotenv.isInitialized ? dotenv.maybeGet('SISPER_ID') : null) ?? '19565';
  String? get sisdepId => _sisdepId ?? getSisdepIdFromToken() ?? (dotenv.isInitialized ? dotenv.maybeGet('SISDEP_ID') : null) ?? sisperId;
  String? get depositoId => _depositoId ?? getDepositoIdFromToken() ?? sisdepId ?? (dotenv.isInitialized ? dotenv.maybeGet('DEPOSITO_ID') : null);

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

        if (statusCode != null && statusCode >= 500) {
          String detail = '';
          if (responseData is Map<String, dynamic>) {
            final message = responseData['message'] ?? responseData['resultado'] ?? responseData['error'];
            if (message != null && message.toString().isNotEmpty) {
              detail = ': $message';
            }
          }
          throw ServerConnectionException(
            'No hay conexión con el servidor (Error $statusCode$detail). Se activó el modo offline.',
            statusCode: statusCode,
          );
        }

        if (statusCode == 401) {
          if (responseData is Map<String, dynamic>) {
            final message = responseData['message'] ?? responseData['resultado'] ?? responseData['error'];
            if (message != null && message.toString().isNotEmpty) {
              throw Exception(message);
            }
          }
          throw Exception('Credenciales inválidas. Verifique su organización, usuario y contraseña.');
        }

        if (statusCode == 555) {
          throw ServerConnectionException(
            'Error 555 en ORDS: Procedimiento en Oracle APEX no disponible. Se activó el modo offline.',
            statusCode: statusCode,
          );
        }
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerConnectionException(
          'Tiempo de espera agotado al conectar con el servidor. Se activó el modo offline.',
        );
      }

      if (e.type == DioExceptionType.connectionError || e.error is SocketException) {
        throw ServerConnectionException(
          'No hay conexión con el servidor. Se activó el modo offline.',
        );
      }

      throw ServerConnectionException(
        'No fue posible establecer conexión con el servidor. Se activó el modo offline.',
      );
    }
  }

  Future<Response> postPedido(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        ApiEndpoints.pedidos,
        data: payload,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'enviar pedido');
    }
  }

  Future<Response> getPedidos({
    dynamic sisorgId,
    dynamic sisperId,
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      final orgId = sisorgId ?? this.sisorgId;
      final vendId = sisperId ?? this.sisperId;

      final headers = <String, dynamic>{};
      if (orgId != null && orgId.toString().isNotEmpty) {
        headers['sisorg_id'] = orgId;
      }
      if (vendId != null && vendId.toString().isNotEmpty) {
        headers['sisper_id'] = vendId;
      }

      return await _dio.get(
        ApiEndpoints.pedidos,
        options: Options(headers: headers),
        queryParameters: {
          'sisorg_id': orgId,
          if (vendId != null) 'sisper_id': vendId,
          'offset': offset,
          'limit': limit,
        }..removeWhere((key, value) => value == null),
      );
    } on DioException catch (e) {
      _handleDioError(e, 'obtener pedidos');
    }
  }

  Future<Response> postCliente(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        ApiEndpoints.clientes,
        data: payload,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'enviar cliente');
    }
  }

  Future<Response> getClientes({
    dynamic sisorgId,
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      final orgId = sisorgId ?? this.sisorgId;

      if (orgId == null || orgId.toString().isEmpty) {
        throw Exception(
          'No se pudo determinar el SISORG_ID. Inicie sesión nuevamente.',
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
      _handleDioError(e, 'obtener clientes');
    }
  }

  Future<Response> getFaltantes({
    dynamic sisorgId,
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      final orgId = sisorgId ?? this.sisorgId;

      return await _dio.get(
        ApiEndpoints.faltantes,
        queryParameters: {
          'sisorg_id': orgId,
          'offset': offset,
          'limit': limit,
        },
      );
    } on DioException catch (e) {
      _handleDioError(e, 'obtener faltantes');
    }
  }

  Future<Response> postFaltante(Map<String, dynamic> payload) async {
    try {
      return await _dio.post(
        ApiEndpoints.faltantes,
        data: payload,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'enviar faltante');
    }
  }

  Future<Response> getCatalogo({dynamic sisorgId}) async {
    try {
      final orgId = sisorgId ?? this.sisorgId;

      if (orgId == null || orgId.toString().isEmpty) {
        throw Exception(
          'No se pudo determinar el SISORG_ID. Inicie sesión nuevamente.',
        );
      }

      return await _dio.get(
        ApiEndpoints.catalogo,
        queryParameters: {'sisorg_id': orgId},
      );
    } on DioException catch (e) {
      _handleDioError(e, 'obtener catálogo');
    }
  }

  Future<Response> getRepartos({
    dynamic sisorgId,
    int offset = 0,
    int limit = 100,
  }) async {
    try {
      final orgId = sisorgId ?? this.sisorgId;

      return await _dio.get(
        ApiEndpoints.repartos,
        queryParameters: {
          'sisorg_id': orgId,
          'offset': offset,
          'limit': limit,
        },
      );
    } on DioException catch (e) {
      _handleDioError(e, 'obtener repartos');
    }
  }

  Never _handleDioError(DioException e, String operacion) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode != null && statusCode >= 500) {
        String detail = '';
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'] ?? responseData['resultado'] ?? responseData['error'];
          if (message != null && message.toString().isNotEmpty) {
            detail = ': $message';
          }
        }
        throw ServerConnectionException(
          'No hay conexión con el servidor (Error $statusCode$detail). Intente más tarde o verifique el backend.',
          statusCode: statusCode,
        );
      }

      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] ?? responseData['resultado'] ?? responseData['error'];
        if (message != null && message.toString().isNotEmpty) {
          throw Exception(message.toString());
        }
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw ServerConnectionException(
        'No se pudo conectar con el servidor al $operacion. Verifique su conexión de red.',
      );
    }

    throw Exception('Error al $operacion: ${e.response?.statusMessage ?? e.message ?? "Error inesperado"}');
  }
}
