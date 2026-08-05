class UserEntity {
  final String token;
  final String usuario;
  final String organizacion;
  final bool isOfflineSession;

  UserEntity({
    required this.token,
    required this.usuario,
    required this.organizacion,
    this.isOfflineSession = false,
  });

  /// Alias de compatibilidad hacia atrás para `session`.
  String get session => token;
}
