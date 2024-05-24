import 'package:damm_2024/models/news.dart';
import 'package:damm_2024/screens/news_screen.dart';
import 'package:damm_2024/services/news_service.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  static const route = ":id";

  static String routeFromId(String id) => "${NewsScreen.route}/$id";

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late Future<News?> _newsFuture;
  late NewsService _newsService;

  @override
  void initState() {
    super.initState();
    _newsService = NewsService();
    _newsFuture = _newsService.getNewsById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ProjectPalette.neutral1),
        centerTitle: true,
        backgroundColor: ProjectPalette.appBar,
        title: const Text(
          'Novedades',
          style: TextStyle(
            color: ProjectPalette.neutral1,
          ),
        ),
      ),
      body: FutureBuilder<News?>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            //TODO Redirigir para atras?
            return const Center(child: Text('No se encontró la noticia'));
          } else {
            News news = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      news.media,
                      style: ProjectFonts.overline.copyWith(
                        color: ProjectPalette.neutral6,
                      ),
                    ),
                    Text(news.title, style: ProjectFonts.headline2),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          news.imageUrl,
                          fit: BoxFit.cover,
                          //Error builder para utilizar una imagen stock para fallback
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'lib/resources/news_card.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      news.description,
                      style: ProjectFonts.subtitle1.copyWith(
                          color: ProjectPalette.secondary6),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      news.body!,
                      style: ProjectFonts.body1,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Comparte esta nota',
                          style: ProjectFonts.headline2),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CtaButton(
                      enabled: true,
                      onPressed: () => {print('Compartir ${news.title}')},
                      filled: true,
                      actionStr: 'Compartir',
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
