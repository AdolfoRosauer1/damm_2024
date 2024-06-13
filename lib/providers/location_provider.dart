import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@Riverpod(keepAlive: true)
class Location extends _$Location {
  @override
  Future<GeoPoint?> build() async {
    return _getUserLocation();
  }

  Future<GeoPoint?> _getUserLocation() async {
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
 

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }


}
void init(ProviderContainer container) {
  container.read(locationProvider);
  return;
}