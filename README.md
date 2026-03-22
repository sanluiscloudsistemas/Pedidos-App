# Preventa

Aplicación Flutter para la gestión de preventas. Este proyecto está diseñado para funcionar con una API REST de Oracle y utiliza una base de datos local SQLite para el almacenamiento persistente.

## Requisitos Previos

- **Flutter SDK**: ^3.11.3
- **Dart SDK**: Compatible con la versión de Flutter mencionada.

## Instalación

1. **Clonar el proyecto** en su máquina local.
2. **Obtener las dependencias**:
   ```powershell
   flutter pub get
   ```

## Configuración del Entorno

La aplicación utiliza variables de entorno para configurar las URLs de la API.

1. Localice el archivo `.env` en la raíz del proyecto.
2. Asegúrese de que contenga la URL correcta de la API:
   ```env
   API_URL=http://sanluiscloud.ddns.net/ords/sanluiscloud/hr
   ```

## Generación de Base de Datos (Drift)

Este proyecto utiliza `drift` para la persistencia de datos. Siempre que se realicen cambios en las tablas o el esquema de la base de datos, es necesario ejecutar el generador de código:

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

## Ejecución

Para iniciar la aplicación en un dispositivo o emulador:

```powershell
flutter run
```

## Documentación de API (openspec)

Las especificaciones de la API se encuentran en el directorio `docs/api`. Estas especificaciones siguen el estándar OpenAPI 3.0 y se pueden encontrar en el archivo [openapi.yaml](docs/api/openapi.yaml).

---
> [!NOTE]
> Este archivo se actualiza continuamente a medida que el proyecto evoluciona con nuevas funcionalidades y requisitos.
