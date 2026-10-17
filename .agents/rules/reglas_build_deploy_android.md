# Reglas de Compilación y Despliegue Android

## 1. Restricción de Entornos y Ramas
- **Producción:** Todo artefacto destinado a publicación o distribución final (`.aab` o `.apk` release firmado) **debe** generarse únicamente desde la rama `main`.
- **Desarrollo:** Las compilaciones de prueba (`.apk` en modo debug o split por ABI) pueden generarse en ramas de desarrollo o trabajo (`dev`, `feature/*`, `fix/*`).

## 2. Validación de Estado Antes de Compilar Producción
- El árbol de trabajo de Git debe estar limpio (`git status --porcelain` vacío).
- Debe ejecutarse la verificación del arnés antes de empaquetar para producción (`dart run tool/harness.dart --prepare-deploy prod`).
- El código de versión (`versionCode`) en `pubspec.yaml` debe incrementarse en cada entrega a Google Play.

## 3. Seguridad de Firmas y Secretos
- Prohibido versionar archivos `.jks`, `.keystore`, `key.properties` o archivos JSON de cuentas de servicio de Google Play en el repositorio Git.
- Verificar siempre que `.gitignore` contenga los patrones de exclusión correspondientes antes de añadir nuevos archivos al proyecto.

## 4. Condiciones para Pruebas en Host y Dispositivos Conectados
- **Verificación de Dispositivo:** Antes de lanzar pruebas o instalaciones en hardware conectado, verificar mediante `adb devices` que el terminal esté autorizado (`device`) y no en estado `unauthorized` u `offline`.
- **Enrutamiento de Red:** En dispositivos físicos conectados por USB, no emplear `localhost` directamente en `.env` sin activar el túnel de reenvío de puertos (`adb reverse tcp:<puerto> tcp:<puerto>`) o configurar la IP local de la red LAN de la computadora.
- **Aislamiento de Datos:** Prohibido apuntar aplicaciones de prueba en desarrollo a APIs o bases de datos de producción.

