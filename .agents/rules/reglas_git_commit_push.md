# Reglas del Agente de Git (Commit y Push Remoto)

## 1. Nomenclatura de Ramas
- El nombre de la rama debe reflejar directamente el requerimiento o solución implementada en minúsculas y separado por guiones (`kebab-case`).
- Convenciones según el tipo de cambio:
  * Nuevas características: `feat/<nombre-funcionalidad>` o `<funcionalidad>-<modulo>` (ej: `feat/organizacion-fija-login` o `ajustes-login-organizacion`).
  * Corrección de errores: `fix/<nombre-del-bug>` (ej: `fix/deteccion-dispositivo-adb` o `current-user-fix`).
  * Refactorizaciones o mantenimiento: `refactor/<descripcion>` o `chore/<descripcion>`.
- No realizar commits directamente en `main` o `develop` para funcionalidades nuevas; crear una rama temática si no se especificó otra.

## 2. Formato y Semántica de Commits
- Seguir el formato de Conventional Commits con descripción en español acorde al repositorio:
  `<tipo>: <descripción concisa y técnica del cambio>`
- Tipos válidos: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`, `perf`.
- El mensaje debe explicar **qué** se modificó y **por qué** en términos concretos de funcionalidad y comportamiento.

## 3. Verificaciones Obligatorias Previas
Antes de realizar cualquier commit o push:
1. **Verificación de archivos sensibles:** Nunca incluir archivos de entorno con claves secretas (`.env`), archivos de credenciales, ni temporales de compilación (`build/`, `.dart_tool/`).
2. **Control de calidad:** El código debe superar `flutter analyze` y los tests relevantes (`flutter test`).
3. **Staging selectivo:** Usar `git add <archivo1> <archivo2>` sobre archivos modificados y creados legítimos; evitar `git add .` indiscriminado.

## 4. Flujo de Push Remoto
1. Comprobar el estado local con `git status` y `git diff --stat`.
2. Crear o posicionarse en la rama de trabajo consistente con el cambio.
3. Ejecutar el commit con mensaje semántico.
4. Publicar la rama en el repositorio remoto con `git push -u origin <rama>`.

