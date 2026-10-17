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

## Agente de Verificación de Calidad y Pruebas (Flutter QA Verifier)
- Responsable de ejecutar la verificación integral de calidad, análisis estático y pruebas del código tras finalizar cada requerimiento de desarrollo.
- Regla obligatoria: Ejecutar el análisis estático (`flutter analyze`), la suite de pruebas (`flutter test`) y la verificación de compilación (`assembleDebug` / `build bundle`) para garantizar que no existan errores de miembros no encontrados, sintaxis o ensamblado antes de dar por completada una tarea.
- Consultar la especificación completa en [.agents/skills/flutter-qa-verifier/SKILL.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/skills/flutter-qa-verifier/SKILL.md) y las directrices en [.agents/rules/regla_qa_verificacion_post_desarrollo.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/rules/regla_qa_verificacion_post_desarrollo.md).

## Agente Adversarial de Planificación (Adversarial Planner)
- Responsable de auditar y cuestionar exhaustivamente planes técnicos y de arquitectura antes de comenzar la codificación.
- Identifica asunciones no validadas, brechas en casos borde (offline/online, concurrencia, sincronización), sobreingeniería y deuda técnica.
- Consultar la especificación completa en [.agents/skills/adversarial-planner/SKILL.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/skills/adversarial-planner/SKILL.md).

## Agente Adversarial de Código (Adversarial Code Reviewer)
- Responsable de auditar el código desarrollado bajo la premisa de hallar defectos ocultos, fugas de memoria y debilidades estructurales.
- Evalúa el cumplimiento estricto de Null Safety, ciclo de vida de recursos Flutter (`dispose`), rendimiento de renderizado y separación de capas.
- Consultar la especificación completa en [.agents/skills/adversarial-code-reviewer/SKILL.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/skills/adversarial-code-reviewer/SKILL.md).

## Agente Adversarial de Aprobación (Adversarial Approver)
- Actúa como gatekeeper para validar el cumplimiento riguroso de criterios de aceptación BDD, ausencia de regresiones e integridad de pruebas.
- Emite veredicto formal vinculante (`RECHAZADO`, `APROBADO CONDICIONAL` o `APROBADO`) previo a considerar concluida cualquier implementación.
- Consultar la especificación completa en [.agents/skills/adversarial-approver/SKILL.md](file:///c:/Projects/Frontend/flutter/preventas/.agents/skills/adversarial-approver/SKILL.md).



