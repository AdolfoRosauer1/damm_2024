import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplyConfirmationModal extends ConsumerWidget {
  const ApplyConfirmationModal(
      {super.key, required this.title, required this.oppId});

  final String title;
  final String oppId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        width: 280,
        decoration: BoxDecoration(
            color: ProjectPalette.neutral1,
            borderRadius: BorderRadius.circular(4),
            boxShadow: ProjectShadows.shadow3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.apply_confirmation,
                style: ProjectFonts.subtitle1
                    .copyWith(color: ProjectPalette.black)),
            Text(title, style: ProjectFonts.headline2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    textStyle: ProjectFonts.button,
                    foregroundColor: ProjectPalette.primary1,
                  ),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(firestoreControllerProvider)
                        .applyToOpportunity(oppId);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: TextButton.styleFrom(
                    textStyle: ProjectFonts.button,
                    foregroundColor: ProjectPalette.primary1,
                  ),
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
