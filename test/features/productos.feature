# language: es

Característica: Listado de Productos
  Como preventista de la aplicación
  Quiero poder ver la lista de productos disponibles
  Para poder ofrecerlos y agregarlos a los pedidos de los clientes

  Antecedentes:
    Dado que el preventista ha iniciado sesión correctamente

  Escenario: Visualización exitosa del catálogo de productos
    Cuando el preventista accede a la sección de "Productos"
    Entonces el sistema debería mostrar una lista de productos
    Y cada producto debe mostrar su código, nombre y precio (sin mostrar información de stock actual)

  Escenario: Búsqueda rápida de un producto
    Dado que el preventista está en la sección de "Productos"
    Cuando busca mediante el código numérico o parte del nombre
    Entonces la lista debería actualizarse instantáneamente para mostrar solo las coincidencias
