import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos globales reutilizables para textos, tarjetas e inmutables de UI.
abstract class AppStyles {
  /// Estilo de título de la cabecera (AppBar)
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 1.0,
  );

  /// Estilo de títulos principales de sección o pantalla
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Estilo de subtítulos / leyendas secundarias
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  /// Decoración estándar para contenedores con borde sólido
  static BoxDecoration cardDecoration({
    Color backgroundColor = Colors.white,
    Color borderColor = AppColors.cardBorder,
    double borderRadius = 6.0,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: 1.0),
    );
  }

  /// Estilo de botón primario rojo
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryRed,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
