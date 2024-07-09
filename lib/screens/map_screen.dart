import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/providers/location_provider.dart';
import 'package:damm_2024/screens/apply_screen.dart';
import 'package:damm_2024/screens/volunteer_details_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/no_volunteers_card.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapScreen extends ConsumerStatefulWidget {
  static const route = "/map";

  static String getCompleteRoute() => "${ApplyScreen.route}/$route";

  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  List<VolunteerDetails> _volunteers = [];
  bool _areVolunteersAvailable = false;
  bool _isLoading = true;
  String? _errorMessage;
  VolunteerDetails? _currentVolunteerDetails;
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  CameraPosition? _initialPosition;
  GeoPoint? _userPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   final userLocation = ref.watch(userLocationProvider);

    final locationController = ref.read(locationControllerProvider);
    locationController.updateUserLocation();

    setState(() {
      _userPosition = userLocation;
    });  
    _loadVolunteers();

    
  }

  Future<void> _loadVolunteers() async {
    final firestoreController = ref.read(firestoreControllerProvider);
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final volunteers = await firestoreController.getVolunteers(query: _searchController.text,
                                                    userPosition: _userPosition); 
      final areAvailable = await firestoreController.areVolunteersAvailable();
      setState(() {
        _volunteers = volunteers;
        _areVolunteersAvailable = areAvailable;
        _currentVolunteerDetails = volunteers.isNotEmpty ? volunteers.first : null;
        _initialPosition = _currentVolunteerDetails != null
            ? CameraPosition(
                target: LatLng(_currentVolunteerDetails!.location.latitude, _currentVolunteerDetails!.location.longitude),
                zoom: 15.0,
              )
            : CameraPosition(
                target: _userPosition != null ? LatLng(_userPosition!.latitude,_userPosition!.longitude) 
                 : const LatLng(0, 0), 
                zoom: 15.0,
              );
        _isLoading = false;
        _markers = volunteers.map((volunteer) => Marker(
          markerId: MarkerId(volunteer.id),
          position: LatLng(volunteer.location.latitude, volunteer.location.longitude),
          infoWindow: InfoWindow(
            title: volunteer.title,
            snippet: volunteer.address,
          ),
        )).toSet();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCarouselPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentVolunteerDetails = _volunteers[index];
    });
    final newPosition = CameraPosition(
      target: LatLng(_currentVolunteerDetails!.location.latitude, _currentVolunteerDetails!.location.longitude),
      zoom: 15.0,
    );
    _mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  @override
  Widget build(BuildContext context) {


    
    void moveCamera({bool moveToUserLocation = false}){
      if (moveToUserLocation){
        if (_userPosition != null){
          _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(_userPosition!.latitude, _userPosition!.longitude)));
        }
      }
      else if (_initialPosition != null ){

        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          _initialPosition!
        ));
      }
    }
    final fireStoreController = ref.read(firestoreControllerProvider);
    return Stack(
      children: [
        _initialPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition!,
                markers: _markers,
              ),
        Positioned(
          top: 24,
          left: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: ProjectPalette.neutral1,
              borderRadius: BorderRadius.circular(2),
              boxShadow: ProjectShadows.shadow1,
            ),
            child: TextField(
              controller: _searchController,
          
              onSubmitted: (_) async => {
                await _loadVolunteers(),
                moveCamera()

              },
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
                    ? IconButton(
                      icon: ProjectIcons.listFilledActivated,
                      onPressed: () {
                        context.go(ApplyScreen.route);
                      },
                    )
                    : IconButton(
                        icon: ProjectIcons.closeFilledEnabled,
                        onPressed: () async {
                          _searchController.clear();
                          await _loadVolunteers();
                          moveCamera();
                        },
                      ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: ProjectPalette.primary2,
                    boxShadow: ProjectShadows.shadow3,
                  ),
                  child: IconButton(
                    icon: ProjectIcons.nearMeFilledActivated,
                    onPressed: () => moveCamera(moveToUserLocation: true),
                    ),
                )
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            '${AppLocalizations.of(context)!.error}: $_errorMessage',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : !_areVolunteersAvailable
                          ? Padding(
                            padding: const EdgeInsets.only(top:16),
                            child: NoVolunteersCard(
                                size: NoVolunteersCardSize.small,
                                message: AppLocalizations.of(context)!.noVolunteers,
                              ),
                          )
                          : _volunteers.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.only(top:40),
                                child: NoVolunteersCard(
                                    size: NoVolunteersCardSize.medium,
                                    message: AppLocalizations.of(context)!.noVolunteersSearch,
                                  ),
                              )
                              : Padding(
                                padding: const EdgeInsets.only(top:16),
                                child: CarouselSlider.builder(
                                    options: CarouselOptions(
                                      onPageChanged: _onCarouselPageChanged,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      height: 138 + 97,
                                    ),
                                    itemCount: _volunteers.length,
                                    itemBuilder: (context, index, realIdx) {
                                      final volunteer = _volunteers[index];
                                      return VolunteeringCard(
                                        id: volunteer.id,
                                        onPressedLocation: () {
                                          fireStoreController.openLocationInMap(volunteer.location);
                                        },
                                        onPressed: () {
                                          context.go(VolunteerDetailsScreen.routeFromId(volunteer.id));
                                        },
                                        type: volunteer.type,
                                        title: volunteer.title,
                                        vacancies: volunteer.remainingVacancies,
                                        imageUrl: volunteer.imageUrl,
                                      );
                                    },
                                  ),
                              ),
            ],
          ),
        ),
       
      ],
    );
  }
}
