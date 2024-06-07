import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SessionModal extends StatelessWidget {
  const SessionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: ProjectPalette.neutral1,
          borderRadius: BorderRadius.circular(4),
          boxShadow: ProjectShadows.shadow3
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16,16,16,0),
              child: Text(
                AppLocalizations.of(context)!.logout_confirmation, //TEXTO A CAMBIAR
                style: ProjectFonts.subtitle1
              ),
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.only(right: 16,bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      textStyle: ProjectFonts.button,
                      foregroundColor: ProjectPalette.primary1,
                    ),
                    child: Text(AppLocalizations.of(context)!.cancel), //TEXTO A CAMBIAR
                  ),
                  TextButton(
                    onPressed: () => {
                      //TODO
                    },
                    style: TextButton.styleFrom(
                      textStyle: ProjectFonts.button,
                      foregroundColor: ProjectPalette.primary1,
                    ),
                    child: Text(AppLocalizations.of(context)!.logout), //TEXTO A CAMBIAR
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}