# Especificaciones de Negocio (BDD)

Esta carpeta contiene las especificaciones de comportamiento del sistema de Preventas, El propósito es alinear los requerimientos del negocio con la implementación.

## Características del Proyecto

El sistema soporta el flujo completo de trabajo de un preventista de forma móvil, priorizando la agilidad de venta y la tolerancia a fallos de conectividad (Offline-First):

1. **Catálogo de Productos (`productos.feature`)**:
   - Descarga y visualización veloz de artículos. Permite búsqueda rápida por código o nombre para consultar precios. *Nota:* A pedido del cliente, el sistema opera sin efectuar control de stock en el dispositivo.

2. **Cartera y Registro de Clientes (`clientes.feature`)**:
   - Listado de usuarios/negocios asignados con su estatus de deuda.
   - Posibilidad de **registrar Nuevos Clientes** incluso en modalidad offline gracias al soporte en base de datos local, quedando listos inmediatamente para realizarles un pedido.

3. **Toma y Armado Ágil de Pedidos (`toma_de_pedidos.feature`)**:
   - Carga enfocada en velocidad basada en la dupla `Código + Cantidad`.
   - Visualización y actualización dinámica e inmediata del listado y subtotal/total del carro de compras a medida que cambian los artículos.

4. **Operación Local y Sincronización en Segundo Plano (Batch)**:
   - Toda la operativa de guardar (pedidos y clientes) se efectúa inicialmente y de manera rápida en la base de datos local SQLite del dispositivo (Drift).
   - Cuando se recupera o estabiliza la conectividad, se detona un **Agente de Sincronización o Job en background** que transmite los lotes (batches) acumulados hacia Oracle (API REST) sin interrumpir, bloquear ni ralentizar la jornada de trabajo del usuario.

## Buenas Prácticas

Todas las definiciones en estos archivos utilizan un vocabulario de dominio que permite tanto a desarrolladores como a analistas entender qué debe hacer el software y probar estos escenarios.
