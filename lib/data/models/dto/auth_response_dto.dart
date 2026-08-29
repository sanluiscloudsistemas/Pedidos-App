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

  AuthResponse({
    this.token,
    this.session,
    this.expiresInSeconds,
    this.success,
    this.message,
    this.resultado,
    this.sisorgId,
    this.sisorgCodigo,
  });

  /// Retorna el token JWT prioritario (o la sesión como fallback).
  String? get jwtToken => token ?? session;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    String? token = json['token'] as String? ?? json['jwt'] as String?;
    String? session = json['session'] as String?;
    bool? success = json['success'] as bool?;
    String? message = json['message'] as String?;
    final String? resultadoStr = json['resultado'] as String?;

    String? sisorgId = json['sisorg_id']?.toString() ??
        json['sisorgId']?.toString() ??
        json['organizacion_id']?.toString();
    String? sisorgCodigo = json['sisorg_codigo']?.toString() ??
        json['sisorgCodigo']?.toString() ??
        json['organizacion']?.toString();

    if (resultadoStr != null && resultadoStr.trim().startsWith('{')) {
      try {
        final Map<String, dynamic> nestedJson = jsonDecode(resultadoStr);
        if (nestedJson.containsKey('token')) {
          token ??= nestedJson['token'] as String?;
        }
        if (nestedJson.containsKey('estado')) {
          success ??= (nestedJson['estado'] == 'Autenticado' || nestedJson['estado'] == 'OK');
        }
        if (nestedJson.containsKey('nombre')) {
          message ??= nestedJson['nombre'] as String?;
        }
        sisorgId ??= nestedJson['sisorg_id']?.toString() ??
            nestedJson['sisorgId']?.toString() ??
            nestedJson['organizacion_id']?.toString();
        sisorgCodigo ??= nestedJson['sisorg_codigo']?.toString() ??
            nestedJson['sisorgCodigo']?.toString() ??
            nestedJson['organizacion']?.toString();
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
    };
  }
}
