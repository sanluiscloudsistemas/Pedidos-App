# Especificación de Endpoints POST para ORDS

Para permitir el registro y sincronización de datos desde la aplicación móvil hacia el servidor, se requiere implementar los siguientes tres (3) endpoints bajo el módulo REST `mobile`.

La Base URL utilizada es: `http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/`

---

## 1. Carga de Pedidos (Sincronización)
Recibe la cabecera del pedido junto con el detalle de sus ítems.

* **Método:** `POST`
* **URL:** `/pedidos` (o `/pedidos/sincronizar`)
* **Headers:** `Authorization: Bearer <token>`, `Content-Type: application/json`
* **Payload Propuesto:**

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
    }
  ]
}
```

---

## 2. Carga de Clientes (Alta/Registro)
Permite a los preventistas dar de alta nuevos clientes en ruta.

* **Método:** `POST`
* **URL:** `/clientes`
* **Headers:** `Authorization: Bearer <token>`, `Content-Type: application/json`
* **Payload Propuesto:**

```json
{
  "organizacion_id": 14,
  "vendedor_id": 23,
  "nombre": "Juan Pérez",
  "razon_social": "Kiosco El Sol",
  "tipo_documento": "CUIT",
  "numero_documento": "20-12345678-9",
  "tipo_iva": "RI",
  "telefono": "2664123456",
  "email_principal": "juan@example.com",
  "geoposicion": "-33.295420,-66.335967",
  "estado": "ACT"
}
```

---

## 3. Carga de Faltantes (Reporte)
Permite reportar productos agotados que el cliente solicitó.

* **Método:** `POST`
* **URL:** `/faltantes`
* **Headers:** `Authorization: Bearer <token>`, `Content-Type: application/json`
* **Payload Propuesto:**

```json
{
  "organizacion_id": 14,
  "vendedor_id": 23,
  "producto_id": 456,
  "fecha": "21/08/2026T14:30:00Z",
  "observacion": "Cliente solicitó 5 cajas, sin stock en sistema"
}
```
