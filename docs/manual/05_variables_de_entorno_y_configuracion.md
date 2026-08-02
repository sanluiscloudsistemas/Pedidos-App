# 🔑 Subdocumento 05: Variables de Entorno y Configuración del Sistema

Este documento describe la gestión de variables de entorno mediante el archivo `.env`, la inyección segura en tiempo de ejecución, la integración con `pubspec.yaml` y las estrategias para alternar entre entornos de desarrollo, homologación (QA) y producción.

---

## 📄 1. Estructura del Archivo `.env`

Ubicación: [`.env`](file:///c:/Projects/Frontend/flutter/preventas/.env)

El archivo `.env` almacena los valores de configuración específicos del servidor backend ORDS y parámetros de la organización:

```env
BASE_URL=http://sanluiscloud.ddns.net/ords/sanluiscloud/
LOGIN_PATH=mobile/login
G_SISORG_ID=14
```

### Descripción de Parámetros:

- **`BASE_URL`:** Dirección IP / Dominio base del servidor de API REST Oracle ORDS.
- **`LOGIN_PATH`:** Endpoint relativo para el proceso de autenticación de preventistas.
- **`G_SISORG_ID`:** Identificador numérico global de la organización o unidad de negocio.

---

## 🔒 2. Carga en Tiempo de Ejecución con `flutter_dotenv`

### A. Registro en `pubspec.yaml`
Para que Flutter incluya el archivo `.env` dentro del paquete final de la aplicación (*APK/IPA/Executable*), el archivo está declarado explícitamente en el bloque `assets`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
```

### B. Inicialización en `main()`
En [`main.dart`](file:///c:/Projects/Frontend/flutter/preventas/lib/main.dart), el archivo se lee de forma asíncrona antes de iniciar el árbol de widgets:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // ...
}
```

---

## 🧪 3. Inyección en Pruebas Unitarias

En el entorno de pruebas unitarias (`flutter test`), el archivo de entorno se inicializa mediante la ruta del archivo real o mediante carga directa de strings de prueba:

```dart
setUp(() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
});
```

Esto previene el error `NotInitializedError: dotenv.env is not initialized` al ejecutar la suite de pruebas automatizadas.

---

## 🌐 4. Estrategia Multiam biente (Desarrollo vs. QA vs. Producción)

Para alternar entre diferentes entornos de despliegue, se recomienda utilizar archivos de entorno independientes:

- `.env.dev`: `http://dev-sanluiscloud.ddns.net/ords/`
- `.env.qa`: `http://qa-sanluiscloud.ddns.net/ords/`
- `.env.prod`: `https://api.sanluiscloudsistemas.com/ords/`

Se puede pasar el parámetro `--dart-define` al compilar:
```bash
flutter run --dart-define=ENV_FILE=.env.qa
```
