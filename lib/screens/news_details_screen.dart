import 'package:damm_2024/models/news.dart';
import 'package:damm_2024/providers/connectivity_provider.dart';
import 'package:damm_2024/screens/news_screen.dart';
import 'package:damm_2024/services/news_service.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:damm_2024/providers/remote_config_provider.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'; // Importa el provider de Remote Config

class NewsDetailsScreen extends ConsumerStatefulWidget {
  const NewsDetailsScreen({super.key, required this.id});

  final String id;

  static const route = ":id";

  static String routeFromId(String id) => "${NewsScreen.route}/$id";

  @override
  ConsumerState<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends ConsumerState<NewsDetailsScreen> {
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
    final shareNewsEnabledAsyncValue = ref.watch(shareNewsEnabledProvider);
    final internetStatus = ref.read(internetConnectionProvider);
    bool internet = false;

    internetStatus.whenData((data) {
      internet = data == InternetStatus.connected;
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ProjectPalette.neutral1),
        centerTitle: true,
        backgroundColor: ProjectPalette.appBar,
        title: Text(
          AppLocalizations.of(context)!.news,
          style: const TextStyle(
            color: ProjectPalette.neutral1,
          ),
        ),
      ),
      body: FutureBuilder<News?>(
        future: _newsFuture,
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
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text(AppLocalizations.of(context)!.newsNotFound));
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
                          // Error builder para utilizar una imagen stock para fallback
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/news_card.png',
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
                      style: ProjectFonts.subtitle1
                          .copyWith(color: ProjectPalette.secondary6),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      news.body,
                      style: ProjectFonts.body1,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    shareNewsEnabledAsyncValue.when(
                      data: (enabled) {
                        if (!enabled)
                          return Container(); // Si compartir noticias está deshabilitado, no muestra nada
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  AppLocalizations.of(context)!.shareThisNote,
                                  style: ProjectFonts.headline2),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CtaButton(
                              enabled: true,
                              onPressed: () => _newsService.shareNews(news),
                              filled: true,
                              actionStr: AppLocalizations.of(context)!.share,
                            ),
                          ],
                        );
                      },
                      loading: () => Center(
                        child: !internet
                            ? Text(
                                AppLocalizations.of(context)!.no_internet,
                                style: ProjectFonts.body1,
                                textAlign: TextAlign.center,
                              )
                            : const CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Text('Error: $error'),
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
