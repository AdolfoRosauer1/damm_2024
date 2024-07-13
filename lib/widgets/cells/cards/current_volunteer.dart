import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/screens/apply_screen.dart';
import 'package:damm_2024/screens/volunteer_details_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CurrentVolunteerSection extends ConsumerStatefulWidget {
  const CurrentVolunteerSection({
    required this.detailsList,
    super.key,
  });

  final List<VolunteerDetails> detailsList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CurrentVolunteerSectionState();
  }
}

class CurrentVolunteerSectionState
    extends ConsumerState<CurrentVolunteerSection> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final firestoreController = ref.read(firestoreControllerProvider);

    // Check if there is a matching element in detailsList
    bool test = widget.detailsList.any((volunteer) =>
        volunteer.id == user.currentVolunteering ||
        volunteer.id == user.currentApplication);
    if (test) {
      final data = widget.detailsList.firstWhere(
        (volunteer) =>
            volunteer.id == user.currentVolunteering ||
            volunteer.id == user.currentApplication,
      );
      return InkWell(
        onTap: () {
          context.go(VolunteerDetailsScreen.routeFromId(data.id));
        },
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(AppLocalizations.of(context)!.my_volunteerings,
                  style: ProjectFonts.headline1),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: ProjectPalette.primary3,
                borderRadius: BorderRadius.circular(8),
                boxShadow: ProjectShadows.shadow2,
                border: Border.all(color: ProjectPalette.primary1, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.type,
                            style: ProjectFonts.overline
                                .copyWith(color: ProjectPalette.neutral6),
                          ),
                          Text(
                            data.title,
                            style: ProjectFonts.subtitle1
                                .copyWith(color: ProjectPalette.neutral2),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          firestoreController.openLocationInMap(data.location);
                        },
                        child: ProjectIcons.locationFilledActivated,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    // Return an empty widget when no matching element is found
    return Container();
  }
}
