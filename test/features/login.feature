# language: es

Característica: Inicio de Sesión
  Como usuario de la aplicación de preventas
  Quiero poder iniciar sesión con mis credenciales
  Para acceder a las funcionalidades de gestión de preventas

  Escenario: Inicio de sesión exitoso
    Dado que el usuario está en la pantalla de inicio de sesión
    Cuando el usuario ingresa su nombre de usuario y contraseña correctos
    Y presiona el botón de "Iniciar Sesión"
    Entonces el usuario debería ser redirigido a la pantalla principal

  Escenario: Inicio de sesión fallido por credenciales inválidas
    Dado que el usuario está en la pantalla de inicio de sesión
    Cuando el usuario ingresa un nombre de usuario o contraseña incorrectos
    Y presiona el botón de "Iniciar Sesión"
    Entonces debería mostrarse un mensaje de error indicando "Credenciales inválidas"
