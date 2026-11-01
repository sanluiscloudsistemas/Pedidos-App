# Variables de Entorno y Configuración Global

Este documento registra las variables de entorno utilizadas por la aplicación Flutter y sus valores predeterminados para entornos de desarrollo y pruebas.

## 🔑 Variables de Entorno (`.env`)

| Variable | Valor por Defecto | Descripción |
| :--- | :--- | :--- |
| `BASE_URL` | `http://sanluiscloud.ddns.net/ords/sanluiscloud/` | URL base para las peticiones REST a Oracle ORDS. |
| `LOGIN_PATH` | `mobile/login` | Endpoint relativo para autenticación de usuarios. |
| `SISORG_ID` | `14` | Identificador numérico (`NUMBER`) de la organización, requerido en queries ORDS (`catalogo`, `pedidos`, etc.). |
| `SISORG_CODIGO` | `CTRO` | Código alfanumérico (`VARCHAR2`) de la organización, utilizado para el payload del login. |
| `JWT_EXPIRATION_MINUTES` | `480` | Duración en minutos del token de sesión. |
| `SYNCED_ORDERS_RETENTION` | `30d` | Período de retención de pedidos sincronizados offline. |

---

## ⚠️ Aprendizaje Crítico: Código (`SISORG_CODIGO`) vs Identificador Numérico (`SISORG_ID`)

### Causa del Fallo:
Al fijar la organización desde `.env` para simplificar el login, se introdujo `SISORG_CODIGO=CTRO`. Cuando la pantalla de catálogo (`/mobile/catalogo`) realizaba la petición, tomaba por fallback el valor de organización desde `SISORG_CODIGO` e inyectaba `?sisorg_id=CTRO` en la query HTTP.

### Efecto y Diagnóstico:
1. En la base de datos Oracle, el parámetro `:sisorg_id` está tipado como `NUMBER`.
2. Al recibir `'CTRO'`, el motor SQL intenta convertir la cadena a número y lanza `ORA-01722: invalid number`.
3. ORDS captura este error de base de datos y responde con `HTTP 500 Internal Server Error`.
4. El catálogo fallaba informando error de servidor aun cuando el backend estaba completamente operativo.

### Regla de Implementación:
- **`SISORG_CODIGO`** (ej. `'CTRO'`): Utilizado **únicamente** en el cuerpo (`payload`) del POST de login (`organizacion`).
- **`SISORG_ID`** (ej. `'14'`): Utilizado en **todos** los query parameters de ORDS (`?sisorg_id=...`).
- El servicio `ApiService` debe validar con `int.tryParse()` que cualquier valor enviado como `sisorg_id` sea estrictamente numérico antes de realizar la petición HTTP.

---

## 🛠️ Uso en el Código Dart

Para acceder a estas variables mediante el paquete `flutter_dotenv`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Obtención del ID de organización de prueba
final String sisOrgId = dotenv.env['G_SISORG_ID'] ?? '14'; //'10'; //para CENTRO

```
