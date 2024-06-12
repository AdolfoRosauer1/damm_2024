import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolunteeringCard extends ConsumerStatefulWidget {
  const VolunteeringCard({
    super.key, 
    required this.id,
    required this.onPressed,
    required this.onPressedLocation,
    required this.isFav,
    required this.type,
    required this.title,
    required this.vacancies,
    required this.imageUrl, required this.onPressedFav});

  final VoidCallback onPressed;
  final VoidCallback onPressedFav;
  final VoidCallback onPressedLocation;
  final String type;
  final String title;
  final String imageUrl;
  final String id;
  final int vacancies;
  final bool isFav;
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VolunteeringCardState();
  }

}

class _VolunteeringCardState extends ConsumerState<VolunteeringCard> {
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
                    child: InkWell(
                      onTap: widget.onPressed,
                      child: Image.network(
                        widget.imageUrl,
                        height: 138,
                        fit: BoxFit.fitWidth,
                      ),
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
                    widget.type.toUpperCase(),
                    style: ProjectFonts.overline
                        .copyWith(color: ProjectPalette.neutral6),
                  ),
                  Text(
                    widget.title,
                    style: ProjectFonts.subtitle1
                        .copyWith(color: ProjectPalette.neutral2),
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VacanciesChip(vacancies: widget.vacancies, enabled: true),
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onPressedFav,
                            child: widget.isFav? ProjectIcons.favoriteFilledActivated :
                             ProjectIcons.favoriteOutlinedActivated,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: widget.onPressedLocation,
                            child: ProjectIcons.locationFilledActivated
                          ),
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
