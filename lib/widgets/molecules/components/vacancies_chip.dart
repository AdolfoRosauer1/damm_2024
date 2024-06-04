import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VacanciesChip extends StatelessWidget {
  final int vacancies;
  final bool enabled;
  const VacanciesChip({super.key, required this.vacancies, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? ProjectPalette.secondary2 : ProjectPalette.neutral4,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              AppLocalizations.of(context)!.vacancies, //TEXTO A CAMBIAR
              style: ProjectFonts.body2
            ),
          ),
          SizedBox(width: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            child: Row(
              children: [
                enabled ? ProjectIcons.personFilledActivated : ProjectIcons.personFilledDisabled,
                Text(
                  vacancies.toString(),
                  style: enabled ? ProjectFonts.subtitle1.copyWith(color: ProjectPalette.secondary6)
                  : ProjectFonts.subtitle1.copyWith(color: ProjectPalette.secondary4),
                      
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
