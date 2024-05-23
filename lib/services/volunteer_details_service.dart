import 'package:damm_2024/models/volunteer_details.dart';

class VolunteerDetailsService{
  final List<VolunteerDetails> _volunteers = [
    VolunteerDetails(
      id:1,
      imagePath: 'https://s3-alpha-sig.figma.com/img/6160/48a8/56fafc1f797d16aeaaa7f76477bdc239?Expires=1717372800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=MbmLuiQbMAlyjkDMdrCKz84SmNClj-mpAshFePfHscax14ku0lSr2qGkP0Oje1rxhSMvAE9VlVykyeuVo~Pdq4mcRvTkYtGdcr00x0jqZ~gwvcQ7rXgf8fYs0J6VjrHOqFXx4BkgcjdXBuAy-xdxmpDk4LYMreMvKwR~Rl93GLLpzKr0NhBE0ZMNZnDcew6S9cnIRryX~QdkwuYD3VdjNAZoJ9cIWnMMLiNFLuwRy~WfL87wR1gyWh5NLrQPAszFMpzKub6AuUjkP9wMi4aPasDatrLZcxgrjTOHba40h1iVWnYyfgv-NQGRGEgBl6ZL1hRrw1Su~naa2SpYRmr7jg__',
      title: 'Un Techo para mi País',
      mission: 'El propósito principal de "Un techo para mi país" es reducir el déficit habitacional y mejorar las condiciones de vida de las personas que no tienen acceso a una vivienda adecuada.',
      type: 'Acción Social',
      details: 'Te necesitamos para construir las viviendas de las personas que necesitan un techo. Estas están prefabricadas en madera y deberás ayudar en carpintería, montaje, pintura y demás actividades de la construcción.',
      vacancies: 10,
      latitude: -32.947,
      longitude: -68.847,
      address: 'Barrio La Gloria, Godoy Cruz, Mendoza',
      requirements: '''- Mayor de edad.
- Poder levantar cosas pesadas''',
      createdAt: DateTime.now()
    ),
    VolunteerDetails(
      id:2,
      type: 'Acción Social',
      imagePath: 'https://s3-alpha-sig.figma.com/img/8bbc/83c6/6d6e4bcbf3c909838293a3128e40c314?Expires=1717372800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=YVs5ue12y7~Up0tNZGTJ7teRDuNzjHB4WTFWNB1INpQnlFlQtvklXbe-XsA-HBSVAJieGucGVDvKTsHimw1oE5o8VAOGPIOCLkKyGcq4Jlqi-ZNRZEtBpehg-VTTQsYE82lcG1QHpc5s66btsjamiAPE4EhIYNjT0igUKjn2PGvqJwAgjANgZP-M26bGsfPpKGeBc7Q-wMlUjR5JKdkARkSx4TIcgdejEBbxPVEKcNkPq1j2vZ3m4ywIJZ-xfLe~kQ5nNKOb-BMgY4p5~Zr48h90QNkPyek09Rp8viZVHSxcgXbt4hj02i-JUfcynWc6hqeLPyApAidS~JzfKxEwXA__',
      title: 'Manos Caritativas',
      vacancies: 10,
      address: 'Barrio La Gloria, Godoy Cruz, Mendoza',
      mission: 'Manos Caritativas es una organización sin fines de lucro que se dedica a ayudar a las personas en situación de calle. Nuestro objetivo es brindarles un plato de comida caliente y un lugar seguro donde pasar la noche.',
      details: 'Buscamos voluntarios que nos ayuden a cocinar, servir la comida y acondicionar el lugar para que las personas puedan pasar la noche. También necesitamos personas que nos ayuden a concientizar a la comunidad sobre la situación de las personas en situación de calle.',
      requirements: 'Ser mayor de 18 años, tener disponibilidad horaria, ser proactivo y tener ganas de ayudar.',
      latitude: -32.947,
      longitude: -68.847,
      createdAt: DateTime.now()
    )
  ];

  List<VolunteerDetails> getVolunteers(){
    return _volunteers;
  }

  getVolunteerById(int id) {
    return _volunteers.firstWhere((element) => element.id == id);
  }
}