class AuthResponse {
  final String? session;
  final String? resultado;

  AuthResponse({this.session, this.resultado});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      session: json['session'] as String?,
      resultado: json['resultado'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session': session,
      'resultado': resultado,
    };
  }
}
