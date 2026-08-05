import 'package:flutter/material.dart';

/// Paleta de colores centralizada para la aplicación de Preventas.
abstract class AppColors {
  /// Rojo primario característico del encabezado de la aplicación (#D32F2F)
  static const Color primaryRed = Color(0xFFD32F2F);

  /// Rojo oscuro utilizado para botones de menú e íconos contrastados (#B71C1C)
  static const Color darkRed = Color(0xFFB71C1C);

  /// Fondo rojo suave utilizado para destacar filas o ítems seleccionados (#FFFFEBEE)
  static const Color lightRedBg = Color(0xFFFFEBEE);

  /// Fondo gris claro neutro de la aplicación (#FAF9F9)
  static const Color background = Color(0xFFFAF9F9);

  /// Color de bordes de tarjetas y separadores (#E5E5E5)
  static const Color cardBorder = Color(0xFFE5E5E5);

  /// Texto principal oscuro (#212121)
  static const Color textDark = Color(0xFF212121);

  /// Texto secundario / leyendas (#757575)
  static const Color textSecondary = Color(0xFF757575);

  /// Verde de éxito / estado activo (#2E7D32)
  static const Color successGreen = Color(0xFF2E7D32);

  /// Naranja de advertencia / pendientes (#EF6C00)
  static const Color warningOrange = Color(0xFFEF6C00);
}
