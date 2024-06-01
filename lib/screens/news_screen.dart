import 'package:damm_2024/models/news.dart';
import 'package:damm_2024/screens/news_details_screen.dart';
import 'package:damm_2024/services/news_service.dart';
import 'package:damm_2024/widgets/cells/cards/news_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  static const route = "/news";

  @override
  State<StatefulWidget> createState() {
    return _NewsScreenState();
  }
}

class _NewsScreenState extends State<NewsScreen> {
  late NewsService _newsService;
  @override
  void initState() {
    super.initState();
    _newsService = NewsService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ProjectPalette.secondary1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 16),
        child: FutureBuilder<List<News>>(
          future: _newsService.getNews(),
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text(AppLocalizations.of(context)!.noNewsAvailable));
            }

            List<News> news = snapshot.data!;
            return ListView.separated(
              itemBuilder: (context, index) => 
                NewsCard(
                  media: news[index].media,
                  imageUrl: news[index].imageUrl,
                  title: news[index].title,
                  description: news[index].description,
                  onPressed: () => {
                    context.go(NewsDetailsScreen.routeFromId(news[index].id))
                  },
                ),
              
              separatorBuilder: (_, __) => const SizedBox(height: 24), 
              itemCount: news.length,
              
            );
          }
        )
      
          
      ),
    );
  
  }
}
