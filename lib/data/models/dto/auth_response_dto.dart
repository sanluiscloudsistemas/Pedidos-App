import 'dart:convert';

class AuthResponse {
  final String? token;
  final String? session;
  final int? expiresInSeconds;
  final bool? success;
  final String? message;
  final String? resultado;
  final String? sisorgId;
  final String? sisorgCodigo;
  final String? sisperId;
  final String? sisdepId;

  AuthResponse({
    this.token,
    this.session,
    this.expiresInSeconds,
    this.success,
    this.message,
    this.resultado,
    this.sisorgId,
    this.sisorgCodigo,
    this.sisperId,
    this.sisdepId,
  });

  /// Retorna el token JWT prioritario (o la sesión como fallback).
  String? get jwtToken => token ?? session;

  static String? _cleanStr(dynamic val) {
    if (val == null) return null;
    final str = val.toString().trim();
    if (str.startsWith("'") && str.endsWith("'") && str.length >= 2) {
      return str.substring(1, str.length - 1).trim();
    }
    if (str.startsWith("'")) {
      return str.substring(1).trim();
    }
    return str;
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    String? token = _cleanStr(json['token'] ?? json['jwt']);
    String? session = _cleanStr(json['session']);
    bool? success = json['success'] as bool?;
    String? message = _cleanStr(json['message']);
    final String? resultadoStr = json['resultado'] as String?;

    String? sisorgId = _cleanStr(json['sisorg_id'] ?? json['sisorgId'] ?? json['organizacion_id']);
    String? sisorgCodigo = _cleanStr(json['sisorg_codigo'] ?? json['sisorgCodigo'] ?? json['organizacion']);
    String? sisperId = _cleanStr(json['sisper_id'] ?? json['sisperId']);
    String? sisdepId = _cleanStr(json['sisdep_id'] ?? json['sisdepId']);

    if (resultadoStr != null && resultadoStr.trim().startsWith('{')) {
      try {
        final Map<String, dynamic> nestedJson = jsonDecode(resultadoStr);
        if (nestedJson.containsKey('token')) {
          token ??= _cleanStr(nestedJson['token']);
        }
        if (nestedJson.containsKey('estado')) {
          final estadoStr = _cleanStr(nestedJson['estado']);
          success ??= (estadoStr == 'Autenticado' || estadoStr == 'OK');
        }
        if (nestedJson.containsKey('nombre')) {
          message ??= _cleanStr(nestedJson['nombre']);
        }
        sisorgId ??= _cleanStr(nestedJson['sisorg_id'] ?? nestedJson['sisorgId'] ?? nestedJson['organizacion_id']);
        sisorgCodigo ??= _cleanStr(nestedJson['sisorg_codigo'] ?? nestedJson['sisorgCodigo'] ?? nestedJson['organizacion']);
        sisperId ??= _cleanStr(nestedJson['sisper_id'] ?? nestedJson['sisperId']);
        sisdepId ??= _cleanStr(nestedJson['sisdep_id'] ?? nestedJson['sisdepId']);
      } catch (_) {}
    }

    success ??= (resultadoStr == 'OK');
    message ??= resultadoStr;

    return AuthResponse(
      token: token,
      session: session,
      expiresInSeconds: json['expires_in_seconds'] is int
          ? json['expires_in_seconds'] as int
          : (json['expires_in_seconds'] != null
              ? int.tryParse(json['expires_in_seconds'].toString())
              : null),
      success: success,
      message: message,
      resultado: resultadoStr,
      sisorgId: sisorgId,
      sisorgCodigo: sisorgCodigo,
      sisperId: sisperId,
      sisdepId: sisdepId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'session': session,
      'expires_in_seconds': expiresInSeconds,
      'success': success,
      'message': message,
      'resultado': resultado,
      'sisorg_id': sisorgId,
      'sisorg_codigo': sisorgCodigo,
      'sisper_id': sisperId,
      'sisdep_id': sisdepId,
    };
  }
}
