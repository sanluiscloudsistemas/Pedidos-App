import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../widgets/common/preventa_app_bar.dart';
import '../widgets/common/preventa_drawer.dart';
import '../widgets/common/status_pill_tag.dart';

/// Modelo completo para el Detalle de un Cliente
class ClienteDetailModel {
  final String codigo;
  final String nombre;
  final String razonSocial;
  final String documento;
  final String tipoIva;
  final String telefono;
  final String emailPrincipal;
  final String emailSecundario;
  final String estado;
  final String fecha;
  final String motivoEstado;

  const ClienteDetailModel({
    required this.codigo,
    required this.nombre,
    this.razonSocial = '',
    required this.documento,
    required this.tipoIva,
    required this.telefono,
    this.emailPrincipal = '',
    this.emailSecundario = '',
    required this.estado,
    required this.fecha,
    this.motivoEstado = '',
  });
}

/// Pantalla del Detalle de un Cliente (`Cliente <codigo>`)
class ClienteDetailScreen extends StatelessWidget {
  final ClienteDetailModel cliente;

  const ClienteDetailScreen({
    super.key,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreventaAppBar(
        title: 'PEDIDOS',
        showBackButton: true,
      ),
      drawer: const PreventaDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con Código y Tag de Estado del Cliente
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cliente ${cliente.codigo}',
                    style: AppStyles.sectionTitleStyle.copyWith(fontSize: 18),
                  ),
                  if (cliente.estado.isNotEmpty)
                    StatusPillTag.active(label: cliente.estado),
                ],
              ),
              const SizedBox(height: 16),

              // Cajas de información del cliente
              _buildDetailBox('Nombre', cliente.nombre),
              _buildDetailBox('Razon Social', cliente.razonSocial),
              _buildDetailBox('Documento', cliente.documento),
              _buildDetailBox('Tipo Iva', cliente.tipoIva),
              _buildDetailBox('Telefono', cliente.telefono),
              _buildDetailBox('Email Principal', cliente.emailPrincipal),
              _buildDetailBox('Email Secundario', cliente.emailSecundario),
              _buildDetailBox('Estado', cliente.estado),
              _buildDetailBox('Fecha', cliente.fecha, hasRedCorner: true),
              _buildDetailBox('Motivo Estado', cliente.motivoEstado),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String value, {bool hasRedCorner = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppStyles.cardDecoration(
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
      ),
      child: Stack(
        children: [
          if (hasRedCorner)
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                size: const Size(12, 12),
                painter: _RedCornerPainter(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.subtitleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? ' ' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RedCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryRed;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
