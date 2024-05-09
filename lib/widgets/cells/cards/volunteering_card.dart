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
                      'https://s3-alpha-sig.figma.com/img/6160/48a8/56fafc1f797d16aeaaa7f76477bdc239?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=h7vv9iO2rfgE-fwb6rvDN9jm6FazddmTtKkQzh-Yr4oJwhXUrQZCxtKNAELsI6YikkzmCN2~b5ihohwMrbNoBDaxXeE3c1Ak7uG0z0iOjQlsnEA81DpvnYSXEtSaalzhRpoAubhUuWlnMl5ynciPisW3fRp032K~3QtfzXNRKmLEFHPRI1pM7BTsc8c4UJ1EFGvPWcVwYvf8rjAU4iI-Bm58maxjapXaZUUFAoTN-Vn1xCZ-aa3mZn3JgKoh8VIPD~MEwuGVDLuqV9iC8cZC5~4pXv0PiUr0jpgK7aXnJ-GBZfpibOLScTy9MT6LgGZHIXVbZcDmVRIF1Tju3WpFVg__',
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
