import 'package:damm_2024/models/news.dart';
import 'package:damm_2024/providers/connectivity_provider.dart';
import 'package:damm_2024/screens/news_details_screen.dart';
import 'package:damm_2024/services/news_service.dart';
import 'package:damm_2024/widgets/cells/cards/news_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  static const route = "/news";

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  late NewsService _newsService;

  @override
  void initState() {
    super.initState();
    _newsService = NewsService();
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.read(internetConnectionProvider);
    bool internet = false;

    internetStatus.whenData((data) {
      internet = data == InternetStatus.connected;
    });

    return Container(
      decoration: const BoxDecoration(
        color: ProjectPalette.secondary1,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: FutureBuilder<List<News>>(
              future: _newsService.getNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: !internet
                        ? Text(
                            AppLocalizations.of(context)!.no_internet,
                            style: ProjectFonts.body1,
                            textAlign: TextAlign.center,
                          )
                        : const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  FirebaseCrashlytics.instance
                      .recordError(snapshot.error, StackTrace.current);
                  return Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child:
                          Text(AppLocalizations.of(context)!.noNewsAvailable));
                }

                List<News> news = snapshot.data!;
                return ListView.separated(
                  itemBuilder: (context, index) => NewsCard(
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
              })),
    );
  }
}
