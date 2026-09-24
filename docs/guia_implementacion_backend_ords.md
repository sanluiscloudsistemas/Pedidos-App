# Guía de Implementación Backend: Endpoints REST en Oracle ORDS

**Esquema:** `SIS_SANLUISCLOUD`  
**Módulo REST:** `mobile/`  
**Archivo SQL Asociado:** [`script_endpoints_sincronizacion_ords.sql`](file:///c:/Projects/Frontend/flutter/preventas/docs/script_endpoints_sincronizacion_ords.sql)

Esta guía describe el procedimiento detallado para que el Administrador de Base de Datos (DBA) o el equipo de desarrollo backend implemente los servicios REST necesarios para la sincronización diaria offline de la aplicación de Preventas.

---

## 1. Requisitos Previos y Permisos

El usuario del esquema `SIS_SANLUISCLOUD` debe poseer permisos de ejecución sobre los paquetes del sistema de APEX y ORDS:

```sql
GRANT EXECUTE ON ORDS TO SIS_SANLUISCLOUD;
GRANT EXECUTE ON APEX_JSON TO SIS_SANLUISCLOUD;
GRANT EXECUTE ON APEX_JWT TO SIS_SANLUISCLOUD;
```

---

## 2. Métodos de Implementación

Existen dos alternativas para aplicar los cambios:

### Opción A: Ejecución Automatizada por Script (Recomendado)
Conectarse mediante **SQLcl** o **SQL*Plus** con el usuario del esquema y ejecutar el script provisto:

```bash
sqlcl SIS_SANLUISCLOUD/<password>@<tns_or_host> @docs/script_endpoints_sincronizacion_ords.sql
```

El script se encarga de:
1. Crear las tablas referenciales si no existen (`vtas_condiciones_venta`, `pre_faltantes`).
2. Compilar el paquete `pkg_preventas_mobile` (especificación y cuerpo).
3. Registrar los templates, handlers y parámetros directamente en el metadato de ORDS mediante llamadas al paquete `ORDS`.

---

### Opción B: Configuración Visual en Oracle APEX (Taller de RESTful Services)

Si prefiere administrar los servicios desde la interfaz web de Oracle APEX:

1. Iniciar sesión en el Workspace de APEX (`SANLUISCLOUD`).
2. Ir a **SQL Workshop** > **RESTful Services**.
3. Seleccionar el Módulo **`mobile`** (Base Path: `mobile/`).

#### Configuración Endpoint 1: `condiciones-venta`
- **Paso 1 - Crear Template:**
  - **URI Template:** `condiciones-venta`
  - **Comments:** Consulta de condiciones comerciales de pago.
- **Paso 2 - Crear Handler:**
  - **Method:** `GET`
  - **Source Type:** `PL/SQL`
  - **Source:**
    ```sql
    DECLARE
        v_cur    SYS_REFCURSOR;
        v_org_id NUMBER := NVL(TO_NUMBER(:sisorg_id), 14);
    BEGIN
        v_cur := pkg_preventas_mobile.f_get_condiciones_venta(p_sisorg_id => v_org_id);
        :status := 200;
        apex_json.open_object;
        apex_json.write('items', v_cur);
        apex_json.close_object;
    EXCEPTION
        WHEN OTHERS THEN
            :status := 500;
            apex_json.open_object;
            apex_json.write('success', false);
            apex_json.write('error', SQLERRM);
            apex_json.close_object;
    END;
    ```
- **Paso 3 - Crear Parámetro:**
  - **Name:** `sisorg_id`
  - **Bind Variable:** `sisorg_id`
  - **Source Type:** `HTTP Header` (o `Query String`)
  - **Access Method:** `IN`
  - **Data Type:** `STRING`

---

#### Configuración Endpoint 2: `faltantes`
- **Paso 1 - Crear Template:**
  - **URI Template:** `faltantes`
  - **Comments:** Consulta de faltantes reportados.
- **Paso 2 - Crear Handler:**
  - **Method:** `GET`
  - **Source Type:** `PL/SQL`
  - **Source:**
    ```sql
    DECLARE
        v_cur       SYS_REFCURSOR;
        v_org_id    NUMBER := NVL(TO_NUMBER(:sisorg_id), 14);
        v_dep_id    NUMBER := TO_NUMBER(:deposito_id);
        v_vend_id   NUMBER := TO_NUMBER(:vendedor_id);
        v_limit     NUMBER := NVL(TO_NUMBER(:limit), 50);
        v_offset    NUMBER := NVL(TO_NUMBER(:offset), 0);
    BEGIN
        v_cur := pkg_preventas_mobile.f_get_faltantes(
            p_sisorg_id   => v_org_id,
            p_deposito_id => v_dep_id,
            p_vendedor_id => v_vend_id,
            p_limit       => v_limit,
            p_offset      => v_offset
        );
        :status := 200;
        apex_json.open_object;
        apex_json.write('items', v_cur);
        apex_json.write('limit', v_limit);
        apex_json.write('offset', v_offset);
        apex_json.close_object;
    EXCEPTION
        WHEN OTHERS THEN
            :status := 500;
            apex_json.open_object;
            apex_json.write('success', false);
            apex_json.write('error', SQLERRM);
            apex_json.close_object;
    END;
    ```
- **Paso 3 - Crear Parámetros en ORDS:**
  - `sisorg_id`: Type `HTTP Header`, DataType `STRING`, Access `IN`.
  - `deposito_id`: Type `Query String`, DataType `STRING`, Access `IN`.
  - `vendedor_id`: Type `Query String`, DataType `STRING`, Access `IN`.
  - `limit`: Type `Query String`, DataType `INT`, Access `IN`.
  - `offset`: Type `Query String`, DataType `INT`, Access `IN`.

---

## 3. Pruebas y Validación de Conectividad

Una vez aplicados los cambios, verificar las respuestas desde terminal:

```bash
# 1. Probar Condiciones de Venta:
curl -i -X GET "http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/condiciones-venta" \
     -H "Authorization: Bearer <TOKEN_JWT>" \
     -H "sisorg_id: 14"

# Respuesta esperada:
# HTTP/1.1 200 OK
# {"items":[{"condicion_id":1,"codigo":"CNT","descripcion":"CONTADO","dias_plazo":0,"activo":"S"},{"condicion_id":2,"codigo":"CC","descripcion":"CUENTA CORRIENTE","dias_plazo":30,"activo":"S"}]}
```

```bash
# 2. Probar Consulta de Faltantes:
curl -i -X GET "http://sanluiscloud.ddns.net/ords/sanluiscloud/mobile/faltantes?limit=10&offset=0" \
     -H "Authorization: Bearer <TOKEN_JWT>" \
     -H "sisorg_id: 14"

# Respuesta esperada:
# HTTP/1.1 200 OK
# {"items":[{"id":1,"producto_id":101,"codigo":"101","producto_descripcion":"PRODUCTO 101","fecha":"20/09/2026","observacion":"Quiebre","estado":"ACTIVO"}],"limit":10,"offset":0}
```
