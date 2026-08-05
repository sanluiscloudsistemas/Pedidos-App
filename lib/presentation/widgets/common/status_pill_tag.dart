import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Componente reutilizable para mostrar etiquetas de estado / Badges en listas y tarjetas.
class StatusPillTag extends StatelessWidget {
  final String statusText;
  final Color backgroundColor;
  final Color textColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatusPillTag({
    super.key,
    required this.statusText,
    this.backgroundColor = AppColors.lightRedBg,
    this.textColor = AppColors.primaryRed,
    this.isSelected = false,
    this.onTap,
  });

  factory StatusPillTag.active({
    required String label,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return StatusPillTag(
      statusText: label,
      backgroundColor: const Color(0xFFE8F5E9),
      textColor: AppColors.successGreen,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  factory StatusPillTag.pending({
    required String label,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return StatusPillTag(
      statusText: label,
      backgroundColor: const Color(0xFFFFF3E0),
      textColor: AppColors.warningOrange,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  factory StatusPillTag.inactive({
    required String label,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return StatusPillTag(
      statusText: label,
      backgroundColor: const Color(0xFFFFEBEE),
      textColor: AppColors.primaryRed,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isSelected ? AppColors.primaryRed : backgroundColor;
    final effectiveText = isSelected ? Colors.white : textColor;

    final childWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: effectiveText,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: childWidget,
      );
    }

    return childWidget;
  }
}
