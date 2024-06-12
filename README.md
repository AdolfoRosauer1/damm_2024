# DAMM 2024 - Grupo 2

###### Integrantes
- Juan Adolfo Rosauer Herrmann 
- Lucas Miguel Biolley Calvo
- Santiago Monjeau Castro

### Decisiones de implementación

##### Go Router sobre Beamer
Decidimos utilizar GoRouter como librería de navegación por sobre la alternativa de Beamer y el Navigator 2.0 de Flutter (o sea, no usar librería).  Los motivos detrás de esta decisión fueron la facilidad de la librería para manejar links anidados, la baja curva de aprendizaje (que permitió una puesta a punto rápida de la navegación en un primer momento) y la comunidad que hay detrás. Esto último resultó importante para el momento de manejar las rutas con las tabs, dado que pudimos encontrar no solo muchos desarrolladores que tuvieron las mismas dudas que nosotros, sino también soluciones apropiadas para este problema, como el **StatefulShellRoute** de GoRouter



### Problemas encontrados
##### Versiones de librerías conflictivas
Durante distintas etapas del desarrollo vimos como agregar dependencias traia consigo una consola llena de errores de build, indicando versiones conflictivas, mayoritariamente del Plugin de Kotlin para Gradle. En un primer momento, este error apareció al agregar Firebase, pero resultó ser por seguir unos pasos erróneos en su instalación, ya que tras hacer un rollback de todos estos pasos y seguir los de la página oficial, pudimos agregar Firebase al proyecto exitosamente. Sin embargo, más adelante en el desarrollo surgió un error similar al agregar la librería Geolocator(^12.0.0), usada para acceder a la ubicación del usuario. Al agregarla, volvió a aparecer el mismo error en la consola, que sugería cambiar la versión del plugin. Eso no arregló el error y en una búsqueda inicial ninguna solución encontrada en internet parecía servir, hasta encontrar una issue en el Github de la librería, donde marcaban que esa versión específica causaba el error, y que la solución (esta vez exitosa) era agregar otra dependencia al pubspec: geolocator_android:4.5.5.
### Flujo inscripción voluntariado
Cuando un usuario aplica a un voluntariado, este pasa a formar parte de una lista de pendientes para este voluntariado. En Firebase, esto se representa como un id (el uid que genera Firebase) dentro de un array llamado *pendingApplicants*, dentro de la colección *volunteerOpportunities* de **Firestore**. Para confirmalo, se debe mover desde la consola este id hacia el array *confirmedApplicants*, de el mismo registro. Para rechazar la postulación, se debe eliminar el id del usuario a eliminar de *pendingApplicants*

### Métricas
Definimos una serie de eventos a monitorear, basandonos en la importancia que creemos que tienen dentro del propósito de la aplicación, y el potencial valor que se podría agregar mejorando la experiencia del usuario al realizar estos eventos. Dichos eventos  son:
- Aplicación a un voluntariado:
Este evento representa el núcleo de la aplicación, ya que refleja el compromiso del usuario con el propósito principal de la plataforma: encontrar oportunidades de voluntariado y contribuir a causas relevantes. La cantidad de aplicaciones proporciona una medida clara del interés de los usuarios en las oportunidades presentadas, permitiendonos identificar las áreas de alta demanda y adaptar la oferta en consecuencia. Por ejemplo, podríamos ver que tipos de voluntariados son los que más llaman la atención, o los que más rápido se llenan.  El seguimiento de este evento también puede ayudar a evaluar la efectividad de las estrategias de presentación de oportunidades, como la relevancia de la información proporcionada y la facilidad de aplicación.
- Desaplicación a un voluntariado:
Este evento permitiría ver el grado de compromiso de los usuarios con el objetivo de la aplicación. Si se lo relaciona con el evento anterior, podríamos ver si lo usuarios se van de un voluntariado para inmediatamente aplicar a otro, o si solo están desaplicando. Podríamos ver la proporción entre aplicaciones y desaplicaciones, para armar así algún ranking de usuarios y proponer oportunidades de voluntariado diferentes según este.
- Compartir noticia:
Este evento muestra un nivel más profundo de compromiso y participación del usuario con la aplicación. Al compartir noticias relevantes relacionadas al mundo del voluntariado, los usuarios están contribuyendo activamente a la difusión de información y la promoción de la plataforma. También, podríamos usar esta información para ver que tipos de noticias son las que interesan a cada usuario, y ordenarselas en base a ello.
- Completar perfil: 
Es un evento clave en la aplicación, pues es necesario para poder realizar la acción principal de aplicar a voluntariados. Podríamos ver que porcentaje de usuarios completa el perfil, y, sobre todo, en que momento lo hacen. De esta manera podemos comparar eso contra el instante en el que se registró, para poder ver el tiempo que transcurre entre estos eventos, y analizar si no hay un punto de fricción allí.