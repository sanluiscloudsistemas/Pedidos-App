# language: es

Característica: Toma de Pedidos
  Como preventista de la aplicación
  Quiero registrar los pedidos de mis clientes
  Para que sean procesados por el sistema central

  Antecedentes:
    Dado que el preventista ha iniciado sesión correctamente
    Y se encuentra en la pantalla de "Nuevo Pedido"

  Escenario: Selección de un cliente existente
    Cuando el preventista busca al cliente "Juan Pérez"
    Y selecciona al cliente de la lista de resultados
    Entonces los datos del cliente deberían mostrarse en el encabezado del pedido

  Escenario: Agregar productos al pedido
    Dado que un cliente ha sido seleccionado
    Cuando el preventista busca el producto "Aceite Girasol 1L"
    Y agrega "2" unidades al carrito
    Entonces el total del pedido debería actualizarse correctamente
    Y el producto debería aparecer en la lista de items del pedido

  Escenario: Confirmación y envío del pedido
    Dado que el pedido tiene al menos un producto agregado
    Cuando el preventista presiona el botón "Confirmar Pedido"
    Entonces el pedido debería guardarse localmente
    Y el sistema debería intentar sincronizar el pedido con el servidor Oracle
    Y debería mostrarse un mensaje de "Pedido enviado con éxito"
