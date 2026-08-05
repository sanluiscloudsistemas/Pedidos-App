# 🥒 Especificación de Historias de Usuario en Gherkin (BDD)

Este documento recopila las **Historias de Usuario** escritas en formato BDD (**Gherkin**) infiriendo las reglas de negocio, la lógica de presentación y los casos de uso implementados en cada una de las **10 pantallas** de la aplicación de Preventas.

---

## 📱 1. Pantalla de Ingreso (`LoginScreen`)

```gherkin
# language: es
@autenticacion @critico
Característica: Autenticación de Preventistas
  Como preventista de la plataforma
  Quiero ingresar mis credenciales de usuario y organización
  Para acceder a las funcionalidades del sistema de preventas

  Regla: Se requiere Organización, Usuario y Contraseña obligatoriamente.

    @smoke
    Escenario: Inicio de sesión exitoso con credenciales válidas
      Dado que el preventista se encuentra en la pantalla de "Ingreso Preventas"
      Cuando ingresa la organización
      Y ingresa el usuario
      Y ingresa la contraseña
      Y presiona el botón "Iniciar Sesión"
      Entonces el sistema autentica al usuario contra el servidor ORDS
      Y muestra un mensaje flotante SnackBar con la bienvenida y el token de sesión
      Y me redirige a la pantalla principal "HomeScreen"

    Escenario: Intento de inicio de sesión con campos vacíos
      Dado que el preventista se encuentra en la pantalla de "Ingreso Preventas"
      Cuando deja vacíos los campos "Organización", "Usuario" o "Contraseña"
      Y presiona el botón "Iniciar Sesión"
      Entonces el formulario muestra mensajes de validación "Campo requerido" debajo de cada campo faltante
      Y no envía ninguna petición al servidor

    Escenario: Inicio de sesión fallido con credenciales incorrectas
      Dado que el preventista ingresa una organización o contraseña no válidas
      Cuando presiona el botón "Iniciar Sesión"
      Entonces el sistema muestra un mensaje SnackBar rojo indicando el error devuelto por la API
      Y el usuario permanece en la pantalla de login
```

---

## 🏠 2. Pantalla Principal (`HomeScreen`)

```gherkin
# language: es
@dashboard @navegacion
Característica: Dashboard Principal de Preventas
  Como preventista autenticado
  Quiero ver un panel central con accesos directos a los módulos clave
  Para gestionar clientes, pedidos, catálogo, repartos y faltantes eficientemente

  Regla: Debe proveer navegación directa a los 6 módulos principales y menú lateral de cierre de sesión.

    Escenario: Visualización de las opciones del menú principal
      Dado que el preventista ha iniciado sesión correctamente
      Cuando visualiza la pantalla "HomeScreen"
      Entonces ve una cabecera roja con el título de la aplicación y botón de menú Drawer
      Y observa las tarjetas interactivas de:
        | Módulo          | Descripción                                | Icono                 |
        | Agregar Pedido  | Pedido de un Cliente para un Reparto       | Icons.post_add        |
        | Mis Pedidos     | Pedidos de mis clientes para Repartos      | Icons.shopping_cart   |
        | Catálogo        | Catálogo de Productos                      | Icons.menu_book       |
        | Mis Clientes    | Clientes para visitar                      | Icons.import_contacts |
        | Mis Repartos    | Repartos habilitados                       | Icons.local_shipping  |
        | Faltantes       | Productos en falta o incluir en los pedidos | Icons.remove_shopping_cart |

    Escenario: Navegación desde una tarjeta del dashboard
      Dado que el preventista está en la "HomeScreen"
      Cuando presiona la tarjeta "Agregar Pedido"
      Entonces la aplicación navega hacia el wizard "NuevoPedidoWizardScreen"

    Escenario: Cierre de sesión desde el menú lateral Drawer
      Dado que el preventista despliega el menú lateral Drawer de la "HomeScreen"
      Cuando presiona la opción "Cerrar Sesión"
      Entonces se limpia el estado de autenticación de "AuthNotifier"
      Y la aplicación redirige a la pantalla "LoginScreen"
```

---

## 📋 3. Menú de Gestión de Pedidos (`PedidosMenuScreen`)

```gherkin
# language: es
@pedidos @menu
Característica: Menú de Gestión de Pedidos
  Como preventista
  Quiero un selector dedicado entre la creación de un nuevo pedido y la consulta de pedidos existentes
  Para enfocar la operación según la tarea del momento

  Regla: Debe ofrecer accesos claros y destacados para el flujo de alta y consulta.

    Escenario: Selección de creación de un nuevo pedido
      Dado que el usuario navega a la pantalla "PedidosMenuScreen"
      Cuando presiona la opción "Pedido"
      Entonces es redirigido al wizard de creación en el Paso 1

    Escenario: Consulta del histórico de pedidos
      Dado que el usuario navega a la pantalla "PedidosMenuScreen"
      Cuando presiona la opción "Ver Mis Pedidos"
      Entonces es redirigido a la pantalla de listado "MisPedidosScreen"
```

---

## 👥 4. Listado de Clientes (`MisClientesScreen`)

```gherkin
# language: es
@clientes @listado
Característica: Listado de Mis Clientes
  Como preventista
  Quiero consultar y buscar en la lista de clientes asignados
  Para gestionar pedidos, ver detalles y evaluar su estado crediticio / IVA

  Regla: Debe permitir filtro por buscador, acciones por cliente y alta de nuevo cliente.

    Escenario: Búsqueda de clientes por razón social o documento
      Dado que el preventista está en "MisClientesScreen"
      Cuando escribe "Supermercado San Luis" en el buscador
      Y presiona el botón "Ir"
      Entonces la tabla filtra y muestra únicamente los clientes que coincidan con la búsqueda

    Escenario: Acceso rápido a creación de pedido para un cliente
      Dado que el preventista ve un cliente en la tabla interactiva
      Cuando despliega el menú de acciones del cliente y selecciona "Crear Pedido"
      Entonces se abre el wizard de pedidos pre-seleccionando a dicho cliente

    Escenario: Navegación al detalle del cliente
      Dado que el preventista presiona la opción "Ver Detalle" en la fila de un cliente
      Entonces el sistema navega a la pantalla "ClienteDetailScreen" pasando los datos del cliente
```

---

## 👤 5. Detalle del Cliente (`ClienteDetailScreen`)

```gherkin
# language: es
@clientes @detalle
Característica: Detalle Estructurado del Cliente
  Como preventista
  Quiero revisar la ficha completa del cliente en cajas delimitadas
  Para verificar sus datos de contacto, condición de IVA y estado administrativo

  Regla: Los campos deben presentarse en cajas estructuradas con bordes diferenciados e indicador de estado.

    Escenario: Visualización de información estructurada del cliente
      Dado que el preventista ingresó a la ficha de un cliente específico
      Cuando observa la pantalla "ClienteDetailScreen"
      Entonces ve cajas con bordes definidos para:
        | Campo             | Formato / Elemento                          |
        | Nombre / Razón    | Caja con borde sólido y tipografía destacada |
        | CUIT / Documento  | Caja de identificación                      |
        | Tipo IVA          | Etiqueta informativa (ej. Responsable Inscripto) |
        | Teléfono y Emails | Caja de canales de contacto                 |
        | Estado y Motivo   | Caja con indicador de color verde/rojo según estado activo/bloqueado |
```

---

## 📖 6. Catálogo de Productos (`CatalogoScreen`)

```gherkin
# language: es
@catalogo @productos
Característica: Catálogo de Productos con Filtro por Categorías
  Como preventista
  Quiero explorar el catálogo de productos con miniaturas, precios y stock
  Para conocer los precios vigentes y sugerir productos al cliente

  Regla: Debe ofrecer filtros por categoría (Pastas, Panificación, etc.), contador de resultados y vista de miniatura.

    Escenario: Filtrar productos por categoría
      Dado que el preventista está en el "CatalogoScreen"
      Cuando selecciona la categoría "Pastas" en la barra de filtros
      Entonces la tabla actualiza su contenido mostrando solo productos de "Pastas"
      Y el contador superior actualiza la cantidad de filas visibles

    Escenario: Búsqueda dinámica de productos por nombre o código
      Dado que el preventista ingresa "Fideos Tallarines" en el buscador
      Cuando presiona el botón "Ir" o presiona Enter
      Entonces la lista filtra los ítems y muestra precio unitario y miniatura de imagen
```

---

## 🧙‍♂️ 7. Wizard de Creación de Pedidos (`NuevoPedidoWizardScreen`)

```gherkin
# language: es
@wizard @pedidos @critico
Característica: Wizard de Creación de Pedidos en 3 Pasos
  Como preventista
  Quiero ser guiado paso a paso para confeccionar un pedido
  Para garantizar que no falte información de cliente, productos ni reparto

  Regla: Debe contar con barra de progreso inferior y validaciones estrictas entre pasos.

    Escenario: Paso 1 - Selección de Cliente y Condición de Venta
      Dado que el preventista inicia el wizard de creación de pedido
      Cuando selecciona el cliente "Distribuidora Central" y la venta "Contado"
      Y presiona "Siguiente"
      Entonces el wizard avanza al Paso 2 ("Carga de Productos")

    Escenario: Paso 2 - Carga interactiva de productos y cálculo de montos
      Dado que el preventista está en el Paso 2 del wizard
      Cuando agrega 5 unidades del producto "Pan de Molde" a $1500
      Entonces la tabla interactiva suma la fila por $7500
      Y la barra inferior actualiza el Monto Total en tiempo real
      Y al presionar "Siguiente" avanza al Paso 3

    Escenario: Paso 3 - Selección de Reparto y Confirmación Final
      Dado que el preventista está en el Paso 3 del wizard
      Cuando elige la zona de reparto "Zona Norte - Turno Mañana"
      Y presiona "Confirmar y Guardar Pedido"
      Entonces el pedido se persiste en la base de datos local / servidor
      Y el sistema muestra un mensaje de éxito redirigiendo a "MisPedidosScreen"
```

---

## 🛒 8. Listado de Mis Pedidos (`MisPedidosScreen`)

```gherkin
# language: es
@pedidos @listado
Característica: Listado de Mis Pedidos
  Como preventista
  Quiero revisar el listado de pedidos registrados con sus estados y montos
  Para dar seguimiento a las entregas y cobranzas

  Regla: Permite filtrar por estado (Pendiente, Enviado, Entregado, Cancelado) y recuento total.

    Escenario: Filtrado de pedidos por estado
      Dado que el preventista está en "MisPedidosScreen"
      Cuando selecciona el filtro de estado "Pendiente"
      Entonces la lista muestra solo pedidos cuyo estado sea "Pendiente"
      Y refleja el recuento de filas y la suma de montos acumulados
```

---

## 🚚 9. Listado de Mis Repartos (`MisRepartosScreen`)

```gherkin
# language: es
@repartos @logistica
Característica: Consulta de Mis Repartos
  Como preventista
  Quiero ver los repartos programados y sus zonas asignadas
  Para coordinar los días de entrega de mis clientes

  Regla: Debe contar con etiquetas/pills activas de filtro por estado y recuento de filas.

    Escenario: Filtrar repartos con etiquetas Pills/Tags
      Dado que el preventista abre la pantalla "MisRepartosScreen"
      Cuando pulsa el tag filtro "En Curso"
      Entonces la pantalla resalta visualmente la etiqueta seleccionada
      Y la tabla filtra únicamente los repartos activos en ruta para la fecha
```

---

## ⚠️ 10. Productos Faltantes (`FaltantesScreen`)

```gherkin
# language: es
@faltantes @stock
Característica: Control de Productos Faltantes
  Como preventista
  Quiero consultar el listado de productos faltantes y registrar observaciones
  Para alertar al cliente sobre quiebres de stock o reemplazos

  Regla: Debe listar productos no entregados con fecha/tiempo de reporte y campo de observación.

    Escenario: Consulta y búsqueda de faltantes
      Dado que el preventista navega a la pantalla "FaltantesScreen"
      Cuando busca un producto en falta por descripción
      Entonces la tabla muestra el Código, Descripción, Observaciones y la Fecha/Hora del reporte de falta

---

## 🌐 11. Indicador de Conectividad en Tiempo Real (`PreventaAppBar`)

```gherkin
# language: es
@red @conectividad @cabecera
Característica: Detección Dinámica de Red e Indicador de Conexión
  Como preventista de campo
  Quiero ver el estado de mi conexión a Internet en la cabecera
  Para saber si estoy trabajando en modo online o si mis cambios se guardarán localmente

  Regla: El icono de la nube en PreventaAppBar debe mostrar verde para conexión activa y blanco para offline.

    Escenario: Conexión activa a Internet
      Dado que el dispositivo cuenta con conexión a Wi-Fi, Datos Móviles o Ethernet
      Cuando el preventista visualiza cualquier pantalla del sistema
      Entonces la cabecera PreventaAppBar muestra el icono de la nube en verde (#4CAF50)
      Y al presionar el icono muestra el mensaje "Conexión activa: Sincronizando datos con el servidor..."

    Escenario: Pérdida de conexión a Internet (Modo Offline)
      Dado que el dispositivo se queda sin conexión a red
      Cuando el preventista está navegando en la aplicación
      Entonces la cabecera pasa el icono de la nube a color blanco automáticamente
      Y al presionar el icono advierte "Modo Offline: Sin conexión a Internet. Los cambios se guardarán localmente."
```

---

## 🗄️ 12. Carga Offline (Drift SQLite) y Sincronización Automática Remota

```gherkin
# language: es
@offline @drift @sincronizacion
Característica: Carga de Pedidos Offline y Auto-Sincronización
  Como preventista de campo en zonas sin señal
  Quiero cargar nuevos pedidos en la base de datos local Drift SQLite
  Para que se sincronicen automáticamente con el servidor al recuperar la conexión

  Regla: Todo pedido creado offline debe guardarse en Drift con estado PENDING_SYNC y subirse a la API al volver online.

    Escenario: Creación de pedido en modo sin conexión (Offline)
      Dado que el dispositivo no tiene conexión a Internet
      Cuando el preventista completa el wizard "NuevoPedidoWizardScreen" y presiona "Confirmar"
      Entonces el pedido y sus artículos se persisten en las tablas locales PedidosLocal y OrderItemsLocal de Drift
      Y se asigna el estado de sincronización "PENDING_SYNC"
      Y la pantalla muestra la alerta "¡Pedido guardado en la base de datos local (Drift)! Se sincronizará automáticamente al reconectarse a Internet."

    Escenario: Sincronización automática al recuperar señal
      Dado que existen 1 o más pedidos locales almacenados con estado "PENDING_SYNC"
      Cuando el notificador de red detecta la transición de Offline a Online
      Entonces el servicio SyncNotifier transmite automáticamente la cola de pedidos pendientes a la API remota vía HTTP POST
      Y actualiza el estado de los pedidos en Drift SQLite a "SYNCED"
      Y muestra la notificación "¡Se sincronizaron X pedido(s) guardado(s) offline con éxito!"
```
```
