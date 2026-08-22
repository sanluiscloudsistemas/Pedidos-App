# Formato JSON para Envío de Pedidos a la API de Oracle APEX

Este documento define la estructura requerida del payload JSON para registrar pedidos, tanto en modo online como para sincronización diferida (offline).

## Estructura del Payload

```json
{
  "pedido": {
    "organizacion_id": 14,
    "cliente_id": 34,
    "vendedor_id": 23,
    "reparto_id": 12,
    "fecha": "21/08/2026",
    "condicionventa": "CONTADO",
    "total": 2345.65
  },
  "items": [
    {
      "producto_id": 123,
      "cantidad": 1,
      "precio_unitario": 10000.00,
      "descuento": 0,
      "precio_total": 10000.00
    },
    {
      "producto_id": 122,
      "cantidad": 1,
      "precio_unitario": 1345.65,
      "descuento": 0,
      "precio_total": 1345.65
    }
  ]
}
```

## Consideraciones

- Validar que el formato de fecha sea `DD/MM/YYYY`.
- El arreglo `items` debe contener los detalles de cada producto incluido en el pedido.
- Asegurarse de enviar este formato exacto al realizar la sincronización con el backend de APEX.
