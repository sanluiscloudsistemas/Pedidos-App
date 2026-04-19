# language: es

Característica: Toma de Pedidos
  Como preventista de la aplicación
  Quiero registrar los pedidos de mis clientes de forma ágil y que funcionen offline
  Para que la venta no se detenga por mala conexión y se procesen en lote cuando haya red

  Antecedentes:
    Dado que el preventista ha iniciado sesión correctamente
    Y se encuentra en la pantalla de "Nuevo Pedido"

  Escenario: Selección de un cliente existente
    Cuando el preventista busca al cliente "Juan Pérez"
    Y selecciona al cliente de la lista de resultados
    Entonces los datos del cliente deberían mostrarse en el encabezado del pedido

  Escenario: Agregar productos al pedido rápidamente mediante código
    Dado que un cliente ha sido seleccionado
    Cuando el preventista ingresa el código del producto y la cantidad deseada
    Entonces el producto se agrega Inmediatamente al pedido
    Y no se debe verificar el stock actual del producto (a solicitud del cliente)

  Escenario: Visualización dinámica del carro de compras
    Dado que el preventista está armando el pedido
    Cuando ingresa un nuevo producto al carro
    Entonces el sistema debe mostrar el listado actualizado del carro de compras
    Y el costo total del pedido debe recalcularse y reflejarse automáticamente

  Escenario: Confirmación del pedido y guardado offline (SQLite)
    Dado que el carro de compras tiene al menos un producto agregado
    Cuando el preventista presiona el botón "Confirmar Pedido"
    Entonces el pedido debería guardarse localmente en la base de datos del dispositivo (SQLite/Drift)
    Y la aplicación debe estar lista de inmediato para tomar el siguiente pedido sin bloqueos

  Escenario: Sincronización por lotes en segundo plano al recuperar conexión
    Dado que la aplicación tiene pedidos almacenados localmente que no han sido enviados
    Cuando el dispositivo vuelve a tener conexión a internet estable
    Entonces se debe inicializar un proceso de actualización por lotes en segundo plano (background)
    Y este proceso no debe ralentizar el equipo del usuario ni interrumpir su trabajo actual
