import 'package:damm_2024/models/news.dart';
import 'package:damm_2024/screens/news_screen.dart';
import 'package:damm_2024/services/news_service.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key, required this.id});
  final int id;

  static const route = ":id";
  static String routeFromId (int id) => "${NewsScreen.route}/$id";
  @override
  State<StatefulWidget> createState() {
    return _NewsDetailsScreenState();
  }


}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {

  late NewsService _newsService;
  
  @override
  void initState() {
    super.initState();
    _newsService = NewsService();
  }

  @override
  Widget build(BuildContext context) {

    News news = _newsService.getNewsById(widget.id);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ProjectPalette.neutral1),
        centerTitle: true,
        backgroundColor: ProjectPalette.appBar,
        title: Text('Novedades',
          style: ProjectFonts.subtitle1.copyWith(color:ProjectPalette.neutral1,),
              )
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,24,16,32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                news.media,
                style: ProjectFonts.overline.copyWith(
                  color: ProjectPalette.neutral6,
                )
              ),
              Text(
                news.title,
                style: ProjectFonts.headline2
              ),
              const SizedBox(height: 16,),
              SizedBox(
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(news.imageUrl,fit: BoxFit.cover,)
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                news.description,
                style: ProjectFonts.subtitle1.copyWith(
                  color: ProjectPalette.secondary6
                ),
              ),
              const SizedBox(height: 16,),
              Text(news.body!,
                  style: ProjectFonts.body1,
              ),
              const SizedBox(height: 16,),
              Align(
                alignment: Alignment.center,
                child: Text('Comparte esta nota', style:
                  ProjectFonts.headline2
                ),
              ),
              const SizedBox(height: 16,),
              CtaButton(
                enabled: true,
                onPressed: () => {
                  print('Compartir ${news.title}')
                }, 
                filled: true, 
                actionStr: 'Compartir')
            ],
          ),
        ),
      ),
    );
    
  }
}