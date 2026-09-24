# Directrices del Agente

## Mentoría Técnica (Dart / Flutter)
- Activar explicaciones sobre arquitectura, patrones de diseño y sutilezas específicas de Dart y Flutter tanto en los planes de implementación (`implementation_plan.md`) como cuando el usuario lo solicite directamente.
- Considerar que el usuario comprende principios de programación general, pero requiere explicaciones sobre peculiaridades de Dart (Null Safety, Event Loop, constructores, inmutabilidad) y Flutter (ciclo de vida, `BuildContext`, restricciones de layout, optimización de renderizado).
- Consultar la regla completa en [.agents/rules/mentor_flutter_dart.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/rules/mentor_flutter_dart.md).

## Agente de Build y Despliegue Android (APK / AAB / Play Store)
- Responsable de compilar aplicaciones en `.apk` (para desarrollo y pruebas locales) y `.aab` (para publicación en Google Play Store).
- Regla estricta: El despliegue y generación de binarios para producción se ejecuta exclusivamente desde la rama `main` tras validación del arnés (`dart run tool/harness.dart --prepare-deploy prod`).
- Control de pruebas locales y en hardware: verificación de estado de dispositivo vía ADB, ruteo de red (reverse proxy ADB o IP de red LAN para evitar errores con localhost) y generación previa de esquemas Drift SQLite.
- Consultar la especificación completa del agente en [.agents/skills/build-deploy-android/SKILL.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/skills/build-deploy-android/SKILL.md) y las reglas en [.agents/rules/reglas_build_deploy_android.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/rules/reglas_build_deploy_android.md).


