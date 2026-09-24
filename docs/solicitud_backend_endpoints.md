# Reporte Técnico: Solicitud de Endpoints REST al Equipo de Backend

**Proyecto:** Preventas Móvil (Flutter / Oracle ORDS)  
**Destinatario:** Equipo de Desarrollo Backend y Administradores de Base de Datos (DBA / ORDS)  
**Fecha:** 20 de Septiembre de 2026  
**Objetivo:** Especificación formal de requerimientos de APIs REST para la sincronización diaria de datos maestros en modo Offline-First.

---

## 1. Contexto Operativo y Arquitectura Offline-First

La aplicación móvil de Preventas opera bajo una arquitectura **Offline-First**. Durante su jornada, el preventista puede trabajar en zonas sin cobertura de datos celulares.

Para garantizar la autonomía del usuario:
1. **Primera Conexión del Día:** La aplicación debe descargar y persistir localmente en base de datos (Hive) los catálogos maestros necesarios para operar sin internet: **Clientes**, **Productos / Catálogo** y **Repartos**.
2. **Toma de Pedidos Offline:** Toda la carga, autocompletado de precios, asignación de reparto y validación de cliente se realiza contra los datos almacenados localmente.
3. **Sincronización en Segundo Plano:** Al restablecer conexión o mediante el temporizador periódico (cada 30 minutos), los pedidos pendientes se envían por lotes a la API REST.

---

## 2. Inventario y Diagnóstico de Endpoints Actuales

Se realizó una auditoría completa sobre la capa de servicios de red de la aplicación (`ApiService` y `ApiEndpoints`). El estado de los servicios en Oracle ORDS es el siguiente:

| Recurso | Endpoint (ORDS) | Método | Estado en App | Estado en Backend | Observación / Brecha |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **Login** | `/mobile/login` | `POST` | Operativo | Disponible | Genera token JWT y claims organizacionales. |
| **Pedidos** | `/mobile/pedidos` | `POST` | Operativo | Disponible | Recibe cabecera e ítems del pedido. |
| **Pedidos** | `/mobile/pedidos` | `GET` | Operativo | Disponible | Consulta historial del vendedor. |
| **Clientes** | `/mobile/clientes` | `POST` | Operativo | Disponible | Alta de nuevos clientes generados en calle. |
| **Clientes** | `/mobile/clientes` | `GET` | Operativo | **Disponible** | **Apto para sincronización diaria local.** |
| **Catálogo** | `/mobile/catalogo` | `GET` | Operativo | **Disponible** | **Apto para sincronización diaria local.** |
| **Repartos** | `/mobile/repartos` | `GET` | Operativo | **Disponible** | **Apto para sincronización diaria local.** |
| **Faltantes** | `/mobile/faltantes` | `POST` | Operativo | Disponible | Envío de reporte de quiebres de stock. |
| **Condiciones Venta** | `/mobile/condiciones-venta`| `GET` | **Pendiente**| **NO EXISTE** | **Faltante Crítico:** Condiciones hardcodeadas en app. |
| **Faltantes** | `/mobile/faltantes` | `GET` | **Pendiente**| **NO EXISTE** | **Faltante:** Pantalla de consulta no puede listar datos. |
| **Listas de Precios** | `/mobile/listas-precio` | `GET` | **Pendiente**| **NO EXISTE** | **Recomendado:** Si hay precios diferenciados por cliente. |

---

## 3. Especificación Técnica de Endpoints Solicitados al Backend

A continuación se detalla la definición de los nuevos servicios REST requeridos en Oracle ORDS (Módulos PL/SQL y Handlers GET):

### Requerimiento 1: Consulta de Condiciones de Venta (Crítico)
Permite descargar las formas de pago y condiciones comerciales vigentes para alimentar el desplegable de venta del Wizard de Pedidos sin valores fijos en el código cliente.

- **Ruta:** `GET /mobile/condiciones-venta`
- **Headers Obligatorios:**
  - `Authorization: Bearer <JWT_TOKEN>`
- **Query Parameters:**
  - `sisorg_id` (Number/String, Requerido): Código o ID de la organización activa.
- **Formato de Respuesta Exitoso (`200 OK` - application/json):**
```json
{
  "items": [
    {
      "condicion_id": 1,
      "codigo": "CNT",
      "descripcion": "CONTADO",
      "dias_plazo": 0,
      "activo": "S"
    },
    {
      "condicion_id": 2,
      "codigo": "CC",
      "descripcion": "CUENTA CORRIENTE",
      "dias_plazo": 30,
      "activo": "S"
    },
    {
      "condicion_id": 3,
      "codigo": "CH30",
      "descripcion": "CHEQUE 30 DIAS",
      "dias_plazo": 30,
      "activo": "S"
    }
  ]
}
```

---

### Requerimiento 2: Consulta de Faltantes Registrados (Requerido)
Permite a la pantalla `FaltantesScreen` descargar y consultar los faltantes históricos reportados en depósitos para informar al preventista antes de tomar el pedido.

- **Ruta:** `GET /mobile/faltantes`
- **Headers Obligatorios:**
  - `Authorization: Bearer <JWT_TOKEN>`
- **Query Parameters:**
  - `sisorg_id` (Number/String, Requerido): Organización.
  - `deposito_id` (Number, Opcional): Filtro por depósito asignado.
  - `vendedor_id` (Number, Opcional): Filtro por vendedor.
  - `limit` (Number, Opcional, Default: 50): Paginación.
  - `offset` (Number, Opcional, Default: 0): Paginación.
- **Formato de Respuesta Exitoso (`200 OK` - application/json):**
```json
{
  "items": [
    {
      "id": 101,
      "producto_id": 1054,
      "codigo": "FID-001",
      "producto_descripcion": "FIDEOS TALLARIN 500G",
      "fecha": "20/09/2026",
      "observacion": "Quiebre de stock en planta",
      "estado": "ACTIVO"
    }
  ],
  "hasMore": false,
  "limit": 50,
  "offset": 0,
  "count": 1
}
```

---

### Requerimiento 3: Optimización de Sincronización Incremental (Delta Sync - Recomendado)
Actualmente los endpoints `/mobile/clientes` y `/mobile/catalogo` retornan la totalidad de filas. Para evitar alto consumo de datos móviles y demoras al iniciar la app, se solicita admitir el parámetro opcional `actualizado_desde`:

- **Parámetro:** `actualizado_desde` (String, formato ISO 8601: `YYYY-MM-DD"T"HH24:MI:SS"Z"`).
- **Lógica ORDS/SQL:**
  ```sql
  WHERE fecha_modificacion >= TO_TIMESTAMP_TZ(:actualizado_desde, 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
  ```
- **Beneficio:** Si la app ya sincronizó hoy a la mañana, una sincronización posterior solo descargará los cambios o altas de las últimas horas.

---

## 4. Estrategia de Implementación en la Aplicación Móvil

1. **Disparador Diario:**
   - La sincronización se detonará automáticamente en la **primera conexión del día de la aplicación**, reutilizando el mismo mecanismo de control por fecha persistida (`last_sync_date`).
2. **Persistencia Local:**
   - Se crearán cajas de almacenamiento en Hive para `clientes_maestro_box`, `catalogo_maestro_box` y `repartos_maestro_box`.
3. **Notificación de Término:**
   - Al concluir la descarga de todas las tablas maestras, la aplicación emitirá una notificación en pantalla indicando:
     > *"Sincronización diaria finalizada con éxito. X Clientes, Y Productos y Z Repartos disponibles para operar sin conexión."*
4. **Resiliencia:**
   - Si no hay conexión al iniciar, la aplicación continuará funcionando con los datos almacenados de la última sincronización exitosa sin arrojar pantallas de error bloqueantes.
