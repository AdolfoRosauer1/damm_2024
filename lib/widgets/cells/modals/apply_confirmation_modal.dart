import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class ApplyConfirmationModal extends StatelessWidget {
  const ApplyConfirmationModal({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        width: 280,
        decoration: BoxDecoration(
          color: ProjectPalette.neutral1,
          borderRadius: BorderRadius.circular(4),
          boxShadow: ProjectShadows.shadow3
        ),
        child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
              Text('Te estás por postular a', style: ProjectFonts.subtitle1.copyWith(
                color: ProjectPalette.black
              )),
              Text(title,style:ProjectFonts.headline2),
              Row(
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
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
           ],
           
        ),
      ),

    );
    
  }
}