# DAMM 2024 - Grupo 2

###### Integrantes

- Juan Adolfo Rosauer Herrmann
- Lucas Miguel Biolley Calvo
- Santiago Monjeau Castro

### Tabla de Contenidos

- [Decisiones de implementación](#decisiones-de-implementación)
    - [Go Router sobre Beamer](#go-router-sobre-beamer)
    - [Push notifications con FCM](#push-notifications-con-fcm)
- [Problemas encontrados](#problemas-encontrados)
    - [Versiones de librerías conflictivas](#versiones-de-librerías-conflictivas)
    - [Manejo de Riverpod](#manejo-de-riverpod)
    - [Chequeos en IOS](#chequeos-en-ios)
- [Métricas](#métricas)
- [Pasos necesarios para la ejecución correcta de la aplicación](#pasos-necesarios-para-la-ejecución-correcta-de-la-aplicación)
    - [Enviar notificaciones](#enviar-notificaciones)
    - [Habilitación de links](#habilitación-de-links)
    - [Confirmación de aplicaciones de voluntariados](#confirmación-de-aplicaciones-de-voluntariados)

### Decisiones de implementación

##### Go Router sobre Beamer

Decidimos utilizar GoRouter como librería de navegación sobre la alternativa de Beamer y el
Navigator 2.0 de Flutter (es decir, no usar librería). Los motivos detrás de esta decisión fueron la
facilidad de la librería para manejar links anidados, la baja curva de aprendizaje (que permitió una
puesta a punto rápida de la navegación en un primer momento) y la comunidad que hay detrás. Esto
último resultó importante para el momento de manejar las rutas con las tabs, dado que pudimos
encontrar no solo muchos desarrolladores que tuvieron las mismas dudas que nosotros, sino también
soluciones efectivas para este problema, como el **StatefulShellRoute** de GoRouter.

##### Push notifications con FCM

Decidimos usar este servicio de Firebase, ya que se podía integrar rápidamente a la aplicación. Las
notificaciones en foreground las implementamos creando canales de comunicación para Android, con
prioridad alta, para poder recibir notificaciones de este tipo. Para IOS, bastó solo con un método
provisto por la instancia de *FirebaseMessaging*. Sin embargo, faltaba un paso extra para poder ver
la notificación al estilo "heads up", y esto lo logramos usando el paquete
*flutter_local_notifications*, donde pudimos configurar esta notificación y como manejar los
deep_links que llegaban como información extra.
Por otro lado, para poder enviar notificaciones a usuarios específicos, utilizamos el *FCM Token*
provisto por FirebaseMessaging, guardandolo en la colección *volunteer* de Firestore.
Más adelante en este informe mostramos el paso a paso de como enviar las notificaciones desde la
consola. Si bien se podría hacer un poco más automático armando un server usando el Admin SDK de
Firebase, nos pareció mejor invertir el tiempo en otras partes, y utilizar la consola para enviar
las notificaciones.

##### Realtime de vacantes

Decidimos que el contador cambie solo cuando las solicitudes son confirmadas, por lo que para ver
cambios realtime habría que confirmar aplicaciones, como se explica más adelante en este informe.

##### Decisiones de seguridad

En un principio, las reglas de Firestore permitían cualquier request. Hicimos todo el desarrollo de ese modo. Sin embargo, más para el final tratamos de agregar las siguientes reglas

- Reglas para la colección news: solo usuarios autenticados pueden leer. Escritura denegada.
- Reglas para la coleccion volunteerOpportunities: solo usuarios autenticados pueden leer y
  escribir.
- Reglas para la colección volunteer: solo el usuario autenticado con ese uid puede leer y escribir
  en el registro volunteer correspondiente a este id
  
Lamentablemente, tras agregar estas reglas notamos que algunos flujos de nuestra app dejaban de funcionar, por lo que, por una cuestión de tiempo restante, tuvimos que dejar la regla anterior, cosa que no es ideal.
  
Por otra parte, consideramos que la presencia del firebase_options.dart dentro del proyecto no es una falla
en mantener la seguridad. Esto es porque aunque contenga llaves publicas, que pueden ser expuestas
por la plataforma movil y Flutter, el flow de datos de Firebase permite que no sea un riesgo hacia
la integridad del proyecto y la configuración.

##### Implementacion del real-time para el usuario

Para asegurarnos que acciones como dar favorito sean rapidas y respondan bien al input del usuario,
decidimos que a lo largo de la aplicacion, las actualizaciones de datos del usuario con el backend
se hagan durante cargas o interacciones con el mismo. De esta manera, al realizar una accion
mandamos el estado actual local del usuario, y durante la iniciacion sincronizamos con el servidor.
Es por esto que al confirmar la aplicacion en Firebase, no se refleja en la aplicacion al instante.
Como el flujo de confirmacion termina con la creacion de una notificacion, igualmente el usuario
tiene una manera de enterarse de cambios.

### Problemas encontrados

##### Versiones de librerías conflictivas

Durante distintas etapas del desarrollo vimos cómo agregar dependencias traía consigo una consola
llena de errores de build, indicando versiones conflictivas, mayoritariamente del Plugin de Kotlin
para Gradle. En un primer momento, este error apareció al agregar Firebase, pero resultó ser por
seguir unos pasos erróneos en su instalación, ya que tras hacer un rollback de todos estos pasos y
seguir los de la página oficial, pudimos agregar Firebase al proyecto exitosamente. Sin embargo, más
adelante en el desarrollo surgió un error similar al agregar la librería Geolocator (^12.0.0), usada
para acceder a la ubicación del usuario. Al agregarla, volvió a aparecer el mismo error en la
consola, que sugería cambiar la versión del plugin. Eso no arregló el error y en una búsqueda
inicial ninguna solución encontrada en internet parecía servir, hasta encontrar un issue en el
Github de la librería, donde marcaban que esa versión específica causaba el error, y que la
solución (esta vez exitosa) era sumar una dependencia adicional al pubspec: geolocator_android:
4.5.5.

##### Manejo de Riverpod

Este problema consistió en que, ya bastante entrados en el desarrollo de la app, nos dimos cuenta
que estabamos manejando cosas por fuera del estado de Riverpod, como por ejemplo el acceso al
listado de los voluntariados. Por ello, tuvimos que realizar un refactor un poco tedioso, en el que
fuimos viendo como algunas cosas que previamente funcionaban dejaban de hacerlo. Un ejemplo de esto
fue el ordenamiento por localización, que al pasar a manejar el acceso a los voluntariados con un
*FirestoreProvider* dejó de funcionar el acceso a la localización, por lo que nos dimos cuenta que
también habría que manejarla con un provider.
Otra dificultad relacionada a Riverpod resultó ser el desarollo en sí, y ver en que widgets hacer
los *watch*  a los providers, para evitar rebuilds no deseados. Un ejemplo de problema relacionado a
esto fue el rebuild de toda la screen de *Postularme*, que estaba sucediendo por hacer un watch del
Provider que manejaba la lógica de los favoritos (FirestoreProvider) en widgets erróneos. Al hacer
el watch en el widget de la card de voluntariado, que era el correcto, arreglamos el error de
rebuild completo de la screen.

##### Chequeos en IOS

Como ninguno de los miembros del grupo desarrolla en MAC, no nos resultó posible probar la app en
IOS, sobre todo a la hora de agregar cosas exclusivas, como el pedido de permisos para tracking (app
tracking transparency). También para ver si los deep links funcionan, si el logo y el nombre se
están mostrando bien o si llegan las notificaciones.

##### Busqueda con actualizacion inmediata

Decidimos actualizar la busqueda de voluntariados en forma directa al input del teclado. No estamos
preocupados por la creacion de un gran numero de requests, por lo que parecio sensato para generar
un buen desarrollo inicial. Unicamente en el celular fisico de Adolfo vimos un problema donde la
actualizacion automatica quita el foco del teclado y vuelve dificil la interaccion.

### Métricas

Definimos una serie de eventos a monitorear, basándonos en la importancia que creemos que tienen
dentro del propósito de la aplicación, y el potencial valor que se podría agregar mejorando la
experiencia del usuario al realizar estos eventos. Dichos eventos son:

- Aplicación a un voluntariado:  
  Este evento representa el núcleo de la aplicación, ya que refleja el compromiso del usuario con el
  propósito principal de la plataforma: encontrar oportunidades de voluntariado y contribuir a
  causas relevantes. La cantidad de aplicaciones proporciona una medida clara del interés de los
  usuarios en las oportunidades presentadas, permitiéndonos identificar las áreas de alta demanda y
  adaptar la oferta en consecuencia. Por ejemplo, podríamos ver qué tipos de voluntariados son los
  que más llaman la atención, o los que más rápido se llenan. El seguimiento de este evento también
  puede ayudar a evaluar la efectividad de las estrategias de presentación de oportunidades, como la
  relevancia de la información proporcionada y la facilidad de aplicación.
- Desaplicación a un voluntariado:  
  Este evento permitiría ver el grado de compromiso de los usuarios con el objetivo de la
  aplicación. Si se lo relaciona con el evento anterior, podríamos ver si los usuarios se van de un
  voluntariado para inmediatamente aplicar a otro, o si solo están desaplicando. Podríamos ver la
  proporción entre aplicaciones y desaplicaciones, para armar así algún ranking de usuarios y
  proponer oportunidades de voluntariado diferentes según este.
- Compartir noticia:  
  Este evento muestra un nivel más profundo de compromiso y participación del usuario con la
  aplicación. Al compartir noticias relevantes relacionadas al mundo del voluntariado, los usuarios
  están contribuyendo activamente a la difusión de información y la promoción de la plataforma.
  También, podríamos usar esta información para ver qué tipos de noticias son las que interesan a
  cada usuario, y ordenárselas en base a ello.
- Completar perfil:  
  Es un evento clave en la aplicación, pues es necesario para poder realizar la acción principal de
  aplicar a voluntariados. Podríamos ver qué porcentaje de usuarios completa el perfil, y, sobre
  todo, en qué momento lo hacen. De esta manera podemos comparar eso contra el instante en el que se
  registró, para poder ver el tiempo que transcurre entre estos eventos, y analizar si no hay un
  punto de fricción allí.

### Pasos necesarios para la ejecución correcta de la aplicación

#### Enviar notificaciones

Para enviar notificaciones usamos FCM de Firebase. En primer lugar, debemos acceder al panel de FCM
dentro de la consola de Firebase.

- Para enviar las de noticia nueva, basta con crear una campaña de tipo notificaciones, completar la
  información pedida como el título y descripción. Es importante en el paso 5 poner como nombre de
  canal de comunicación "high_importance_channel" y agregar como parámetro extra uno llamado "
  deep_link" con valor "/news/id". El id lo podemos consultar desde Firestore. Al finalizar,
  pulsamos en Revisar y luego en Publicar
- Para enviar notificaciones específicas, hay que seguir los mismos pasos, llenar los mismos campos
  que antes (esta vez el deep link sería "/apply/idOportunidadVoluntariado"). La diferencia está en
  que en lugar de finalizar como en el paso anterior, debemos tener el token del usuario objetivo (
  visible como fcmToken dentro de la colección *volunteer* de Firestore) y pulsar "Enviar mensaje de
  prueba" dentro de la sección 1 de este menú.

#### Habilitación de links

Para el funcionamiento de los deep links a la hora de compartir noticias, es necesario que el
receptor tenga instalada la aplicación y asociados los links del dominio **serManos.com**.  
En Android esto se hace de la siguiente manera:

- Acceder a la configuración de la aplicación en Android (App info).
- Ir a la sección de abrir por defecto (open by default).
- Permitir la apertura de links asociados.
- Deberían estar sugeridos para activar los links del dominio **serManos.com**.
- En caso contrario, agregarlos manualmente.

#### Confirmación de aplicaciones de voluntariados

La aplicación solo cuenta con lógica para los usuarios que aplican, no para los organizadores. Por
lo tanto, es necesario realizar los cambios sobre la base de datos de manera directa.  
Esto se hace de la siguiente manera desde la consola de Firebase Firestore:

- Abrir la colección **volunteerOpportunities**.
- Dentro del documento en el listado **pendingApplicants**, eliminar el **uid** del usuario.
- Agregar el **uid** en el listado **confirmedApplicants**.
- Abrir la colección **volunteer**.
- Buscar el usuario que se confirmó.
- Agregar el **id** del voluntariado en el campo **currentVolunteering**.

El usuario en su aplicacion no vera el cambio reflejado en tiempo real, mas que el cambio en las
vacantes. Debera re-abrir la aplicacion para que tome efecto.
