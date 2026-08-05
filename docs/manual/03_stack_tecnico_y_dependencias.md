# 🛠️ Subdocumento 03: Stack Técnico, Librerías y Justificación de Tecnologías

Este documento detalla cada una de las tecnologías, librerías de terceros y herramientas utilizadas en la aplicación de **Preventas**, explicando el **porqué de su elección** frente a alternativas del ecosistema.

---

## 🧰 1. Matriz de Tecnologías y Librerías Principales

| Categoría | Tecnología / Librería | Versión | Justificación Técnica de Elección |
| :--- | :--- | :--- | :--- |
| **Framework Core** | `Flutter SDK` | `^3.11.3` | Multiplataforma nativo (Android, Windows, Web) con alto rendimiento gráfico y ecosistema maduro. |
| **Lenguaje** | `Dart` | `^3.11.3` | Compilación AOT a código binario nativo, seguridad de nulos (Sound Null Safety) y rendimiento predictivo. |
| **Gestión de Estado** | `provider` | `^6.1.5+1` | Recomendado oficialmente por la documentación de Flutter. Liviano, basado en `InheritedWidget`, sin sobrecarga de código repetitivo (*boilerplate*) respecto a BLoC/Redux. |
| **Cliente HTTP** | `dio` | `^5.9.2` | Soporte nativo para interceptores, tiempos de espera configurables (`connectTimeout`, `receiveTimeout`), cancelación de peticiones y manejo avanzado de errores respecto a `http`. |
| **Persistencia Local** | `drift` + `sqflite` | `^2.17.0` | ORM relacional tipado para SQLite. Garantiza consultas reactivas (`watch()`), soporte transaccional y validación de tipos en tiempo de compilación. |
| **Detección de Red** | `connectivity_plus` | `^6.1.5` | Plugin multiplataforma estándar de Flutter Community para monitorear Wi-Fi, Datos Móviles y Ethernet en tiempo real. |
| **Variables de Entorno**| `flutter_dotenv` | `^6.0.0` | Carga segura de variables de configuración (`.env`) en tiempo de ejecución sin hardcodear URLs o tokens en el código fuente. |
| **Generador de Código** | `build_runner` + `drift_dev` | Late | Generación automática de código fuertemente tipado para las tablas e índices de Drift. |
| **Pruebas** | `test` + `flutter_test` | `^1.25.8` | Framework oficial para ejecutar pruebas unitarias, de integración y de widgets en aislamiento. |

---

## ⚖️ 2. Comparativa y Justificación de Elección

### A. ¿Por qué `Provider` frente a `BLoC` o `Riverpod`?
- **Escala del Proyecto:** El sistema de preventas requiere un manejo claro de estado por vista (Autenticación, Lista de Pedidos, Sincronización) sin la alta complejidad de archivos y eventos formales que exige BLoC.
- **Curva de Aprendizaje y Mantenibilidad:** Provider permite utilizar `ChangeNotifier` e `InheritedWidget` de forma directa, acelerando la incorporación de nuevos desarrolladores al equipo.

### B. ¿Por me `Drift (SQLite)` frente a `Hive` o `SharedPreferences`?
- **Estructura Relacional Integrada:** Los pedidos contienen cabeceras e ítems asociados en relación 1-a-N. SharedPreferences es clave-valor simple y Hive no cuenta con motor de consultas SQL relacionales nativas ni restricciones de clave foránea en cascada (`KeyAction.cascade`).
- **Consultas Reactivas (`Streams`):** Drift ofrece métodos como `watchAllLocalOrders()` que emiten un nuevo evento en tiempo real cada vez que se inserta o modifica una fila en la base de datos SQLite.

### C. ¿Por qué `Dio` frente al paquete `http` estándar?
- **Interceptores de Seguridad y Logging:** Dio permite adjuntar tokens Bearer y headers corporativos (`G_SISORG_ID`) automáticamente en cada petición mediante interceptores sin duplicar código en las llamadas HTTP.
- **Tiempos de Espera (Timeouts):** Permite abortar peticiones colgadas en redes 3G/4G inestables mediante `Duration(seconds: 10)`.

---

## 📦 3. Configuración en `pubspec.yaml`

Ubicación: [`pubspec.yaml`](file:///c:/Projects/Frontend/flutter/preventas/pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^6.0.0
  provider: ^6.1.5+1
  dio: ^5.9.2
  drift: ^2.17.0
  sqflite: ^2.4.1
  drift_sqflite: ^2.0.0
  path_provider: ^2.1.3
  connectivity_plus: ^6.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  test: ^1.25.8
  build_runner: ^2.4.9
  drift_dev: ^2.17.0
```
