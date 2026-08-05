# language: es

Característica: Listado y Creación de Clientes
  Como preventista de la aplicación
  Quiero acceder a la lista de mis clientes asignados y registrar nuevos
  Para poder seleccionar a quién tomarle un pedido y expandir mi cartera de clientes

  Antecedentes:
    Dado que el preventista ha iniciado sesión correctamente

  Escenario: Visualización de los clientes asignados
    Cuando el preventista navega a la sección de "Clientes"
    Entonces el sistema debería mostrar la lista de clientes correspondientes a su ruta
    Y cada cliente debe mostrar su nombre, dirección y estado de cuenta

  Escenario: Selección de un cliente para un nuevo pedido
    Dado que el preventista está en la sección de "Clientes"
    Cuando selecciona a un cliente en buenas condiciones crediticias
    Entonces el sistema debería redirigirlo a la pantalla de "Nuevo Pedido" para ese cliente

  Escenario: Registro de un nuevo cliente en forma offline
    Dado que el preventista está en la sección de "Clientes"
    Cuando selecciona la opción para registrar un nuevo cliente
    Y completa los datos necesarios del nuevo cliente
    Y guarda la información
    Entonces el nuevo cliente debe registrarse localmente (SQLite) para su uso inmediato
    Y se debe incluir en el proceso de sincronización por lotes cuando haya conexión
