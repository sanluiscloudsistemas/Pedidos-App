# Regla de Prevención: Subtipos Nulos en Dart / Flutter

Para prevenir excepciones en tiempo de ejecución del tipo:
`type 'Null' is not a subtype of type 'String' of 'function result'`
o
`type 'Null' is not a subtype of type 'bool' of 'function result'`

## Directrices Mandatorias de Código:

1. **DropdownButton:**
   - Prohibido pasar `DropdownMenuItem<String>(value: null)`. Si la lista de opciones está vacía o cargando, se debe asignar `items: null` al `DropdownButton` y mostrar el estado mediante `hint: Text('...')`.
   - Validar que `value` esté contenido en la lista (`items.contains(value) ? value : null`) antes de asignarlo.

2. **Callbacks (`onChanged`, `onTap`, `validator`):**
   - Prohibido forzar el desempaquetado con `!` en variables que puedan ser nulas (`val!`). Usar siempre guardas condicionales (`if (val != null)`).

3. **Mapeo de Datos (JSON / Entidades):**
   - Prohibido hacer cast directo `json['campo'] as String` sin soporte de nulos. Usar siempre `json['campo']?.toString() ?? ''` o tipos opcionales `String?`.
