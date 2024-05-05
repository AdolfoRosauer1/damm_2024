import 'package:damm_2024/models/news.dart';

class NewsService{
  final _news = [
    News(
      id:1,
      title: 'Ser donante voluntario',
      description: 'Desde el Hospital Centenario recalcan la importancia de la donación voluntaria de Sangre',
      imageUrl: 'https://s3-alpha-sig.figma.com/img/839a/009b/380a4b7407209dad0aeec257c6df7298?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IEBEzBDeUmPFpzcb3y5MEldtPgWuj3Nh6ZRk-036ROrPGRRnVMN61jCDR2efkfyD6nDFtjSZLBPaOUWgNgeiEXkDJnJPAUchADg3smGrOol2VrN41NL5ngZ07~Wss23nM-42yhaQsV0zTlTJcyHPNaMtTFiFcp6slvRzXB8A1VUC1FnwB2GvB8b44z7JEX-hY7xOLbDW9k5tWQqJmHdeXJE7k2-an3nx20bKThm8kuLG-bptZb~l2QQLBNfCBhq1bYMCWKPAYxF8wRCK9i~djVifSz1AO9ZT3vwzT1DmkDMt4I0IhBcW9-8pAp9fkgjSmSw9~Y-NFnUBRYmZ-zDhxQ__',
      media: 'REPORTE 2820',
      body: '''En un esfuerzo por concienciar sobre la necesidad constante de sangre y sus componentes, el Hospital Centenario destaca la importancia de convertirse en un donante voluntario. La donación de sangre es un acto solidario y altruista que puede salvar vidas y mejorar la salud de aquellos que enfrentan enfermedades graves o accidentes.

La donación voluntaria de sangre desempeña un papel vital en el sistema de salud. A diferencia de la donación de sangre por reposición, donde se solicita a familiares y amigos donar para un paciente específico, la donación voluntaria se realiza sin ninguna conexión directa con un receptor particular. Esto garantiza un suministro constante y seguro de sangre y productos sanguíneos para todos aquellos que lo necesiten.

Los beneficios de ser donante voluntario son numerosos. Además de la satisfacción de ayudar a quienes más lo necesitan, la donación de sangre tiene beneficios para la salud del propio donante. Al donar sangre, se realiza un chequeo médico que incluye pruebas para detectar enfermedades transmisibles, lo que puede proporcionar una evaluación temprana y ayuda en el diagnóstico de posibles problemas de salud.
        '''),
    News(
      id:2,
      title:'Juntamos residuos',
      description: 'Voluntarios de Godoy Cruz, se sumaron a la limpieza de un cauce  en las inmediaciones.',
      imageUrl: 'https://s3-alpha-sig.figma.com/img/9d9d/8b2b/1b4848e87872562e2c1a855aa6f6ff14?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OaTUC9UTtgVDWpQ8I3aDLod8c9Rd874KAu~tBQhpjvCcjnU8WQ5G9SWMsDfoFhfVsuSo7rCmSxPJQ8Nc-dYpJ2JmLhNVPgJpXSgQC1JjO18tKRQDa78F9Fg0uTLJrCOpy9IS1A5fWU5OtF~WWPuiatFs3M4fWO1Z17u91AVxZLa3OS-nNFwdD-LIVZCn~PpzgiFrJnQYiy4mYU0f~Akwk1h3q7q3~NRAqR3Jt92sJPLztn71K8aaLpKnp-GEX9kgltWNwf-xL8JjmNeq-nCT1XZNuaq1BmAXU4mCDDGcZbAlVtfZFybzN~cQdnxrpUD6CDhXvmvnasv~cc3jP8UXtA__',
      media: 'NOTICIAS DE CUYO',
      body:''
    ),
    News(
      id:3,
      title:'Adoptar mascotas',
      description: 'Ayudanos a limpiar las calles de perros callejeros adoptándolos evitando la sobrepoblación de las perreras.',
      imageUrl: 'https://s3-alpha-sig.figma.com/img/614a/f89d/ddcf837280c90c026e0b41672fbd114a?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=InAkqRfJH0a3o58RO1MMWjonM8V9f02W~nvsQdUsv2HO1E0pFaHMB4tP8PlLrsX2RcqCnsBi7jhhwB4wa4w-GvlRXMDyRY83rL6BmJK~5ApbszYOu8afJ8BGxKx5v7NZWftEuV6R-mZ7FXTDDFM6TAWpMg~l-r8o6LZT~7Kbz09tddrb7NmP~VVaOUTL8QPgEUdl903YeV7d8pQGmoh6wOBy5xvv3rT8OLF1l-35fZHumLq0MH7rkKzqWPryxuhfdNh1dyyVnOXAjzzQsfO-tsOgcHlCwZOwaqzxphZCl8siaZTk3NssIramo6o0ZVUfTj1u68YhVv0RW2VVWgs~lw__',
      media: 'DIARIO LA NACION',
      body:''
    ),
    News(
      id:4,
      title:'Preservamos la fauna',
      description: 'Córdoba se suma a la lalalalalallalalalalalalalalallalalalallalalalalalalalalalalalalalalalalalallalala.',
      imageUrl: 'https://s3-alpha-sig.figma.com/img/bf1c/454a/07b44933fe080e986551bc68e44ac23c?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=nA2zYBZ3xsqZzAle7Rra2ypFS0wVN8LXnflS3zpDwQ-4LxSIALR2rCBKzX-wl1lLYgwCLGS-owNjr6WvMuZUXR4BOTgFnDFmhmDOfSLTQ5ARFJ~2rERwuVHyqi76QuU21-keBhfu3nTthrMpVw9NnYOXQqp4UsJTTzrf0CIRnyzncJNHoJgnffIqqL56RDcacqNoQM82fJKWVaMOcpZMjb3kCmoFMJc4e3Jo2qINUS9ruUQlquEprL~p8lp-THPNODU4lsRuMK7uO0sbc0c6V5AOoX72fx13f~OeKMxglY-ZlYcQDM93VnNfh5p7i524XdQ7ARtvYo7zLllxsgfBrg__',
      media: 'LA VOZ DEL INTERIOR',
      body:''
    ),
  ];

  News getNewsById(int id){
    return _news.firstWhere((element) => element.id == id);
  }

  List<News> getNews(){
    return _news;
  }
}