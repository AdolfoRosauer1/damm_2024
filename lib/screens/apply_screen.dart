import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/screens/volunteer_details_screen.dart';
import 'package:damm_2024/services/volunteer_details_service.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/no_volunteers_card.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApplyScreen extends StatefulWidget {
  static const route = "/apply";

  const ApplyScreen({super.key});

  @override
  _ApplyScreenState createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final VolunteerDetailsService _volunteerDetailsService = VolunteerDetailsService();
  late Future<List<VolunteerDetails>> _volunteers;
  late Future<bool> _areVolunteersAvailable;

  void loadVolunteers() {
    setState(() {
      _volunteers = _volunteerDetailsService.getVolunteers(query: _searchController.text);
      _areVolunteersAvailable = _volunteerDetailsService.areVolunteersAvailable();
    });
  }

  @override
  void initState() {
    super.initState();
    _areVolunteersAvailable = _volunteerDetailsService.areVolunteersAvailable();
    _volunteers = _volunteerDetailsService.getVolunteers(query: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: const BoxDecoration(
        color: ProjectPalette.secondary1,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ProjectPalette.neutral1,
                borderRadius: BorderRadius.circular(2),
                boxShadow: ProjectShadows.shadow1,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => loadVolunteers(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'Buscar',
                  hintStyle: ProjectFonts.subtitle1.copyWith(color: ProjectPalette.neutral6),
                  prefixIcon: _searchController.text.isEmpty 
                      ? ProjectIcons.searchFilledEnabled 
                      : null,
                  suffixIcon: _searchController.text.isEmpty
                      ? ProjectIcons.mapFilledActivated
                      : IconButton(
                          icon: ProjectIcons.closeFilledEnabled,
                          onPressed: () {
                            _searchController.clear();
                            loadVolunteers();
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Voluntariados', style: ProjectFonts.headline1),
            Expanded(
              child: FutureBuilder<bool>(
                future: _areVolunteersAvailable,
                builder: (context, availabilitySnapshot) {
                  if (availabilitySnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (availabilitySnapshot.hasError) {
                    return Center(child: Text('Error: ${availabilitySnapshot.error}'));
                  } else if (availabilitySnapshot.hasData && !availabilitySnapshot.data!) {
                    return const Column(
                      children: [
                        SizedBox(height: 16),
                        NoVolunteersCard(
                          size: NoVolunteersCardSize.small,
                          message: 'Actualmente no hay voluntariados vigentes. Pronto se irán ircorporando nuevos',
                        ),
                      ],
                    );
                  } else {
                    return FutureBuilder<List<VolunteerDetails>>(
                      future: _volunteers,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<VolunteerDetails> volunteerDetails = snapshot.data!;
                          if (volunteerDetails.isEmpty) {
                            return const Column(
                              children: [
                                  SizedBox(height: 16),
                                  NoVolunteersCard(
                                  size: NoVolunteersCardSize.medium,
                                  message: 'No hay voluntariados vigentes para tu búsqueda',
                                ),
                              ]
                            );
                          } 
                          return ListView.separated(
                            padding: const EdgeInsets.only(top: 24),
                            separatorBuilder: (_, __) => const SizedBox(height: 24),
                            itemCount: volunteerDetails.length,
                            itemBuilder: (context, index) {
                              return VolunteeringCard(
                                onPressedLocation: () {
                                  _volunteerDetailsService.openLocationInMap(volunteerDetails[index].location);
                                },
                                onPressed: () {
                                  context.go(VolunteerDetailsScreen.routeFromId(volunteerDetails[index].id));
                                },
                                type: volunteerDetails[index].type,
                                title: volunteerDetails[index].title,
                                vacancies: volunteerDetails[index].vacancies,
                                imageUrl: volunteerDetails[index].imageUrl,
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('Sin datos disponibles'));
                        }
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 11),
          ],
        ),
      ),
    );
  }
}
