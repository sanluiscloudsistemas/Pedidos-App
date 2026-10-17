# Regla Obligatoria: Verificación de Calidad y Pruebas Post-Desarrollo

Tras finalizar cualquier modificación de código en la aplicación móvil de Preventas:

1. **Análisis Estático Obligatorio:** Validar que los archivos editados no posean miembros inexistentes, imports no resueltos o errores de tipo.
2. **Suite de Pruebas:** Ejecutar o validar los tests de regresión pertinentes en `test/`.
3. **Validación de Compilación:** Asegurar que la aplicación ensamble limpiamente (`assembleDebug` / `kernel_snapshot_program`) sin excepciones de compilador ni Gradle.
4. **Cero Fugas a Producción:** Ninguna tarea se reportará como finalizada si existe un error de compilación o test roto.
