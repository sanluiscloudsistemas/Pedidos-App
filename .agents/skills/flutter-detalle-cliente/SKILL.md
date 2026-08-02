---
name: "flutter-detalle-cliente"
description: "Construye la pantalla de Detalle del Cliente en Flutter con cajas estructuradas con bordes punteados/sólidos para cada campo de información (Nombre, Razón Social, Documento, Tipo IVA, Teléfono, Emails, Estado, Fecha con indicador y Motivo Estado)."
---

# Skill: Pantalla de Detalle del Cliente en Flutter (`Cliente <codigo>`)

Esta habilidad define la especificación visual, campos de datos y código Flutter para construir la pantalla de **Detalle del Cliente** basada en la interfaz del sistema de preventas.

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Título de Sección**: Texto negro en negrita `Cliente <codigo>` (ej. `Cliente 0695`).
- **Etiqueta de Campo (Label)**: Texto gris superior (`#757575`, 11pt - 12pt).
- **Valor del Campo (Value)**: Texto gris oscuro / negro (`#212121`, 14pt).
- **Caja de Campo**: Tarjeta/Contenedor con borde rectangular en gris suave (`#E0E0E0` o `#CCCCCC`) y fondo blanco.
- **Marca de Fecha**: Pequeño triángulo o esquina roja (`#D32F2F`) en el campo de Fecha.

---

## 📋 Lista Exacta de Campos del Detalle

| Campo | Etiqueta | Ejemplo de Valor | Descripción |
| :--- | :--- | :--- | :--- |
| **1** | `Nombre` | `CABRERA ANALIA (FA)` | Nombre o denominación del cliente |
| **2** | `Razon Social` | *(vacío / opcional)* | Razón social registrada |
| **3** | `Documento` | `CUIT : 27322538680` | Documento de identificación fiscal (CUIT/CUIL) |
| **4** | `Tipo Iva` | `RESP. INSCRIPTO` | Condición frente al IVA |
| **5** | `Telefono` | `2664261198` | Número de teléfono de contacto |
| **6** | `Email Principal` | *(vacío / opcional)* | Correo electrónico principal |
| **7** | `Email Secundario` | *(vacío / opcional)* | Correo electrónico alternativo |
| **8** | `Estado` | `HABILITADO` | Estado actual de la cuenta (`HABILITADO`, `SUSPENDIDO`) |
| **9** | `Fecha` | `04/12/2014 03:01:16` | Fecha de alta/registro con marca de esquina roja |
| **10** | `Motivo Estado` | *(vacío / opcional)* | Motivo o razón del cambio de estado |

---

## 🧩 Patrón de Código en Flutter (`ClienteDetailScreen`)

```dart
import 'package:flutter/material.dart';

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
        title: const Text('PEDIDOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente ${cliente.codigo}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
            ),
            const SizedBox(height: 16),
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
    );
  }

  Widget _buildDetailBox(String label, String value, {bool hasRedCorner = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Stack(
        children: [
          if (hasRedCorner)
            Positioned(
              top: -10,
              left: -14,
              child: CustomPaint(
                size: const Size(12, 12),
                painter: RedCornerPainter(),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? ' ' : value,
                style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RedCornerPainter extends CustomPainter {
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
```
