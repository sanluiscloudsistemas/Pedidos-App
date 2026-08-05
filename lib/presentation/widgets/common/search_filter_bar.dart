import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

/// Componente reutilizable de barra de búsqueda con botón rojo primario "Ir".
class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSearch;
  final ValueChanged<String>? onChanged;

  const SearchFilterBar({
    super.key,
    required this.controller,
    this.hintText = 'Buscar...',
    required this.onSearch,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.primaryRed),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            style: AppStyles.primaryButtonStyle,
            onPressed: onSearch,
            child: const Text('Ir', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
