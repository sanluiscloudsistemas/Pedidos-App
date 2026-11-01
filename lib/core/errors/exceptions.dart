/// Excepción lanzada cuando el servidor remoto (ORDS / APEX) es inalcanzable,
/// agota el tiempo de espera o retorna errores de servidor (5xx).
class ServerConnectionException implements Exception {
  final String message;
  final int? statusCode;

  ServerConnectionException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

