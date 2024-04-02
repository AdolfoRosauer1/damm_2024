
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsCard extends StatelessWidget{
  final String media;
  final String imageUrl;
  final String title;
  final String description;
  const NewsCard({super.key, required this.media, required this.imageUrl, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
      border: Border.all(color: Colors.black), // Black border
    ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            width: 118,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    media,
                    style: ProjectFonts.overline.copyWith(
                      color: ProjectPalette.neutral6
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
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // Black border
                    ),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Ver más');
                          },
                          style: TextButton.styleFrom(
                            textStyle: ProjectFonts.button,
                            foregroundColor: ProjectPalette.primary1,
                          ),
                          child: const Text('Leer Más'),
                        ),
                       // SizedBox(width: 4,)
                      ],
                    ),
                  )
                ],
              ),
            
            
            ),
          )
          
      
      
        ],
      ),
    );
/*
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 118,
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'REPORTE 2820',
                  style: ProjectFonts.overline.copyWith(
                    color: ProjectPalette.neutral6,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ser donante voluntario',
                  style: ProjectFonts.subtitle1,
                ),
                SizedBox(height: 8),
                Text(
                  'Desde el Hospital Centenario recalcan la importancia de la donación voluntaria de Sangre',
                  style: ProjectFonts.body2,
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
    */
  }
}