import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoInternetModal extends ConsumerWidget {
  const NoInternetModal();

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
            Text(AppLocalizations.of(context)!.no_internet,
                style: ProjectFonts.subtitle1
                    .copyWith(color: ProjectPalette.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
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
