import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:damm_2024/providers/remote_config_provider.dart'; // Importa el provider de Remote Config
import 'package:share_plus/share_plus.dart'; // Importa el paquete para compartir

class NewsCard extends ConsumerWidget {
  final VoidCallback onPressed;
  final String media;
  final String imageUrl;
  final String title;
  final String description;

  const NewsCard({
    super.key,
    required this.media,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareNewsEnabledAsyncValue = ref.watch(shareNewsEnabledProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        boxShadow: ProjectShadows.shadow2,
        color: ProjectPalette.neutral1,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              width: 118,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/news_card.png',
                  width: 118,
                  fit: BoxFit.cover,
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          media,
                          style: ProjectFonts.overline.copyWith(
                            color: ProjectPalette.neutral6,
                          ),
                        ),
                        Text(
                          title,
                          style: ProjectFonts.subtitle1,
                        ),
                        Text(
                          description,
                          style: ProjectFonts.body2.copyWith(
                            color: ProjectPalette.neutral6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: onPressed,
                            style: TextButton.styleFrom(
                              textStyle: ProjectFonts.button,
                              foregroundColor: ProjectPalette.primary1,
                            ),
                            child: Text(AppLocalizations.of(context)!.readMore),
                          ),
                          shareNewsEnabledAsyncValue.when(
                            data: (enabled) {
                              if (!enabled) return Container(); // Si compartir noticias está deshabilitado, no muestra el botón
                              return IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  // Lógica para compartir la noticia
                                  Share.share('Mira esta noticia: $title\n\n$imageUrl');
                                },
                              );
                            },
                            loading: () => CircularProgressIndicator(),
                            error: (error, stack) => Text('Error: $error'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


