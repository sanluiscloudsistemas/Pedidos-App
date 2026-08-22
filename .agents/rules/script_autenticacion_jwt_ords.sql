-- =============================================================================
-- SCRIPT DE AUTENTICACIÓN JWT EN ORACLE APEX PARA EL DBA
-- Esquema Objetivo: SIS_SANLUISCLOUD
-- Descripción: Paquete PL/SQL y Handler REST (ORDS) para la generación y 
--              validación de tokens JWT mediante APEX_JWT.
-- =============================================================================

SET DEFINE OFF;

--------------------------------------------------------------------------------
-- 0. PERMISOS REQUERIDOS (Ejecutar con usuario SYS / SYSTEM)
--------------------------------------------------------------------------------
/*
GRANT EXECUTE ON APEX_JWT TO SIS_SANLUISCLOUD;
GRANT EXECUTE ON APEX_JSON TO SIS_SANLUISCLOUD;
*/

--------------------------------------------------------------------------------
-- 1. ESPECIFICACIÓN DEL PAQUETE PKG_SEGURIDAD
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE SIS_SANLUISCLOUD.pkg_seguridad AS

    /**
     * Valida las credenciales del usuario en SEG_USUARIOS y SIS_PERSONAL,
     * y genera un token JWT firmado mediante APEX_JWT.
     *
     * @param p_organizacion_id  ID de la organización (SISORG_ID).
     * @param p_usuario          Nombre del usuario.
     * @param p_contrasenia      Contraseña del usuario.
     * @param p_exp_minutos      Minutos de validez del JWT (Por defecto 480 min / 8 hs).
     * @param p_out_token        Retorna el JWT generado en formato Base64URL.
     * @param p_out_mensaje      Mensaje descriptivo del resultado.
     * @return BOOLEAN           TRUE si la autenticación fue exitosa.
     */
    FUNCTION f_login (
        p_organizacion_id IN NUMBER,
        p_usuario         IN VARCHAR2,
        p_contrasenia     IN VARCHAR2,
        p_exp_minutos     IN NUMBER DEFAULT 480,
        p_out_token       OUT VARCHAR2,
        p_out_mensaje     OUT VARCHAR2
    ) RETURN BOOLEAN;

END pkg_seguridad;
/

--------------------------------------------------------------------------------
-- 2. CUERPO DEL PAQUETE PKG_SEGURIDAD
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY SIS_SANLUISCLOUD.pkg_seguridad AS

    -- Clave secreta para la firma del JWT (Modificar por la clave definitiva de producción)
    GC_JWT_SECRET CONSTANT VARCHAR2(256) := 'ClaveSecretaUltraSeguraSanLuisCloud2026!#$';
    GC_ISSUER     CONSTANT VARCHAR2(100) := 'SANLUISCLOUD_APEX';

    FUNCTION f_login (
        p_organizacion_id IN NUMBER,
        p_usuario         IN VARCHAR2,
        p_contrasenia     IN VARCHAR2,
        p_exp_minutos     IN NUMBER DEFAULT 480,
        p_out_token       OUT VARCHAR2,
        p_out_mensaje     OUT VARCHAR2
    ) RETURN BOOLEAN IS
        v_segusu_id     seg_usuarios.id%TYPE;
        v_nombre_usu    seg_usuarios.nombre%TYPE;
        v_email         seg_usuarios.email%TYPE;
        v_situacion     seg_usuarios.situacion%TYPE;
        v_personal_id   sis_personal.id%TYPE;
        v_cargo         sis_personal.cargo%TYPE;
        v_sisdep_id     sis_personal.sisdep_id%TYPE;
        
        v_jwt           VARCHAR2(4000);
        v_exp_date      DATE;
        v_minutos       NUMBER;
    BEGIN
        -- 1. Validar parámetros de expiración (mínimo 1 minuto, defecto 480 min / 8hs)
        v_minutos := NVL(p_exp_minutos, 480);
        IF v_minutos <= 0 THEN
            v_minutos := 480;
        END IF;

        -- 2. Verificar usuario y contraseña en SEG_USUARIOS
        BEGIN
            SELECT u.id, u.nombre, u.email, u.situacion
              INTO v_segusu_id, v_nombre_usu, v_email, v_situacion
              FROM seg_usuarios u
             WHERE u.sisorg_id = p_organizacion_id
               AND UPPER(u.usuario) = UPPER(p_usuario)
               AND u.contrasenia = p_contrasenia;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_out_mensaje := 'Organización, usuario o contraseña incorrectos.';
                RETURN FALSE;
        END;

        -- 3. Verificar estado activo
        IF v_situacion <> 'ACT' THEN
            p_out_mensaje := 'El usuario no se encuentra activo (Situación: ' || v_situacion || ').';
            RETURN FALSE;
        END IF;

        -- 4. Obtener información de personal asignado
        BEGIN
            SELECT p.id, p.cargo, p.sisdep_id
              INTO v_personal_id, v_cargo, v_sisdep_id
              FROM sis_personal p
             WHERE p.segusu_id = v_segusu_id
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_personal_id := NULL;
                v_cargo       := NULL;
                v_sisdep_id   := NULL;
        END;

        -- 5. Calcular fecha futura de expiración
        v_exp_date := SYSDATE + (v_minutos / 1440);

        -- 6. Encode JWT mediante APEX_JWT
        v_jwt := apex_jwt.encode(
            p_iss           => GC_ISSUER,
            p_sub           => UPPER(p_usuario),
            p_aud           => 'PREVENTAS_MOBILE_APP',
            p_iat           => SYSDATE,
            p_exp           => v_exp_date,
            p_signature_key => UTL_RAW.cast_to_raw(GC_JWT_SECRET)
        );

        p_out_token   := v_jwt;
        p_out_mensaje := 'Autenticación exitosa.';
        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            p_out_mensaje := 'Error inesperado durante la autenticación: ' || SQLERRM;
            RETURN FALSE;
    END f_login;

END pkg_seguridad;
/

--------------------------------------------------------------------------------
-- 3. CONFIGURACIÓN DEL SERVICIO REST EN ORDS (HANDLERS PL/SQL)
--------------------------------------------------------------------------------
/*
   Módulo ORDS: mobile (o el módulo REST activo)
   URL Pattern: auth/login (o mobile/login)
   HTTP Method: POST
   Source Type: PL/SQL Block
*/

-- CÓDIGO A PEGAR EN EL HANDLER PL/SQL DEL ENDPOINT REST EN ORDS:
/*
DECLARE
    v_ok          BOOLEAN;
    v_token       VARCHAR2(4000);
    v_mensaje     VARCHAR2(1000);
    v_exp_minutos NUMBER := NVL(:exp_minutos, 480);
BEGIN
    v_ok := pkg_seguridad.f_login(
        p_organizacion_id => :organizacion,  -- o :organizacion_id según el payload JSON
        p_usuario         => :usuario,
        p_contrasenia     => :contrasenia,
        p_exp_minutos     => v_exp_minutos,
        p_out_token       => v_token,
        p_out_mensaje     => v_mensaje
    );

    IF v_ok THEN
        :status := 200;
        apex_json.open_object;
        apex_json.write('success', true);
        apex_json.write('token', v_token);
        apex_json.write('expires_in_seconds', v_exp_minutos * 60);
        apex_json.write('message', v_mensaje);
        apex_json.close_object;
    ELSE
        :status := 401;
        apex_json.open_object;
        apex_json.write('success', false);
        apex_json.write('message', v_mensaje);
        apex_json.close_object;
    END IF;
END;
*/
