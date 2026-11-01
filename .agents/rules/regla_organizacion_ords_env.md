# Regla de Integración: Parámetros de Organización en Oracle ORDS y .env

## Contexto y Aprendizaje
Al configurar organizaciones fijas mediante variables de entorno en `.env`, existen dos conceptos diferenciados que no deben mezclarse:

1. **`SISORG_CODIGO` (Alfanumérico - VARCHAR2):**
   - Ejemplo: `'CTRO'`.
   - Se utiliza **exclusivamente** para autenticación en el endpoint `mobile/login` dentro del campo `organizacion` del JSON payload.
   
2. **`SISORG_ID` (Numérico - NUMBER):**
   - Ejemplo: `14`.
   - Requerido en **todos** los query parameters de consulta (`?sisorg_id=...`) en endpoints de Oracle APEX/ORDS (`mobile/catalogo`, `mobile/pedidos`, `mobile/clientes`, `mobile/repartos`, `mobile/faltantes`).

## Efecto del Fallo Registrado
Si un endpoint como `mobile/catalogo` recibe `?sisorg_id=CTRO` (por heredar erróneamente `SISORG_CODIGO` ante falta de sesión activa):
- Oracle SQL ejecuta `WHERE sisorg_id = :sisorg_id`.
- Al no poder convertir `'CTRO'` a `NUMBER`, lanza la excepción de base de datos `ORA-01722: invalid number`.
- ORDS retorna `HTTP 500 Internal Server Error`, dando la falsa impresión de que el servicio está caído o que no se encuentra la organización.

## Directriz de Implementación en Código
- En `ApiService`, el getter `sisorgId` debe resolver prioritariamente IDs numéricos (`int.tryParse(...) != null`) obtenidos de la sesión o de `dotenv.get('SISORG_ID')`, aplicando `'14'` como fallback seguro.
- Prohibido pasar cadenas no numéricas como valor del parámetro HTTP `sisorg_id`.

