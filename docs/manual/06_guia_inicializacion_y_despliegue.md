# 🚀 Subdocumento 06: Guía de Inicialización Local, Compilación y Despliegue

Este documento proporciona la guía paso a paso para configurar el entorno de desarrollo local, instalar dependencias, generar código con `build_runner`, ejecutar la aplicación en Android/Windows/Web e instalarla en dispositivos físicos.

---

## 📋 1. Prerrequisitos del Entorno

Antes de comenzar, asegúrese de contar con los siguientes elementos instalados en el sistema operativo:

- **Flutter SDK:** Versión `^3.11.3` o superior (`flutter --version`).
- **Dart SDK:** Versión `^3.11.3` o superior.
- **Android Studio / VS Code:** Con los plugins de Flutter y Dart.
- **Android SDK & Build Tools:** API 34 (Android 14) o superior para despliegue en móviles.
- **Visual Studio Community (Opcional):** Con la carga de trabajo "Desarrollo para el escritorio con C++" si desea ejecutar en Windows nativo.

---

## 🛠️ 2. Guía Paso a Paso de Inicialización Local

### Paso 1: Clonar y Navegar al Proyecto
```bash
git clone <URL_REPOSITORIO>
cd preventas
```

### Paso 2: Instalar Dependencias de Flutter
```bash
flutter pub get
```

### Paso 3: Verificar Archivo `.env`
Asegúrese de que el archivo `.env` exista en la raíz del proyecto con la configuración de servidor backend.

### Paso 4: Generar Código de Drift SQLite (`build_runner`)
Dado que la aplicación utiliza **Drift** para la base de datos local, es obligatorio generar el archivo [`lib/data/datasources/local/app_database.g.dart`](file:///c:/Projects/Frontend/flutter/preventas/lib/data/datasources/local/app_database.g.dart):

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Paso 5: Instalar Git Hooks del Arnés
```bash
dart run tool/harness.dart --install-hooks
```

---

## 📱 3. Ejecución en Plataformas

### A. Ejecución en Dispositivo Físico Android (Vía USB)
1. Conecte el teléfono celular por USB.
2. Habilite en el teléfono:
   - **Opciones de desarrollador:** Activadas.
   - **Depuración por USB (USB Debugging):** ON.
   - **Instalar vía USB (Install via USB):** ON.
3. Verifique que Flutter detecte el dispositivo:
   ```bash
   flutter devices
   ```
4. Lance la aplicación en Android:
   ```bash
   flutter run -d android
   ```

### B. Ejecución en Windows Escritorio
```bash
flutter run -d windows
```

### C. Ejecución en Navegador Web (Google Chrome)
```bash
flutter run -d chrome
```

---

## 🧪 4. Ejecución de Pruebas y Análisis Estático

Para validar la calidad del código antes de enviar un commit:

```bash
# Análisis estático
flutter analyze

# Suite de pruebas unitarias y de widgets
flutter test

# Arnés en modo observador continuo
dart run tool/harness.dart --watch
```
