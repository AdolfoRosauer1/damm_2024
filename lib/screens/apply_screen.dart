import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/providers/location_provider.dart';
import 'package:damm_2024/providers/remote_config_provider.dart';
import 'package:damm_2024/screens/map_screen.dart';
import 'package:damm_2024/screens/volunteer_details_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/current_volunteer.dart';
import 'package:damm_2024/widgets/cells/cards/no_volunteers_card.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  static const route = "/apply";

  const ApplyScreen({super.key});

  @override
  ApplyScreenState createState() => ApplyScreenState();
}

class ApplyScreenState extends ConsumerState<ApplyScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isMapEnabled = false;

  late Future<List<VolunteerDetails>> _volunteers;
  late Future<bool> _areVolunteersAvailable;
  GeoPoint? _userPosition;
  Timer? _debounce;

  void _askForNotificationPermission() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );
  }

 

  @override
  void initState() {
    super.initState();
    _askForNotificationPermission();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreController = ref.read(firestoreControllerProvider);
    final userLocation = ref.watch(userLocationProvider);

    final mapEnabledAsyncValue = ref.watch(mapEnabledProvider);

    mapEnabledAsyncValue.whenData((enabled) {
      _isMapEnabled = enabled;
    });

    final locationController = ref.read(locationControllerProvider);
    locationController.updateUserLocation();

    void loadVolunteers() {
      setState(() {
        _volunteers = firestoreController.getVolunteers(
            query: _searchController.text, userPosition: _userPosition);
        _areVolunteersAvailable = firestoreController.areVolunteersAvailable();
      });
    }

    void onSearchChanged(){
      if(_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), loadVolunteers);
    }
    setState(() {
      _userPosition = userLocation;
    });
    _areVolunteersAvailable = firestoreController.areVolunteersAvailable();
    _volunteers = firestoreController.getVolunteers(
        query: _searchController.text, userPosition: _userPosition);
   

    return Container(
      decoration: const BoxDecoration(
        color: ProjectPalette.secondary7,
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
                onChanged: (_) => onSearchChanged(),
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
                      ? (_isMapEnabled
                      ? IconButton(
                    icon: ProjectIcons.mapFilledActivated,
                    onPressed: () {
                      context.go(MapScreen.route);
                    },
                  )
                      : null)
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
            Expanded(
              child: FutureBuilder<bool>(
                future: _areVolunteersAvailable,
                builder: (context, availabilitySnapshot) {
                  if (availabilitySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (availabilitySnapshot.hasError) {
                    return Center(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Ensure alignment
                        children: [
                          Text(
                            AppLocalizations.of(context)!.volunteerings,
                            style: ProjectFonts.headline1,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.error}: ${availabilitySnapshot.error}',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    );
                  } else if (availabilitySnapshot.hasData &&
                      !availabilitySnapshot.data!) {
                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Ensure alignment
                      children: [
                        Text(
                          AppLocalizations.of(context)!.volunteerings,
                          style: ProjectFonts.headline1,
                          textAlign: TextAlign.left,
                        ),
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
                              '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
                              textAlign: TextAlign.left,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          List<VolunteerDetails> volunteerDetails =
                              snapshot.data!;
                          if (volunteerDetails.isEmpty) {
                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Ensure alignment
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.volunteerings,
                                  style: ProjectFonts.headline1,
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 16),
                                NoVolunteersCard(
                                  size: NoVolunteersCardSize.medium,
                                  message: AppLocalizations.of(context)!
                                      .noVolunteersSearch,
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Ensure alignment
                            children: [
                              CurrentVolunteerSection(
                                  detailsList: volunteerDetails),
                              Text(
                                AppLocalizations.of(context)!.volunteerings,
                                style: ProjectFonts.headline1,
                                textAlign: TextAlign.left,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(top: 24),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 24),
                                  itemCount: volunteerDetails.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        context.push(
                                            VolunteerDetailsScreen.routeFromId(
                                                volunteerDetails[index].id));
                                      },
                                      child: VolunteeringCard(
                                        id: volunteerDetails[index].id,
                                        onPressedLocation: () {
                                          firestoreController.openLocationInMap(
                                              volunteerDetails[index].location);
                                        },
                                        type: volunteerDetails[index].type,
                                        title: volunteerDetails[index].title,
                                        vacancies: volunteerDetails[index]
                                            .remainingVacancies,
                                        imageUrl:
                                            volunteerDetails[index].imageUrl,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.noData,
                              textAlign: TextAlign.left,
                            ),
                          );
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
