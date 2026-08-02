# Formato de Respuesta del Catálogo (Oracle ORDS)

Este documento registra la estructura de datos estandarizada para las respuestas paginadas del catálogo (`/mobile/catalogo`) provenientes de los servicios REST de Oracle ORDS.

## 📄 Estructura de Respuesta JSON

```json
{
  "items": [],
  "hasMore": false,
  "limit": 25,
  "offset": 0,
  "count": 0,
  "links": [
    {
      "rel": "self",
      "href": "http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/catalogo"
    },
    {
      "rel": "describedby",
      "href": "http://sanluiscloud.ddns.net/ords/sanluiscloud/metadata-catalog/mobile/item"
    },
    {
      "rel": "first",
      "href": "http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/catalogo"
    }
  ]
}
```

## 🔍 Descripción de los Campos

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| `items` | `List<dynamic>` | Lista con los elementos o ítems del catálogo devueltos en la página actual. |
| `hasMore` | `bool` | Indica si existen más páginas de datos disponibles (`true` / `false`). |
| `limit` | `int` | Cantidad máxima de registros configurada por página (ej. 25). |
| `offset` | `int` | Desplazamiento o número de registro inicial para la consulta actual. |
| `count` | `int` | Cantidad de registros retornados en la respuesta actual. |
| `links` | `List<Map>` | Enlaces de navegación hipermedia HATEOAS (`self`, `describedby`, `first`, `next`, etc.). |

---

## 🛠️ Adaptación a Flutter (Dart)

Para mapear esta respuesta en la capa de datos de Flutter:

```dart
import 'package:flutter/foundation.dart';

@immutable
class CatalogoResponse<T> {
  final List<T> items;
  final bool hasMore;
  final int limit;
  final int offset;
  final int count;
  final List<CatalogoLink> links;

  const CatalogoResponse({
    required this.items,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  factory CatalogoResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    return CatalogoResponse<T>(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => itemFromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      hasMore: json['hasMore'] as bool? ?? false,
      limit: json['limit'] as int? ?? 25,
      offset: json['offset'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
      links: (json['links'] as List<dynamic>?)
              ?.map((link) => CatalogoLink.fromJson(link as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

@immutable
class CatalogoLink {
  final String rel;
  final String href;

  const CatalogoLink({
    required this.rel,
    required this.href,
  });

  factory CatalogoLink.fromJson(Map<String, dynamic> json) {
    return CatalogoLink(
      rel: json['rel'] as String? ?? '',
      href: json['href'] as String? ?? '',
    );
  }
}
```
