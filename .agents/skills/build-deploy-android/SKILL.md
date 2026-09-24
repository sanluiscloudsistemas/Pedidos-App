---
name: "build-deploy-android"
description: "Agente para compilación de aplicaciones Android (.apk y .aab) en entornos de desarrollo y producción, y despliegue automatizado o asistido en Google Play Store desde la rama main."
---

# Agente de Build y Despliegue Android (APK / AAB / Play Store)

Este agente gobierna el ciclo de empaquetado y distribución de la aplicación Flutter para la plataforma Android.

---

## 🎯 Capacidades y Responsabilidades

1. **Generación de Artefactos de Desarrollo (.apk):**
   - Compilación rápida en modo depuración o perfil (`debug`/`profile`).
   - Generación de APKs universales o segmentados por arquitectura (`split-per-abi`) para pruebas en dispositivos físicos.
2. **Generación de Artefactos de Producción (.aab / .apk release):**
   - Compilación exclusiva desde la rama `main`.
   - Generación del Android App Bundle (`.aab`) requerido por Google Play.
   - Verificación de firmado con release keystore y claves de producción.
   - Validación de versión y código de compilación (`versionCode` y `versionName`).
3. **Pruebas y Ejecución en Desarrollo (Host y Dispositivos Conectados):**
   - Validación previa de entorno host (Windows/Chrome/Emulador) y regeneración de artefactos de base de datos.
   - Verificación de prerrequisitos en dispositivos físicos (ADB, depuración USB, autorización de clave RSA).
   - Enrutamiento de red y backend (reverse proxy ADB o IP de red LAN para evitar errores con `localhost`).
   - Despliegue en caliente (`flutter run`) o instalación directa (`adb install -r`).
4. **Despliegue en Google Play Store:**
   - Verificación de pistas de publicación (Internal Testing, Closed Testing / Alpha, Open Testing / Beta, Production).
   - Automatización de subida mediante Fastlane o checklist asistido con validación de hash SHA-256 y notas de versión (*What's New*).

---

## 🌿 Política de Ramas y Entornos

| Entorno | Rama Permitida | Formato de Salida | Propósito | Comando Base |
| :--- | :--- | :--- | :--- | :--- |
| **Desarrollo (Host / Dispositivo Físico)** | `dev`, `feature/*`, `fix/*` | `.apk` (`debug` o `profile`) / Ejecución directa | Pruebas locales y QA en hardware | `flutter run -d <device>` o `flutter build apk --debug` |
| **Producción** | `main` (estricto) | `.aab` (firmado con release keystore) | Publicación en Google Play Store | `flutter build appbundle --release` |


> [!CRITICAL]
> Queda prohibido generar artefactos para Play Store desde ramas que no sean `main`. Si el desarrollador solicita empaquetar para producción estando en otra rama, el agente debe advertir y solicitar cambiar o mergear hacia `main`.

---

## 🛠️ Procedimientos de Compilación

### 1. Compilación de Desarrollo (.apk)

1. Verificar análisis y tests locales:
   ```bash
   flutter analyze
   flutter test
   ```
2. Generar APK universal de depuración:
   ```bash
   flutter build apk --debug
   ```
   Ruta de salida: `build/app/outputs/flutter-apk/app-debug.apk`

3. Generar APKs optimizados por arquitectura (menor peso de descarga):
   ```bash
   flutter build apk --release --split-per-abi
   ```
   Rutas de salida:
   - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
   - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
   - `build/app/outputs/flutter-apk/app-x86_64-release.apk`

---

### 2. Compilación de Producción (.aab)

1. Comprobar que la rama actual sea `main`:
   ```bash
   git branch --show-current
   ```
2. Verificar que el árbol de trabajo esté limpio:
   ```bash
   git status --porcelain
   ```
3. Ejecutar validaciones del arnés de desarrollo:
   ```bash
   dart run tool/harness.dart --prepare-deploy prod
   ```
4. Actualizar número de versión en `pubspec.yaml` (ej. `version: 1.0.1+2`):
   - El `versionCode` (entero después del `+`) debe ser estrictamente incremental para Google Play.
5. Verificar existencia de `android/key.properties` y archivo keystore.
6. Generar el App Bundle:
   ```bash
   flutter build appbundle --release
   ```
   Ruta de salida: `build/app/outputs/bundle/release/app-release.aab`

---

## 🔐 Configuración de Firma (Release Signing)

### Estructura de `android/key.properties` (Ignorado en Git):
```properties
storePassword=PASSWORD_DEL_KEYSTORE
keyPassword=PASSWORD_DE_LA_CLAVE
keyAlias=ALIAS_DE_LA_CLAVE
storeFile=../upload-keystore.jks
```

### Configuración en `android/app/build.gradle.kts`:
```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        create("release") {
            val keyProps = rootProject.file("key.properties")
            if (keyProps.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }
    buildTypes {
        release {
            val keyProps = rootProject.file("key.properties")
            if (keyProps.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}
```

---

## 🚀 Despliegue en Google Play Store

### Vía Fastlane (Recomendado para CI/CD y despliegue rápido):
1. Prerrequisito: Credencial JSON de cuenta de servicio de Google Cloud Console guardada de forma segura (ej. `android/play-service-account.json` excluida de git).
2. Comando de publicación a pista de pruebas interna:
   ```bash
   bundle exec fastlane supply --aab build/app/outputs/bundle/release/app-release.aab --track internal --json_key android/play-service-account.json --package_name com.sanluiscloud.preventa
   ```

### Checklist para Carga Manual en Play Console:
1. Validar que la compilación se realizó sobre el último commit de `main`.
2. Verificar el tamaño del `.aab` generado.
3. Ingresar a Google Play Console -> Seleccionar Aplicación -> **Pruebas internas** o **Producción**.
4. Crear nueva versión y subir `build/app/outputs/bundle/release/app-release.aab`.
5. Adjuntar notas de la versión en formato texto.
6. Guardar y enviar a revisión.

---

## 🧪 Condiciones y Protocolo de Pruebas

### 1. Pruebas en el Equipo de Desarrollo (Host Local: Windows / Web / Emulador)

#### Condiciones Previas:
- **Archivo de Configuración:** `.env` activo apuntando a entornos locales o de desarrollo (ej. API Mock u ORDS de desarrollo).
- **Esquema de Base de Datos Drift SQLite:** Generar o sincronizar el archivo de código generado antes de lanzar:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- **Mapeo de Red en Emuladores Android:** Si se utiliza un emulador AVD y el backend corre en la máquina de desarrollo, la IP a utilizar en `.env` debe ser `10.0.2.2` en lugar de `localhost`.

#### Comandos de Ejecución en Host:
- **Windows Nativo:**
  ```bash
  flutter run -d windows
  ```
- **Navegador Web (Chrome):**
  ```bash
  flutter run -d chrome
  ```
- **Emulador Android:**
  ```bash
  flutter emulators --launch <EMULATOR_ID>
  flutter run -d <EMULATOR_ID>
  ```

---

### 2. Pruebas en Dispositivos Físicos Conectados (USB / Wi-Fi ADB)

#### Condiciones Previas del Dispositivo:
1. **Opciones de Desarrollador Activas:**
   - Ir a `Ajustes > Información del teléfono` y presionar 7 veces sobre `Número de compilación`.
2. **Depuración USB Activada:**
   - Habilitar `Depuración por USB` en `Opciones de desarrollador`.
   - Activar `Instalar aplicaciones vía USB` (necesario en dispositivos Xiaomi/MIUI, Samsung, Oppo, etc.).
3. **Autorización de Clave RSA:**
   - Al conectar el cable USB, aceptar el diálogo emergente en el teléfono: *"¿Permitir depuración por USB desde esta computadora?"*.
4. **Verificación de Conexión en Consola:**
   ```bash
   adb devices
   ```
   *El dispositivo debe aparecer con estado `device` (no `unauthorized` ni `offline`).*
   ```bash
   flutter devices
   ```

#### Condiciones de Red y Backend para Dispositivos Físicos:
> [!WARNING]
> Un dispositivo físico conectado por USB **NO** puede resolver `localhost` ni `127.0.0.1` de la computadora directamente.

- **Método A (Túnel Reverse ADB - Recomendado si el backend corre en la PC):**
  Redirige las peticiones del puerto del backend (ej. 8080) desde el teléfono hacia la computadora:
  ```bash
  adb reverse tcp:8080 tcp:8080
  ```
  Permite que la app en el dispositivo use `http://localhost:8080`.
- **Método B (Red LAN Compartida):**
  Tanto la computadora como el teléfono deben estar conectados a la misma red Wi-Fi. Configurar en `.env` la IP local de la computadora (ej. `http://192.168.1.150:8080`) y verificar que el firewall de Windows permita tráfico entrante en ese puerto.

#### Modos de Lanzamiento en Dispositivo Conectado:
- **Modo Depuración (Desarrollo y Hot Reload):**
  ```bash
  flutter run -d <DEVICE_ID>
  ```
- **Modo Perfil (Medición de rendimiento real y consumo de memoria):**
  ```bash
  flutter run --profile -d <DEVICE_ID>
  ```
- **Instalación directa de APK compilado previamente:**
  ```bash
  adb install -r build/app/outputs/flutter-apk/app-debug.apk
  ```

#### Limpieza y Resolución de Conflictos:
- **Conflicto de Firmas:** Si el dispositivo tiene una versión previa con otra firma (ej. release previa vs debug actual), desinstalar antes de ejecutar:
  ```bash
  adb uninstall com.sanluiscloud.preventa
  ```
- **Prueba de Estado Inicial Limpio:** Para limpiar la base de datos local SQLite y Hive en el dispositivo sin reinstalar:
  ```bash
  adb shell pm clear com.sanluiscloud.preventa
  ```

