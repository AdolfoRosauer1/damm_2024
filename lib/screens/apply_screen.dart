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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

// TODO: refactor to ConsumerStatefulWidget
class ApplyScreen extends ConsumerStatefulWidget {
  static const route = "/apply";

  const ApplyScreen({super.key});

  @override
  _ApplyScreenState createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  // TODO: MAINTAIN _searchController, DO NOT use a Provider
  final TextEditingController _searchController = TextEditingController();
  // TODO: use firestoreControllerProvider for all service methods
  final VolunteerDetailsService _volunteerDetailsService =
      VolunteerDetailsService();
  late Future<List<VolunteerDetails>> _volunteers;
  late Future<bool> _areVolunteersAvailable;
  Position? _userPosition;

  void loadVolunteers() {
    setState(() {
      _volunteers = _volunteerDetailsService.getVolunteers(
          query: _searchController.text, userPosition: _userPosition);
      _areVolunteersAvailable =
          _volunteerDetailsService.areVolunteersAvailable();
    });
  }

  // TODO: maintain getUserLocation method. DO NOT USE A PROVIDER
  Future<void> _getUserLocation() async {
    print("USER LOCATIONMMMMMMMMMMMMMMM");
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userPosition = position;
      loadVolunteers();
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _areVolunteersAvailable = _volunteerDetailsService.areVolunteersAvailable();
    _volunteers =
        _volunteerDetailsService.getVolunteers(query: _searchController.text);
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: AppLocalizations.of(context)!.search,
                  hintStyle: ProjectFonts.subtitle1
                      .copyWith(color: ProjectPalette.neutral6),
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
            Text(AppLocalizations.of(context)!.volunteerings,
                style: ProjectFonts.headline1),
            Expanded(
              child: FutureBuilder<bool>(
                future: _areVolunteersAvailable,
                builder: (context, availabilitySnapshot) {
                  if (availabilitySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (availabilitySnapshot.hasError) {
                    return Center(
                        child: Text(
                            '${AppLocalizations.of(context)!.error}: ${availabilitySnapshot.error}'));
                  } else if (availabilitySnapshot.hasData &&
                      !availabilitySnapshot.data!) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        NoVolunteersCard(
                          size: NoVolunteersCardSize.small,
                          message: AppLocalizations.of(context)!.noVolunteers,
                        ),
                      ],
                    );
                  } else {
                    return FutureBuilder<List<VolunteerDetails>>(
                      future: _volunteers,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<VolunteerDetails> volunteerDetails =
                              snapshot.data!;
                          if (volunteerDetails.isEmpty) {
                            return Column(children: [
                              const SizedBox(height: 16),
                              NoVolunteersCard(
                                size: NoVolunteersCardSize.medium,
                                message: AppLocalizations.of(context)!
                                    .noVolunteersSearch,
                              ),
                            ]);
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.only(top: 24),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 24),
                            itemCount: volunteerDetails.length,
                            itemBuilder: (context, index) {
                              return VolunteeringCard(
                                onPressedLocation: () {
                                  _volunteerDetailsService.openLocationInMap(
                                      volunteerDetails[index].location);
                                },
                                onPressed: () {
                                  context.go(VolunteerDetailsScreen.routeFromId(
                                      volunteerDetails[index].id));
                                },
                                type: volunteerDetails[index].type,
                                title: volunteerDetails[index].title,
                                vacancies: volunteerDetails[index].vacancies,
                                imageUrl: volunteerDetails[index].imageUrl,
                              );
                            },
                          );
                        } else {
                          return Center(
                              child:
                                  Text(AppLocalizations.of(context)!.noData));
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
