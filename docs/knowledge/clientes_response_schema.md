# Formato de Respuesta de Clientes (Oracle ORDS)

Este documento registra la estructura de datos estandarizada para las respuestas paginadas del servicio de clientes (`/mobile/clientes`) provenientes de Oracle ORDS.

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
      "href": "http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/clientes"
    },
    {
      "rel": "describedby",
      "href": "http://sanluiscloud.ddns.net/ords/sanluiscloud/metadata-catalog/mobile/item"
    },
    {
      "rel": "first",
      "href": "http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/clientes"
    }
  ]
}
```

## 🔍 Descripción de los Campos

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| `items` | `List<dynamic>` | Colección de clientes retornados en la página actual. |
| `hasMore` | `bool` | Indica si existen más registros de clientes por consultar. |
| `limit` | `int` | Límite máximo de elementos por página. |
| `offset` | `int` | Índice o número de registro inicial de la consulta. |
| `count` | `int` | Cantidad total de clientes retornados en el lote actual. |
| `links` | `List<Map>` | Enlaces de navegación hipermedia HATEOAS (`self`, `describedby`, `first`). |

---

## 🛠️ Modelo Genérico Recomendado en Dart

Al compartir la envolvente estándar de Oracle ORDS, este servicio utiliza la misma clase genérica inmutable en Flutter:

```dart
import 'package:flutter/foundation.dart';

@immutable
class OrdsPaginatedResponse<T> {
  final List<T> items;
  final bool hasMore;
  final int limit;
  final int offset;
  final int count;
  final List<OrdsLink> links;

  const OrdsPaginatedResponse({
    required this.items,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  factory OrdsPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    return OrdsPaginatedResponse<T>(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => itemFromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      hasMore: json['hasMore'] as bool? ?? false,
      limit: json['limit'] as int? ?? 25,
      offset: json['offset'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
      links: (json['links'] as List<dynamic>?)
              ?.map((link) => OrdsLink.fromJson(link as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

@immutable
class OrdsLink {
  final String rel;
  final String href;

  const OrdsLink({
    required this.rel,
    required this.href,
  });

  factory OrdsLink.fromJson(Map<String, dynamic> json) {
    return OrdsLink(
      rel: json['rel'] as String? ?? '',
      href: json['href'] as String? ?? '',
    );
  }
}
```
