---
name: "flutter-descomposicion-codigo-general"
description: "Aplica principios de responsabilidad única y separación por capas (Domain, Data, Presentation, Feature-First, Use Cases, Repository Pattern, SOLID) a toda la base de código de Flutter más allá de los widgets."
---

# Skill: Descomposición de Código en Flutter (más allá de los Widgets)

Los mismos principios de responsabilidad única y composición aplican a **toda la base de código**, no solo al árbol de widgets: servicios, repositorios, lógica de negocio y gestión de estado.

---

## 🏗️ Principio base
**Separación por capas y responsabilidades**: Cada clase/archivo debe tener un único motivo de cambio, y las capas de UI, lógica de negocio y datos deben poder evolucionar de forma independiente.

---

## 🧩 Patrones aplicables

### 1. Arquitectura en capas (Clean Architecture / Layered Architecture)
Divide el código en capas con responsabilidades claras:
- **Presentation**: widgets + gestión de estado (Bloc/Provider/Riverpod/Cubit). Solo reacciona a estado y dispara eventos.
- **Domain**: entidades, casos de uso (*use cases*), reglas de negocio puras — sin dependencias de Flutter.
- **Data**: repositorios, fuentes de datos (API, base local), mapeo de modelos.

> **Regla práctica**: Si un `Bloc`/`Provider` llama directamente a un paquete `http` o a SQLite, falta una capa de repositorio en el medio.

### 2. Repository Pattern
Encapsula el acceso a datos (API, caché, DB local) detrás de una interfaz. La UI y la lógica de negocio no saben de dónde vienen los datos.

**Señal para aplicar**: Si la misma llamada a API/DB se repite en varios lugares, o si testear la lógica de negocio requiere mockear HTTP directamente.

### 3. Use Cases / Interactors
Cada acción de negocio relevante (ej. `LoginUseCase`, `FetchOrdersUseCase`) se extrae en su propia clase con un único método (`call()` o `execute()`). Evita que el `Bloc`/`ViewModel` acumule decenas de métodos con lógica de negocio mezclada.

**Señal para aplicar**: Un `Bloc`/`Controller` con muchos métodos privados de lógica compleja que no dependen de Flutter.

### 4. State Management como separación de responsabilidades
Independientemente del framework elegido (Bloc, Riverpod, Provider, Cubit), su función es sacar el estado y la lógica del widget para que este quede "tonto" (solo `build()`).

**Señal para aplicar**: `StatefulWidget` con múltiples variables de estado, `setState` disperso y lógica condicional extensa dentro del widget.

### 5. Single Responsibility a nivel de archivo/clase (SOLID)
Aplicar los principios SOLID como guía general, en particular:
- **S**: Una clase, un motivo de cambio.
- **O**: Extender comportamiento sin modificar código existente (ej. vía interfaces/estrategias).
- **D**: Depender de abstracciones (interfaces de repositorio), no de implementaciones concretas — facilita testing y mocking.

### 6. Organización por Feature (Feature-first / Modular Structure)
En vez de organizar carpetas por tipo técnico (`widgets/`, `models/`, `services/` a nivel global), organizar por feature/dominio, y dentro de cada feature aplicar las capas anteriores:
```
lib/
  src/
    features/
      orders/
        presentation/   (widgets, state)
        domain/         (entities, use_cases)
        data/           (repository_impl, data_sources)
```
Facilita la reutilización, el testing aislado y evita archivos gigantes por acumulación de responsabilidades no relacionadas.

---

## 📋 Checklist de refactor (código general)
- [ ] ¿La clase de estado (Bloc/Controller) contiene lógica de negocio compleja? → Extraer a Use Case.
- [ ] ¿Hay llamadas directas a API/DB fuera de un repositorio? → Introducir Repository Pattern.
- [ ] ¿El widget tiene lógica condicional de negocio (no solo de UI)? → Moverla a la capa de dominio/estado.
- [ ] ¿Una clase depende de una implementación concreta en vez de una interfaz? → Aplicar Dependency Inversion.
- [ ] ¿La carpeta mezcla features distintas? → Reorganizar a estructura feature-first.

---

## 🔍 Términos de búsqueda recomendados
`clean architecture flutter`, `repository pattern flutter`, `use case pattern flutter`, `feature-first folder structure flutter`, `SOLID principles flutter`, `bloc separation of concerns`.
