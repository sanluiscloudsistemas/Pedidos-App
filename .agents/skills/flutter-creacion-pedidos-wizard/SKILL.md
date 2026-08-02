---
name: "flutter-creacion-pedidos-wizard"
description: "Construye el Wizard de Creación de Pedidos en Flutter de 3 pasos (1. Cliente y Venta, 2. Carga de Productos con tabla interactiva y montos, 3. Reparto y Confirmación) con barra de progreso inferior."
---

# Skill: Wizard de Creación de Pedidos en Flutter (`Nuevo Pedido`)

Esta habilidad define la especificación visual, cálculo de totales, flujo de pasos secuenciales y código Flutter para construir el **Wizard de Creación de Pedidos** basado en la interfaz del sistema de preventas.

---

## 🎨 Design System y Tokens Visuales

### Paleta de Colores
- **Cabecera (AppBar)**: Rojo primario `#D32F2F` (o `Colors.red.shade800`).
- **Botón Acción Principal**: Rojo sólido `#D32F2F` (`Productos >`, `Reparto >`, `Confirmar`).
- **Botón Secundario**: Gris neutro (`Cancelar`, `<` Atrás, `X` Cancelar).
- **Indicador de Progreso Inferior (Stepper)**:
  - Paso Completado: Círculo verde con check `(🟢)` (`Colors.green`).
  - Paso Actual: Círculo rojo grande `(🔴)` (`#D32F2F`).
  - Paso Pendiente: Círculo gris `(⚪)` (`#CCCCCC`).
  - Línea conectoras grises entre pasos.

---

## 📋 Estructura de Pasos del Wizard

### Paso 1: Selección de Cliente y Condición de Venta
- **Cabecera**: Botón `Cancelar` (Izq) + Botón `Productos >` (Der).
- **Campos**:
  - `Cliente`: Desplegable con código y nombre (ej. `ABIBE JULIO (CF) (2068)`).
  - `Condición de Venta`: Desplegable (ej. `CONTADO`, `CTA CTE`).
- **Progreso**: `Paso 1 de 3 (🔴 -- ⚪ -- ⚪)`

### Paso 2: Carga de Productos y Montos
- **Cabecera**: Botón `<` Atrás, `X` Cancelar, Resumen `TOTAL : $ X.XXX` + Botón `Reparto >` (Der).
- **Formulario de Item**:
  - `Producto`: Código o buscador de producto.
  - `Cantidad`: Selector numérico.
  - `Descuento`: Monto o porcentaje opcional.
  - Botón: `[ Agregar Producto 🛒 ]`
- **Tabla de Items**:
  - Columnas: `Codigo`, `Cant.`, `Unitario`, `Desc.`, `Total`, `Accion` (icono `❌`), `Descripcion`.
  - Fila final: Total acumulado en negrita.
- **Progreso**: `Paso 2 de 3 (🟢 -- 🔴 -- ⚪)`

### Paso 3: Asignación de Reparto y Confirmación
- **Cabecera**: Botón `<` Atrás, `X` Cancelar + Botón `Confirmar` (Der).
- **Resumen del Pedido**:
  - `Cliente`: Nombre seleccionado.
  - `Condición de Venta`: Contado / Cta Cte.
  - `TOTAL`: Monto total de la orden.
- **Selección de Reparto**:
  - Desplegable `Reparto`: (ej. `FER II 31-07-26`, `SAMUEL 31-07-26`, `ALEXIS 31-07-26`, `SIN DEPOSITO`).
- **Progreso**: `Paso 3 de 3 (🟢 -- 🟢 -- 🔴)`

---

## 🧩 Patrón de Código en Flutter (`NuevoPedidoWizardScreen`)

```dart
import 'package:flutter/material.dart';

class OrderItemDraft {
  final String codigo;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento;

  double get total => (precioUnitario * cantidad) - descuento;

  const OrderItemDraft({
    required this.codigo,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
  });
}

class NuevoPedidoWizardScreen extends StatefulWidget {
  final String? initialCliente;

  const NuevoPedidoWizardScreen({super.key, this.initialCliente});

  @override
  State<NuevoPedidoWizardScreen> createState() => _NuevoPedidoWizardScreenState();
}

class _NuevoPedidoWizardScreenState extends State<NuevoPedidoWizardScreen> {
  int _currentStep = 1;

  // Paso 1 State
  String _selectedCliente = 'ABIBE JULIO (CF) (2068)';
  String _selectedCondicionVenta = 'CONTADO';

  // Paso 2 State
  final List<OrderItemDraft> _items = [];
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController(text: '1');
  final TextEditingController _descuentoController = TextEditingController();

  // Paso 3 State
  String _selectedReparto = 'FER II 31-07-26';

  double get _totalMonto => _items.fold(0.0, (sum, item) => sum + item.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        title: const Text('PEDIDOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildCurrentStepContent(),
            ),
          ),
          _buildBottomStepper(),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() { ... }
  Widget _buildStep2() { ... }
  Widget _buildStep3() { ... }

  Widget _buildBottomStepper() {
    return Container(
      height: 50,
      color: const Color(0xFFFAFAFA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(step: 1),
          _buildLine(),
          _buildDot(step: 2),
          _buildLine(),
          _buildDot(step: 3),
        ],
      ),
    );
  }

  Widget _buildDot({required int step}) {
    if (step < _currentStep) {
      return const CircleAvatar(radius: 10, backgroundColor: Colors.green, child: Icon(Icons.check, size: 12, color: Colors.white));
    } else if (step == _currentStep) {
      return const CircleAvatar(radius: 12, backgroundColor: Color(0xFFD32F2F));
    } else {
      return const CircleAvatar(radius: 8, backgroundColor: Color(0xFFCCCCCC));
    }
  }

  Widget _buildLine() {
    return Container(width: 40, height: 2, color: const Color(0xFFE0E0E0));
  }
}
```
