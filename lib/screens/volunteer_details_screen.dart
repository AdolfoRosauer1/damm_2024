import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/screens/apply_screen.dart';
import 'package:damm_2024/services/volunteer_details_service.dart';
import 'package:damm_2024/utils/maps_utils.dart';
import 'package:damm_2024/widgets/cells/cards/information_card.dart';
import 'package:damm_2024/widgets/cells/modals/apply_confirmation_modal.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/molecules/components/vacancies_chip.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //Si no funciona comentar y hacer flutter run, ahi debería andar


class VolunteerDetailsScreen extends StatefulWidget {
  const VolunteerDetailsScreen({super.key, required this.id});
  static const route = ":id";
  static String routeFromId(String id) => "${ApplyScreen.route}/$id";

  final String id;

  @override
  State<StatefulWidget> createState() {
    return _VolunteerDetailsScreenState();
  }
}

class _VolunteerDetailsScreenState extends State<VolunteerDetailsScreen> {
  late VolunteerDetailsService _service;
  late Future<VolunteerDetails?> _future;

  @override
  void initState() {
    super.initState();
    _service = VolunteerDetailsService();
    _future = _service.getVolunteerById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
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
      body: FutureBuilder<VolunteerDetails?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            VolunteerDetails volunteerDetails = snapshot.data!;
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
                      style: ProjectFonts.overline.copyWith(color: ProjectPalette.neutral6),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(volunteerDetails.title, style: ProjectFonts.headline1),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      volunteerDetails.mission,
                      style: ProjectFonts.body1.copyWith(color: ProjectPalette.secondary6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Sobre la actividad', style: ProjectFonts.headline2),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(volunteerDetails.details, style: ProjectFonts.body1),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        _service.openLocationInMap(volunteerDetails.location);
                      },
                      child: InformationCard(
                        title: 'Ubicación',
                        label1: 'DIRECCIÓN',
                        content1: volunteerDetails.address,
                        label2: '',
                        content2: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Participar del voluntariado', style: ProjectFonts.headline2),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(AppLocalizations.of(context)!.requirements, style: ProjectFonts.subtitle1),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MarkdownBody(
                      data: volunteerDetails.requirements,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        p: ProjectFonts.body1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Disponibilidad', style: ProjectFonts.subtitle1),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MarkdownBody(
                      data: volunteerDetails.timeAvailability,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
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
                        VacanciesChip(vacancies: volunteerDetails.vacancies, enabled: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CtaButton(
                      enabled: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ApplyConfirmationModal(title: volunteerDetails.title),
                        );
                      },
                      filled: true,
                      actionStr: 'Postularme',
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Sin datos'));
          }
        },
      ),
    );
  }
}
