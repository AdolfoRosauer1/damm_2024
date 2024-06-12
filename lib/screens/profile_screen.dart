//TODO conectar con riverpod y statemanagement
import 'package:damm_2024/models/gender.dart';
import 'package:damm_2024/providers/connectivity_provider.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/information_card.dart';
import 'package:damm_2024/widgets/cells/forms/personal_data_form.dart';
import 'package:damm_2024/widgets/cells/modals/no_internet_modal.dart';
import 'package:damm_2024/widgets/cells/modals/session_modal.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/molecules/buttons/short_button.dart';
import 'package:damm_2024/widgets/molecules/components/profile_picture.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const route = "/profileScreen";

  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(internetConnectionProvider);
    final internet = internetStatus.value! == InternetStatus.connected;

    final volunteer = ref.watch(currentUserProvider);
    if (!volunteer.hasCompletedProfile()) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 147.5,
              ),
              ProjectIcons.profilePicture,
              const SizedBox(
                height: 16,
              ),
              Text(AppLocalizations.of(context)!.volunteer,
                  style: ProjectFonts.overline
                      .copyWith(color: ProjectPalette.neutral6)),
              const SizedBox(
                height: 8,
              ),
              Text('${volunteer.firstName} ${volunteer.lastName}',
                  style: ProjectFonts.subtitle1),
              const SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context)!.completeProfile,
                style:
                    ProjectFonts.body1.copyWith(color: ProjectPalette.neutral6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 147.5,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ShortButton(
                  onPressed: () => {context.go(PersonalDataForm.completeRoute)},
                  buttonText: AppLocalizations.of(context)!.complete,
                  activated: true,
                  icon: Icon(ProjectIcons.addFilledEnabled.icon,
                      color: ProjectPalette.neutral1),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: ProfilePicture(
              imageUrl: volunteer.profileImageURL,
              size: ProfilePictureSize.large,
            ),
          ),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.volunteer,
              style: ProjectFonts.overline
                  .copyWith(color: ProjectPalette.neutral6)),
          const SizedBox(height: 2),
          Text('${volunteer.firstName} ${volunteer.lastName}',
              style: ProjectFonts.subtitle1),
          const SizedBox(height: 2),
          Text(volunteer.email, style: ProjectFonts.body1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: InformationCard(
              title: AppLocalizations.of(context)!.personalInformation,
              label1: AppLocalizations.of(context)!.birthDate,
              content1: dateFormat.format(volunteer.dateOfBirth!),
              label2: AppLocalizations.of(context)!.gender,
              content2: volunteer.gender!.localizedValue(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: InformationCard(
                title: AppLocalizations.of(context)!.contactInformation,
                label1: AppLocalizations.of(context)!.phone,
                content1: volunteer.phoneNumber,
                label2: 'E-MAIL',
                content2: volunteer.email),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(26, 0, 26, 46),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CtaButton(
                  enabled: true,
                  onPressed: () {
                    if (!internet) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const NoInternetModal();
                          });
                      return;
                    }
                    context.go(PersonalDataForm.completeRoute);
                  },
                  filled: true,
                  actionStr: AppLocalizations.of(context)!.editProfile,
                ),
                const SizedBox(
                  height: 8,
                ),
                CtaButton(
                    enabled: true,
                    onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const SessionModal();
                              })
                        },
                    filled: false,
                    actionStr: AppLocalizations.of(context)!.logout,
                    textColor: ProjectPalette.error),
              ],
            ),
          ),
        ],
      ));
    }
  }
}
