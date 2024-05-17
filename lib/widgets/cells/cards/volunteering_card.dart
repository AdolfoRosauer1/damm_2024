import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VolunteeringCard extends StatelessWidget {
  const VolunteeringCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectPalette.neutral1,
        borderRadius: BorderRadius.circular(2),
        boxShadow: ProjectShadows.shadow2
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Column(
          children: [
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://s3-alpha-sig.figma.com/img/6160/48a8/56fafc1f797d16aeaaa7f76477bdc239?Expires=1716768000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jdrvFgOC34oAZ1wJYPZ1lShMsGd9mZqnf3je9v1az2Q2sqMLmN2IwvEvVihoptzRHfIU6Q5ulzY0OjLo~1tJbfzAhM7PiMZ60VtM8Y5oLJ4hBcRd0Kv84r59rtY2J2iPa8cMu3XfA57yuBICHCA2AyCF4Qz-1Nq1fc~UuoJvmQjsQLDwxrUMBuY6GKdKDfXRVIXYy-osBKsf0PXU-zC1EF4enrE3bo4Uvz7GOK2dpLhPkknRVWxbkci2dtQghal2Qu6JJzaOp8KNZHZ~CV5k-REDiHn7QjyTEMVhPZNpeLraEZrm-tBnWGGLkcq-TKSjk6wLWUBjIO2INX0w3Yxq1Q__',
                      height: 138,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8,),
                  Text(
                    'ACCIÓN SOCIAL',
                    style: ProjectFonts.overline
                        .copyWith(color: ProjectPalette.neutral6),
                  ),
                  Text(
                    'Un Techo para mi País',
                    style: ProjectFonts.subtitle1
                        .copyWith(color: ProjectPalette.neutral2),
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const VacanciesChip(vacancies: 20, enabled: true),
                      Row(
                        children: [
                          ProjectIcons.favoriteOutlinedActivated,
                          const SizedBox(
                            width: 16,
                          ),
                          ProjectIcons.locationFilledActivated,
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
