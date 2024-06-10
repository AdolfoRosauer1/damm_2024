import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/screens/apply_screen.dart';
import 'package:damm_2024/services/volunteer_details_service.dart';
import 'package:damm_2024/widgets/cells/cards/information_card.dart';
import 'package:damm_2024/widgets/cells/modals/apply_confirmation_modal.dart';
import 'package:damm_2024/widgets/cells/modals/cancel_volunteer_modal.dart';
import 'package:damm_2024/widgets/cells/modals/unapply_modal.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolunteerDetailsScreen extends ConsumerStatefulWidget {
  const VolunteerDetailsScreen({super.key, required this.id});
  static const route = ":id";
  static String routeFromId(String id) => "${ApplyScreen.route}/$id";

  final String id;

  @override
  _VolunteerDetailsScreenState createState() => _VolunteerDetailsScreenState();
}

class _VolunteerDetailsScreenState
    extends ConsumerState<VolunteerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    final volunteerDetailsAsyncValue =
        ref.watch(volunteerDetailsProviderProvider(widget.id));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ProjectPalette.neutral1),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF000000), Color(0x00000000)]),
          ),
        ),
      ),
      body: volunteerDetailsAsyncValue.when(
        data: (volunteerDetails) {
          if (volunteerDetails == null) {
            return Center(child: Text(AppLocalizations.of(context)!.no_data));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(volunteerDetails.imageUrl),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    volunteerDetails.type.toUpperCase(),
                    style: ProjectFonts.overline
                        .copyWith(color: ProjectPalette.neutral6),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(volunteerDetails.title,
                      style: ProjectFonts.headline1),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    volunteerDetails.mission,
                    style: ProjectFonts.body1
                        .copyWith(color: ProjectPalette.secondary6),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(AppLocalizations.of(context)!.about_activity,
                      style: ProjectFonts.headline2),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      Text(volunteerDetails.details, style: ProjectFonts.body1),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      VolunteerDetailsService()
                          .openLocationInMap(volunteerDetails.location);
                    },
                    child: InformationCard(
                      title: AppLocalizations.of(context)!.location,
                      label1: AppLocalizations.of(context)!.address,
                      content1: volunteerDetails.address,
                      label2: '',
                      content2: '',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      AppLocalizations.of(context)!.participate_in_volunteer,
                      style: ProjectFonts.headline2),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(AppLocalizations.of(context)!.requirements,
                      style: ProjectFonts.subtitle1),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MarkdownBody(
                    data: volunteerDetails.requirements,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: ProjectFonts.body1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(AppLocalizations.of(context)!.availability,
                      style: ProjectFonts.subtitle1),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MarkdownBody(
                    data: volunteerDetails.timeAvailability,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: ProjectFonts.body1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VacanciesChip(
                          vacancies: volunteerDetails.remainingVacancies,
                          enabled: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (volunteerDetails.isUserConfirmed(currentUser.uid))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.confirmed_title,
                            style: ProjectFonts.headline2),
                        Text(
                          AppLocalizations.of(context)!.confirmed_body,
                          style: ProjectFonts.body1,
                          textAlign: TextAlign.center,
                        ),
                        CtaButton(
                          enabled: true,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CancelVolunteerModal(
                                  title: volunteerDetails.title,
                                  oppId: volunteerDetails.id),
                            );
                          },
                          filled: false,
                          actionStr:
                              AppLocalizations.of(context)!.cancel_volunteer,
                        ),
                      ],
                    ),
                  )
                else if (volunteerDetails.isUserPending(currentUser.uid))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.applied_title,
                            style: ProjectFonts.headline2),
                        Text(
                          AppLocalizations.of(context)!.applied_body,
                          style: ProjectFonts.body1,
                          textAlign: TextAlign.center,
                        ),
                        CtaButton(
                          enabled: true,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => UnApplyModal(
                                  title: volunteerDetails.title,
                                  oppId: volunteerDetails.id),
                            );
                          },
                          filled: false,
                          actionStr: AppLocalizations.of(context)!.un_apply,
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CtaButton(
                      enabled: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ApplyConfirmationModal(
                              title: volunteerDetails.title,
                              oppId: volunteerDetails.id),
                        );
                      },
                      filled: true,
                      actionStr: AppLocalizations.of(context)!.apply_now,
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '${AppLocalizations.of(context)!.error}: $error',
          ),
        ),
      ),
    );
  }
}
