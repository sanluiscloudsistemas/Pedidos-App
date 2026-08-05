class AuthResponse {
  final String? token;
  final String? session;
  final int? expiresInSeconds;
  final bool? success;
  final String? message;
  final String? resultado;

  AuthResponse({
    this.token,
    this.session,
    this.expiresInSeconds,
    this.success,
    this.message,
    this.resultado,
  });

  /// Retorna el token JWT prioritario (o la sesión como fallback).
  String? get jwtToken => token ?? session;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String? ?? json['jwt'] as String?,
      session: json['session'] as String?,
      expiresInSeconds: json['expires_in_seconds'] is int
          ? json['expires_in_seconds'] as int
          : (json['expires_in_seconds'] != null
              ? int.tryParse(json['expires_in_seconds'].toString())
              : null),
      success: json['success'] as bool? ?? (json['resultado'] == 'OK'),
      message: json['message'] as String? ?? json['resultado'] as String?,
      resultado: json['resultado'] as String?,
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
    };
  }
}
