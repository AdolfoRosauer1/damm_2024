import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String media;
  final String imageUrl;
  final String title;
  final String description;

  const NewsCard(
      {super.key,
      required this.media,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          boxShadow: ProjectShadows.shadow2,
          color: ProjectPalette.neutral1),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              width: 118,
              fit: BoxFit.cover,
              // Error builder para utilzar una imagen stock para fallback
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
                      child: TextButton(
                        onPressed: onPressed,
                        style: TextButton.styleFrom(
                          textStyle: ProjectFonts.button,
                          foregroundColor: ProjectPalette.primary1,
                        ),
                        child: Text(AppLocalizations.of(context)!.readMore), //TEXTO A CAMBIAR
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
