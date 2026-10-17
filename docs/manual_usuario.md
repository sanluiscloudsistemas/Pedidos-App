# 📱 Manual del Usuario: Aplicación Móvil de Preventas

Bienvenido al **Manual del Usuario** de la aplicación móvil de **Preventas**. Esta guía proporciona instrucciones detalladas para el uso diario del sistema en tareas comerciales en terreno, tanto en modalidad conectada (**Online**) como en zonas sin cobertura (**Offline**).

---

## 📑 Tabla de Contenidos
1. [Acceso al Sistema (Login)](#1-acceso-al-sistema-login)
   - [Ingreso con Usuario y Contraseña (Online)](#ingreso-con-usuario-y-contrase%C3%B1a-online)
   - [Ingreso Biométrico (Huella / Rostro)](#ingreso-biom%C3%A9trico-huella--rostro)
   - [Ingreso en Modo Fuera de Línea (Offline)](#ingreso-en-modo-fuera-de-l%C3%ADnea-offline)
2. [Barra Superior y Estado de Conectividad](#2-barra-superior-y-estado-de-conectividad)
3. [Módulo "Mis Pedidos"](#3-m%C3%B3dulo-mis-pedidos)
   - [Visualización y Fechas con Zona Horaria](#visualizaci%C3%B3n-y-fechas-con-zona-horaria)
   - [Búsqueda y Filtros de Estado](#b%C3%BAsqueda-y-filtros-de-estado)
   - [Estados Comerciales vs. Estados de Sincronización](#estados-comerciales-vs-estados-de-sincronizaci%C3%B3n)
4. [Módulo "Nuevo Pedido" (Wizard de Venta)](#4-m%C3%B3dulo-nuevo-pedido-wizard-de-venta)
   - [Paso 1: Cliente y Condiciones](#paso-1-cliente-y-condiciones)
   - [Paso 2: Carga de Artículos](#paso-2-carga-de-art%C3%ADculos)
   - [Paso 3: Reparto y Confirmación](#paso-3-reparto-y-confirmaci%C3%B3n)
5. [Sincronización Automática](#5-sincronizaci%C3%B3n-autom%C3%A1tica)
6. [Cierre de Sesión y Seguridad](#6-cierre-de-sesi%C3%B3n-y-seguridad)

---

## 1. Acceso al Sistema (Login)

La pantalla de acceso cuenta con la identidad institucional circular de **San Luis Cloud** y ofrece tres mecanismos seguros de autenticación:

### Ingreso con Usuario y Contraseña (Online)
1. Ingrese el código de su **Organización** (ej: `ORG1`).
2. Digite su **Usuario** asignado.
3. Ingrese su **Contraseña**.
4. Presione el botón primario **Conectar**.
5. Al validar exitosamente contra el servidor, se almacena de forma cifrada el token de sesión (vigente por 8 horas) y un hash seguro de sus credenciales para habilitar posteriores accesos sin conexión.

### Ingreso Biométrico y Modo Fuera de Línea (Offline)
- **Activación exclusiva en Modo Offline:** El botón con el icono de la **huella digital** se vuelve visible y habilitado **únicamente** cuando el dispositivo detecta ausencia de conexión (sin datos móviles ni Wi-Fi). En estado online, dicho botón permanece oculto.
- **Pantalla de Captura Biométrica:** Al pulsar el botón de huella offline, la aplicación navega a la pantalla dedicada de **Autenticación Biométrica**, la cual muestra una región circular interactiva y la instrucción: *"Presione sobre el sensor de huella digital de su dispositivo para validar su identidad"*.
- **Acceso Inmediato:** El sistema solicita la lectura al sensor físico del equipo. Si la huella es reconocida y válida, se muestra confirmación visual en verde y se ingresa automáticamente al sistema en **Modo Offline**.
- **Acceso con Contraseña Offline:** De manera alternativa, el usuario puede ingresar sus credenciales habituales (Organización, Usuario y Contraseña) y pulsar **Conectar**; el sistema validará localmente el hash SHA-256 almacenado en el dispositivo.

---

## 2. Barra Superior y Estado de Conectividad

En la parte superior de todas las pantallas principales se visualiza la barra institucional roja:

- **Icono de Nube (Estado de Red):**
  - 🟢 **Verde:** Dispositivo conectado a Internet. Todas las operaciones y pedidos se transmiten directamente al servidor central.
  - ⚪ **Blanco:** Dispositivo sin conexión (Modo Offline). Los pedidos se guardarán en la memoria segura local del equipo para su sincronización posterior.
- **Menú Lateral (Hamburguesa):** Permite navegar rápidamente entre Mis Pedidos, Catálogo, Clientes, Repartos, Faltantes y Cerrar Sesión.

---

## 3. Módulo "Mis Pedidos"

### Visualización y Fechas con Zona Horaria
- En pantallas móviles los pedidos se muestran en tarjetas interactivas estructuradas; en pantallas más amplias o tablets se presentan en formato de tabla de alta densidad.
- **Formato de Fecha Unificado:** Todas las fechas de pedidos se proyectan con el patrón exacto:  
  `DD MON YYYY HH24:MI:SS` (ejemplo: `26 SEP 2026 16:30:15`).
- La hora mostrada siempre está calculada y adaptada a la **hora local de Argentina (UTC-3)**, sin importar el formato interno en que haya sido generado el registro.

### Búsqueda y Filtros de Estado
- **Barra de Búsqueda:** Permite filtrar en tiempo real escribiendo el nombre del cliente, código de pedido o fecha.
- **Pestañas de Filtro Rápido:**
  - **Todos:** Muestra la totalidad de los pedidos.
  - **Nuevos:** Pedidos generados recientemente pendientes de procesamiento.
  - **Pendientes:** Pedidos en curso de entrega o validación.
  - **Finalizados:** Pedidos completados y facturados.

### Estados Comerciales vs. Estados de Sincronización
- **Estado Comercial (Badge Principal):** Determinado por la gestión del negocio (`NUEVO`, `PENDIENTE`, `FINALIZADO`).
- **Estado de Sincronización (Badge Secundario):**
  - 🟢 **ONLINE / SYNCED:** El pedido ya se encuentra resguardado en la base de datos central de Oracle.
  - 🟠 **OFFLINE / PENDING_SYNC:** El pedido fue tomado sin conexión y permanece en la base de datos local en espera de ser transmitido.

---

## 4. Módulo "Nuevo Pedido" (Wizard de Venta)

La toma de pedidos se organiza en un asistente guiado de 3 pasos:

### Paso 1: Cliente y Condiciones
1. Seleccione el cliente de la lista disponible en el dispositivo.
2. Elija la condición de venta (**Contado** o **Cuenta Corriente**).
3. Presione **Siguiente**.

### Paso 2: Carga de Artículos
1. Busque productos en el catálogo offline por descripción o código de barras.
2. Defina la cantidad de bultos o unidades. El subtotal y el total general se calculan instantáneamente.
3. Modifique cantidades o elimine líneas directamente en la tabla de artículos cargados.
4. Presione **Siguiente**.

### Paso 3: Reparto y Confirmación
1. Seleccione la zona de reparto correspondiente.
2. Añada observaciones adicionales si fuera necesario (ej: "Entregar por la mañana").
3. Revise el resumen del total y presione **Confirmar Pedido**.
4. El pedido se guardará con estado inicial **NUEVO**. Si hay conexión se enviará inmediatamente; si no, quedará guardado como **PENDING_SYNC**.

---

## 5. Sincronización Automática

- No es necesario realizar acciones manuales para enviar los pedidos fuera de línea.
- Tan pronto el dispositivo detecte conectividad activa (WiFi o datos móviles), el servicio en segundo plano detectará los pedidos pendientes y los transmitirá al servidor central.
- Una notificación visual indicará: *"¡Se sincronizaron X pedido(s) guardado(s) offline con éxito!"*.
- El distintivo del pedido cambiará automáticamente de `OFFLINE` a `ONLINE`.

---

## 6. Cierre de Sesión y Seguridad

- **Reinicio de la Aplicación:** Al cerrar por completo la aplicación y volver a abrirla, por razones de seguridad se solicitará siempre autenticarse en la pantalla de ingreso.
- **Preservación Offline:** El reinicio no elimina sus datos locales ni sus pedidos pendientes de sincronización. Podrá reingresar de inmediato mediante su huella o contraseña aún sin señal de internet.
- **Cerrar Sesión:** Para salir explícitamente y permitir que otro preventista utilice el dispositivo, abra el menú lateral y seleccione **Cerrar Sesión**.
