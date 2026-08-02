import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

/// Componente reutilizable para encabezados de lista con recuento de filas y botones opcionales de acción (ej. "+ Crear").
class ListHeaderSummary extends StatelessWidget {
  final int count;
  final String label;
  final String? actionButtonText;
  final VoidCallback? onActionButtonPressed;

  const ListHeaderSummary({
    super.key,
    required this.count,
    required this.label,
    this.actionButtonText,
    this.onActionButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mostrando $count $label',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        if (actionButtonText != null && onActionButtonPressed != null)
          ElevatedButton.icon(
            style: AppStyles.primaryButtonStyle,
            icon: const Icon(Icons.add, size: 16),
            label: Text(actionButtonText!),
            onPressed: onActionButtonPressed,
          ),
      ],
    );
  }
}
