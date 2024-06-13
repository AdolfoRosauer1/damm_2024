import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FinishSetupModal extends ConsumerWidget {
  final bool favAction;
  const FinishSetupModal({
    super.key,
    required this.favAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Dialog(
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: ProjectPalette.neutral1,
          borderRadius: BorderRadius.circular(4),
          boxShadow: ProjectShadows.shadow3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                favAction? AppLocalizations.of(context)!.finish_setup_fav:AppLocalizations.of(context)!.finish_setup_apply,
                style: ProjectFonts.subtitle1,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Row(
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
                    //   must go to finish setup
                      if(context.mounted){
                        context.go('/profileScreen/editProfile');
                        context.pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      textStyle: ProjectFonts.button,
                      foregroundColor: ProjectPalette.primary1,
                    ),
                    child: Text(AppLocalizations.of(context)!.confirm_finish_setup),
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
