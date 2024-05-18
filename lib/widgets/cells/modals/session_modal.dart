import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                '¿Estás seguro que quieres cerrar sesión?',
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
                    child: const Text('Cancelar', ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      textStyle: ProjectFonts.button,
                      foregroundColor: ProjectPalette.primary1,
                    ),
                    child: const Text('Cerrar sesión'),
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