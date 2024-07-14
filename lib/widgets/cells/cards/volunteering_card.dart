import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/providers/remote_config_provider.dart'; // Importa el provider de Remote Config
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/modals/finish_setup_modal.dart';
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
    required this.onPressedLocation,
    required this.type,
    required this.title,
    required this.vacancies,
    required this.imageUrl,
  });

  final VoidCallback onPressedLocation;
  final String type;
  final String title;
  final String imageUrl;
  final String id;
  final int vacancies;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VolunteeringCardState();
  }
}

class _VolunteeringCardState extends ConsumerState<VolunteeringCard> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileController = ref.watch(profileControllerProvider);
    final favoritesEnabledAsyncValue = ref.watch(favoritesEnabledProvider);

    bool isFav = user.hasFavorite(widget.id);

    return Container(
      decoration: BoxDecoration(
        color: ProjectPalette.neutral1,
        borderRadius: BorderRadius.circular(2),
        boxShadow: ProjectShadows.shadow2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.network(
                    widget.imageUrl,
                    height: 138,
                    fit: BoxFit.fitWidth,
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
                          favoritesEnabledAsyncValue.when(
                            data: (enabled) {
                              if (!enabled) return Container();
                              return InkWell(
                                onTap: () {
                                  if (user.hasCompletedProfile()) {
                                    if (isFav) {
                                      profileController.removeFavoriteVolunteering(widget.id);
                                    } else {
                                      profileController.addFavoriteVolunteering(widget.id);
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const FinishSetupModal(favAction: true);
                                      },
                                    );
                                  }
                                },
                                child: isFav ? ProjectIcons.favoriteFilledActivated : ProjectIcons.favoriteOutlinedActivated,
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => Text('Error: $error'),
                          ),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: widget.onPressedLocation,
                            child: ProjectIcons.locationFilledActivated,
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
