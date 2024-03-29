import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VolunteeringCard extends StatelessWidget {
  const VolunteeringCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        boxShadow: ProjectShadows.shadow2
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            height: 138,
            'https://s3-alpha-sig.figma.com/img/6160/48a8/56fafc1f797d16aeaaa7f76477bdc239?Expires=1711929600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=nSrnZy3veXu1utLO0iEVTj3ZELjEvZr3ow8oqiqILdyL7g2V8yWu7Hz9mcNqa8ynoicuAntXeek4j0hGITPYyAKUpUKldX4p5i-mTWSLvKYiHYHiD7BWwT5FVrTgUa9~TlM2yifBmbti~vyfixF37JwB0wGsvAghX2PYBqM46-ZmGBcq2ABlnJOILqtqskQS~RKxLO0gHMqiyOLxnkM37GePSydJX8FfDBUf6XJtrYqe4zLIS1R6Q1-rQNXa8VGrhxjEXTX393NrfbG1BTcknEMcXYZtk5nS7zEO8JNf~RyBZ5Z0cvKke0F9-aqKMjTxuYxIypougWGiGsQw~OAcyQ__', // URL de la imagen
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACCIÓN SOCIAL',
                    style: ProjectFonts.overline.copyWith(
                      color: ProjectPalette.neutral6
                    ),
                  ),
                  Text(
                    'Un Techo para mi País',
                    style: ProjectFonts.subtitle1.copyWith(
                      color: ProjectPalette.neutral2
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VacanciesChip(vacancies: 20, enabled: true),
                      Row(
                        children: [
                          ProjectIcons.favoriteOutlinedActivated,
                          SizedBox(
                            width: 16,
                          ),
                          ProjectIcons.locationFilledActivated,
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
