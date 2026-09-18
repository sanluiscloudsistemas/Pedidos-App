# Manejo de Errores de Null Safety: "type 'Null' is not a subtype of type '<Type>' of 'function result'"

Este documento registra las causas recurrentes del error en tiempo de ejecución de Dart Null Safety y las directrices obligatorias para evitar introducirlo nuevamente en el proyecto.

---

## 🛑 Descripción del Error

```text
type 'Null' is not a subtype of type 'String' of 'function result'
type 'Null' is not a subtype of type 'bool' of 'function result'
```

En el sistema de tipos seguros de Dart, este error se produce cuando:
1. Un widget genérico tipado con un tipo no nullable (por ejemplo `DropdownButton<String>`) recibe un elemento con valor nulo (`DropdownMenuItem<String>(value: null)`).
2. Un callback o función cuya firma declara un retorno no nullable (`String` o `bool`) evalúa un flujo o expresión que resuelve a `null`.
3. Un operador de desenvolvimiento forzado (`!`) se aplica sobre un parámetro nulo (`val!`).
4. Un método de canal nativo (`MethodChannel.invokeMethod<String>`) o servicio externo retorna `null` y se tipa genéricamente sin el modificador de nulabilidad (`?`).

---

## 🔍 Causas Comunes y Correcciones Obligatorias

### 1. DropdownButton con Listas Vacías o Elementos Nulos

* ❌ **Incorrecto (Genera `type 'Null' is not a subtype of type 'String' of 'function result'`):**
  ```dart
  DropdownButton<String>(
    value: items.isEmpty ? null : value,
    items: items.isEmpty
        ? [
            DropdownMenuItem<String>(
              value: null, // ERROR: value nulo en un MenuItem tipado como String
              child: Text('No hay datos'),
            )
          ]
        : items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
    onChanged: onChanged,
  )
  ```

* ✅ **Correcto (Pasar `items: null` y usar la propiedad `hint`):**
  ```dart
  DropdownButton<String>(
    value: (items.contains(value)) ? value : null,
    hint: Text(isLoading ? 'Cargando...' : 'Seleccione una opción'),
    items: items.isEmpty
        ? null
        : items.map((it) => DropdownMenuItem<String>(value: it, child: Text(it))).toList(),
    onChanged: items.isEmpty ? null : onChanged,
  )
  ```

---

### 2. Callbacks con Forzado de Desempaquetado (`!`)

* ❌ **Incorrecto:**
  ```dart
  onChanged: (val) => setState(() => _selectedItem = val!),
  ```

* ✅ **Correcto:**
  ```dart
  onChanged: (val) {
    if (val != null) {
      setState(() => _selectedItem = val);
    }
  },
  ```

---

### 3. Parseo de Strings y Mapeo de Diccionarios JSON

* ❌ **Incorrecto:**
  ```dart
  String codigo = json['codigo']; // Falla si el json no contiene la clave o es nula
  ```

* ✅ **Correcto:**
  ```dart
  String codigo = json['codigo']?.toString() ?? '';
  ```

---

## 📋 Reglas de Verificación Previa al Commit

1. **Nunca instanciar `DropdownMenuItem<T>(value: null)`** cuando `T` sea `String` u otro tipo no nullable. Cuando una lista desplegable esté vacía, asigne `items: null` y defina el texto descriptivo mediante `hint: Text(...)`.
2. **Evitar operadores `!` en callbacks de interfaz de usuario** (`onChanged`, `onTap`, `validator`). Siempre validar mediante `if (val != null)`.
3. **Mapear respuestas JSON con nulabilidad explícita o valores por defecto (`?? ''`, `?? 0`, `?? false`)**.
