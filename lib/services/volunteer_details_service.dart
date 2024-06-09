import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/utils/maps_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class VolunteerDetailsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void openLocationInMap(GeoPoint location) {
    openMap(location.latitude, location.longitude);
  }

  Future<bool> areVolunteersAvailable() async {
    QuerySnapshot snapshot =
        await _firestore.collection('volunteerOpportunities').get();
    return snapshot.docs.isNotEmpty;
  }

  // Method to get a list of volunteers from Firestore, optionally filtered by a query or user position
  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, Position? userPosition}) async {
    try {
      List<VolunteerDetails> volunteers = [];
      QuerySnapshot snapshot =
          await _firestore.collection('volunteerOpportunities').get();
      print(
          'FirestoreDataSource.getVolunteers: Fetched volunteer opportunities from Firestore');

      for (var element in snapshot.docs) {
        try {
          var data = element.data() as Map<String, dynamic>;
          var imageUrl =
              await _storage.ref().child(data['imagePath']).getDownloadURL();
          data['id'] = element.id;
          data['imageUrl'] = imageUrl;
          Timestamp timestamp = data['createdAt'];
          data['createdAt'] = timestamp.toDate();

          // Handle potential null fields
          data['pendingApplicants'] ??= [''];
          data['confirmedApplicants'] ??= [''];
          data['remainingVacancies'] ??= data['vacancies'] -
              List<String>.from(data['confirmedApplicants'] as List).length;

          if (query != null && query.isNotEmpty) {
            if (data['title'].toLowerCase().contains(query.toLowerCase()) ||
                data['mission'].toLowerCase().contains(query.toLowerCase()) ||
                data['details'].toLowerCase().contains(query.toLowerCase())) {
              volunteers.add(VolunteerDetails.fromJson(data));
            }
          } else {
            volunteers.add(VolunteerDetails.fromJson(data));
          }
        } catch (e) {
          print(
              'Error in FirestoreDataSource.getVolunteers (processing document): $e');
        }
      }

      // Sort volunteers based on distance to user position or creation date
      if (userPosition != null) {
        volunteers.sort((a, b) {
          double distanceA = Geolocator.distanceBetween(
              userPosition.latitude,
              userPosition.longitude,
              a.location.latitude,
              a.location.longitude);
          double distanceB = Geolocator.distanceBetween(
              userPosition.latitude,
              userPosition.longitude,
              b.location.latitude,
              b.location.longitude);

          if (distanceA == distanceB) {
            return b.createdAt.compareTo(a.createdAt);
          }
          return distanceA.compareTo(distanceB);
        });
      } else {
        volunteers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      print(
          'FirestoreDataSource.getVolunteers: Sorted and filtered volunteer opportunities');
      return volunteers;
    } catch (e) {
      print('Error in FirestoreDataSource.getVolunteers: $e');
      return [];
    }
  }

  // Method to update a volunteer opportunity in Firestore
  Future<void> updateVolunteerById(VolunteerDetails volunteer) async {
    try {
      Map<String, dynamic> data = volunteer.toJson();
      await _firestore
          .collection('volunteerOpportunities')
          .doc(volunteer.id)
          .update(data);
      print(
          'FirestoreDataSource.updateVolunteerById: Updated volunteer opportunity: ${volunteer.id}');
    } catch (e) {
      print('Error in FirestoreDataSource.updateVolunteerById: $e');
    }
  }

  // Method to get a volunteer's details by their ID from Firestore
  Future<VolunteerDetails?> getVolunteerById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('volunteerOpportunities').doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        var imageUrl =
            await _storage.ref().child(data['imagePath']).getDownloadURL();
        data['id'] = id;
        data['imageUrl'] = imageUrl;
        Timestamp timestamp = data['createdAt'];
        data['createdAt'] = timestamp.toDate();

        // Handle potential null fields
        data['pendingApplicants'] ??= [''];
        data['confirmedApplicants'] ??= [''];
        data['remainingVacancies'] ??= data['vacancies'] -
            List<String>.from(data['confirmedApplicants'] as List).length;

        print(
            'FirestoreDataSource.getVolunteerById: Fetched volunteer details for ID: $id');
        return VolunteerDetails.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error in FirestoreDataSource.getVolunteerById: $e");
      return null;
    }
  }
}
