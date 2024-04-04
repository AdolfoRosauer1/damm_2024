import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsCard extends StatelessWidget {
  final String media;
  final String imageUrl;
  final String title;
  final String description;
  const NewsCard(
      {super.key,
      required this.media,
      required this.imageUrl,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.network(
          imageUrl,
          width: 118,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  style: ProjectFonts.body2,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        print('Ver más');
                      },
                      style: TextButton.styleFrom(
                        textStyle: ProjectFonts.button,
                        foregroundColor: ProjectPalette.primary1,
                      ),
                      child: const Text('Leer Más'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
