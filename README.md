# Preventa

Aplicación Flutter para la gestión de preventas. Este proyecto está diseñado para funcionar con una API REST de Oracle y utiliza una base de datos local SQLite para el almacenamiento persistente.

## Requisitos Previos

- **Flutter SDK**: ^3.11.3
- **Dart SDK**: Compatible con la versión de Flutter mencionada.

## Instalación e Inicialización

Siga estos pasos para dejar el entorno listo para el desarrollo:

1. **Clonar el proyecto** en su máquina local.
2. **Obtener las dependencias**:
   ```powershell
   flutter pub get
   ```
3. **Generar código de Base de Datos (Drift)**:
   Este paso es obligatorio para crear los archivos `.g.dart` necesarios para la persistencia local:
   ```powershell
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Instalar Skills del Agente** (Opcional - solo para asistencia IA):
   Para habilitar las herramientas extendidas del asistente:
   ```powershell
   npx skills install
   ```

## Configuración del Entorno

La aplicación utiliza variables de entorno para configurar las URLs de la API.

1. Localice o cree el archivo `.env` en la raíz del proyecto.
2. Asegúrese de que contenga la URL correcta de la API:
   ```env
   API_URL=http://sanluiscloud.ddns.net/ords/sanluiscloud/hr
   ```

## Ejecución

Para iniciar la aplicación en un dispositivo, emulador o escritorio:

```powershell
flutter run
```

## Documentación de API (openspec)

Las especificaciones de la API se encuentran en el directorio `docs/api`. Estas especificaciones siguen el estándar OpenAPI 3.0 y se pueden encontrar en el archivo [openapi.yaml](docs/api/openapi.yaml).

## Especificaciones de Comportamiento (Gherkin)

Este proyecto utiliza BDD (Behavior Driven Development). Las especificaciones de comportamiento se encuentran en el directorio `test/features` y siguen la sintaxis Gherkin.

- [login.feature](test/features/login.feature): Escenarios para la funcionalidad de inicio de sesión.
- [toma_de_pedidos.feature](test/features/toma_de_pedidos.feature): Escenarios para el flujo principal de toma de pedidos.

## Solución de Problemas (Troubleshooting)

### Error en Windows Desktop: `fatal error C1083: Cannot open include file: 'atlstr.h'`

Este error ocurre al compilar el plugin nativo `flutter_secure_storage_windows` debido a la ausencia de la biblioteca Active Template Library (ATL) de C++ en las herramientas de compilación de Visual Studio.

**Pasos para solucionarlo:**

1. Abra el instalador de Visual Studio ejecutando en la terminal (`pwsh`):
   ```powershell
   & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
   ```
2. En la ventana del instalador, localice su instalación de **Visual Studio Build Tools** (ej. 2019 o 2022) y haga clic en **Modificar**.
3. Vaya a la pestaña **Componentes individuales** (Individual components).
4. En el buscador escriba `ATL` y marque la casilla:
   - **C++ ATL para las herramientas de compilación de v142 (x86 y x64)** (o **v143** según su versión de herramientas).
5. Haga clic en el botón **Modificar** (abajo a la derecha) y espere a que finalice la descarga e instalación.
6. Cierre y vuelva a abrir la terminal de Antigravity / PowerShell y ejecute:
   ```powershell
   flutter run -d windows
   ```

### Persistencia Local Offline (Hive)

La persistencia local de pedidos, clientes y faltantes se gestiona con **Hive** (`hive` y `hive_flutter`), una base de datos ligera y 100% en Dart puro (sin SQLite ni dependencias nativas de C++). Esto permite la compatibilidad multiplataforma inmediata en Android, iOS, Windows y Web (IndexedDB) sin requerir compiladores de C++ para el motor de datos.

---
> [!NOTE]
> Este archivo se actualiza continuamente a medida que el proyecto evoluciona con nuevas funcionalidades y requisitos.

