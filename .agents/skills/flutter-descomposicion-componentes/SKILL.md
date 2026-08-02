---
name: "flutter-descomposicion-componentes"
description: "Subdivide widgets o componentes de Flutter complejos en piezas más pequeñas y componibles siguiendo la responsabilidad única, Smart vs Dumb (Presentational vs Container), Atomic Design y Widget Extraction."
---

# Skill: Descomposición de Componentes y Widgets en Flutter

Esta habilidad define la estrategia y los patrones recomendados para descomponer widgets monolíticos o complejos en piezas pequeñas, reutilizables y componibles.

---

## 🎯 Cuándo aplicar
Cuando un widget o componente crece demasiado (muchas responsabilidades, lógica mezclada con UI, difícil de testear o reutilizar), se debe subdividir en piezas más pequeñas y componibles.

---

## 🏗️ Principio base
**Responsabilidad única aplicada a UI**: cada componente/widget debe tener un único motivo para cambiar. La técnica general se llama **composición de componentes** (*component composition*) — construir piezas pequeñas y combinarlas en lugar de mantener un componente monolítico.

---

## 🧩 Patrones aplicables en Flutter

### 1. Presentational vs Container (Smart vs Dumb Widgets)
- **Presentacional / Dumb**: solo UI pura, recibe datos por parámetros del constructor, sin lógica de negocio ni estado propio relevante.
- **Contenedor / Smart**: maneja estado, lógica, llamadas a datos (providers, blocs, notifiers, etc.), y delega el renderizado a widgets presentacionales.

> **Regla práctica**: Si un widget mezcla `fetch`/estado con un `build()` complejo, separar en dos: uno que gestione datos/estado y otro que solo pinte.

### 2. Atomic Design (Jerarquía de composición)
Organiza los widgets en niveles crecientes de complejidad:
- **Átomos**: botones, inputs, textos con estilo — sin lógica propia.
- **Moléculas**: combinación de átomos con un propósito concreto (ej. campo de búsqueda = input + icono + botón).
- **Organismos**: secciones completas de UI (ej. AppBar personalizado, card de producto, tabla de datos).
- **Templates/Pages**: composición final de pantallas (screens).

Útil para decidir en qué "nivel" cortar un widget grande.

### 3. Widget Extraction (Especificidad en Flutter)
Nombre usado por la comunidad y el propio IDE (refactor *"Extract Widget"*). Regla: **todo es un widget**, y cada widget debe ser pequeño e inmutable siempre que sea posible.

**Señales para extraer un widget:**
- El método `build()` supera ~100-150 líneas.
- Hay bloques repetidos dentro del árbol de widgets.
- Existe lógica condicional compleja dentro del `build()`.
- Un sub-árbol podría reutilizarse en otra pantalla o sección.

### 4. Composition over Inheritance
Preferir componer widgets pequeños (pasándolos como `child` o `children`) en vez de heredar de una clase base con muchas variantes. Es la filosofía nativa de Flutter (`Widget` compone `Widget`).

---

## 📋 Checklist de Refactor y Revisión
- [ ] ¿El widget tiene más de una responsabilidad? → Separar.
- [ ] ¿Hay lógica de estado/datos mezclada con el árbol visual? → Aplicar Container / Presentational.
- [ ] ¿Se repite un bloque de UI en más de un lugar? → Extraer como widget reutilizable (`Extract Widget`).
- [ ] ¿El widget resultante es fácil de testear de forma aislada? → Si no, continuar dividiendo.

---

## 🔍 Términos de búsqueda recomendados
`component composition`, `presentational and container components`, `widget composition flutter`, `extract widget`, `atomic design flutter`.
