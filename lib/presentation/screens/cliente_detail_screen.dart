import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 1,
        titleSpacing: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFB71C1C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 20),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'PEDIDOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
            onPressed: () {},
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.help_outline, color: Colors.white, size: 18),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              SizedBox(width: 8),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person_outline, color: Colors.white, size: 18),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con Código de Cliente
              Text(
                'Cliente ${cliente.codigo}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
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
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? ' ' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF212121),
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
    final paint = Paint()..color = const Color(0xFFD32F2F);
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
