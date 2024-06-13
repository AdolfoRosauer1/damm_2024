import 'dart:async';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CancelVolunteerModal extends ConsumerWidget {
  const CancelVolunteerModal(
      {super.key, required this.title, required this.oppId});

  final String? title;
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
          boxShadow: ProjectShadows.shadow3,
        ),
        child: FutureBuilder<VolunteerDetails?>(
          future: title == null
              ? ref.read(firestoreControllerProvider).getVolunteerById(oppId)
              : Future.value(null),
          builder: (context, snapshot) {
            String displayTitle = title ?? '';
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              displayTitle = snapshot.data?.title ?? '';
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.cancel_confirmation,
                  style: ProjectFonts.subtitle1
                      .copyWith(color: ProjectPalette.black),
                ),
                Text(
                  displayTitle,
                  style: ProjectFonts.headline2,
                ),
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
                        try {
                          await ref
                              .read(firestoreControllerProvider)
                              .cancelOpportunity(oppId);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          print('Error canceling volunteer modal: $e');
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
            );
          },
        ),
      ),
    );
  }
}
