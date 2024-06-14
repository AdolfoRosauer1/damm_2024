import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

// @Riverpod(keepAlive: true)
// class Location extends _$Location {
//   @override
//   Future<GeoPoint?> build() async {
//     return _getUserLocation();
//   }
//
//   Future<GeoPoint?> _getUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return null;
//     }
//
//     permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.deniedForever) {
//       return null;
//     }
//     if (permission == LocationPermission.denied) {
//       return null;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     return GeoPoint(position.latitude, position.longitude);
//   }
// }
//
// void init(ProviderContainer container) {
//   container.read(locationProvider);
//   return;
// }

@Riverpod(keepAlive: true)
class UserLocation extends _$UserLocation {
  @override
  GeoPoint build() {
    return const GeoPoint(0, 0);
  }

  void set(GeoPoint toSet) {
    state = toSet;
  }
}

@Riverpod(keepAlive: true)
LocationController locationController(LocationControllerRef ref) {
  return LocationController(
    ref.watch(locationRepositoryProvider),
    ref.watch(userLocationProvider.notifier),
    ref.watch(userLocationProvider),
  );
}

@Riverpod(keepAlive: true)
LocationRepository locationRepository(LocationRepositoryRef ref) {
  return LocationRepository();
}

class LocationRepository {
  Future<void> getPermission() async {
    try {
      await Geolocator.requestPermission();
    } catch (e) {
      print('ERROR locationRepository.getPermission: $e');
    }
  }

  Future<GeoPoint?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    if (permission == LocationPermission.denied) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }
}

class LocationController {
  final LocationRepository _locationRepository;
  final UserLocation _locationNotifier;
  final GeoPoint _userLocation;

  LocationController(
      this._locationRepository, this._locationNotifier, this._userLocation);

  Future<void> updateUserLocation() async {
    await _locationRepository.getPermission();
    GeoPoint? toSet = await _locationRepository.getUserLocation();
    if (toSet != null && toSet != _userLocation) {
      _locationNotifier.set(toSet);
    }
  }
}

void init(ProviderContainer container) {
  container.read(userLocationProvider);
  container.read(locationRepositoryProvider);
  container.read(locationControllerProvider);
  return;
}
