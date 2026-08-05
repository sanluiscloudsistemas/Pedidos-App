# Variables de Entorno y Configuración Global

Este documento registra las variables de entorno utilizadas por la aplicación Flutter y sus valores predeterminados para entornos de desarrollo y pruebas.

## 🔑 Variables de Entorno (`.env`)

| Variable | Valor por Defecto | Descripción |
| :--- | :--- | :--- |
| `BASE_URL` | `http://sanluiscloud.ddns.net/ords/sanluiscloud/` | URL base para las peticiones REST a Oracle ORDS. |
| `LOGIN_PATH` | `mobile/login` | Endpoint relativo para autenticación de usuarios. |
| `G_SISORG_ID` | `14` | Variable global que indica la organización de prueba por defecto. |

---

## 🛠️ Uso en el Código Dart

Para acceder a estas variables mediante el paquete `flutter_dotenv`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Obtención del ID de organización de prueba
final String sisOrgId = dotenv.env['G_SISORG_ID'] ?? '14';
```
