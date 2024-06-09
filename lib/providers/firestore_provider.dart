import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_provider.g.dart';

@Riverpod(keepAlive: true)
FirestoreDataSource firestoreDataSource(FirestoreDataSourceRef ref) {
  return FirestoreDataSource(
      ref.watch(firebaseFirestoreProvider), ref.watch(firebaseStorageProvider));
}

@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(FirestoreRepositoryRef ref) {
  return FirestoreRepository(ref.watch(firestoreDataSourceProvider));
}

@Riverpod(keepAlive: true)
FirestoreController firestoreController(FirestoreControllerRef ref) {
  return FirestoreController(
      ref.watch(firestoreRepositoryProvider), ref.watch(currentUserProvider));
}

// Controller class to handle higher-level business logic
class FirestoreController {
  final FirestoreRepository _firestoreRepository;
  final Volunteer user;

  FirestoreController(this._firestoreRepository, this.user);

  // Method to apply to a volunteer opportunity
  Future<void> applyToOpportunity(String oppId) async {
    try {
      await _firestoreRepository.applyToOpportunity(user.uid, oppId);
      print(
          'FirestoreController.applyToOpportunity: Finished applying to opportunity: $oppId');
    } catch (e) {
      print('Error in FirestoreController.applyToOpportunity: $e');
    }
  }

  // Method to un-apply from a volunteer opportunity
  Future<void> unApplyToOpportunity(String oppId) async {
    try {
      await _firestoreRepository.unApplyToOpportunity(user.uid, oppId);
      print(
          'FirestoreController.unApplyToOpportunity: Finished un-applying from opportunity: $oppId');
    } catch (e) {
      print('Error in FirestoreController.unApplyToOpportunity: $e');
    }
  }

  // Method to get a volunteer's details by their ID
  Future<VolunteerDetails?> getVolunteerById(String id) async {
    try {
      var result = await _firestoreRepository.getVolunteerById(id);
      print(
          'FirestoreController.getVolunteerById: Finished getting volunteer details for ID: $id');
      return result;
    } catch (e) {
      print('Error in FirestoreController.getVolunteerById: $e');
      return null;
    }
  }

  // Method to get a list of volunteers, optionally filtered by a query or user position
  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, Position? userPosition}) async {
    try {
      var result = await _firestoreRepository.getVolunteers(
          query: query, userPosition: userPosition);
      print('FirestoreController.getVolunteers: Finished getting volunteers');
      return result;
    } catch (e) {
      print('Error in FirestoreController.getVolunteers: $e');
      return [];
    }
  }
}

// Repository class to handle communication with the Firestore data source
class FirestoreRepository {
  final FirestoreDataSource _dataSource;

  FirestoreRepository(this._dataSource);

  // Method to apply a user to a volunteer opportunity
  Future<void> applyToOpportunity(String userId, String oppId) async {
    try {
      VolunteerDetails? opportunity = await _dataSource.getVolunteerById(oppId);
      if (opportunity != null) {
        if (!opportunity.pendingApplicants.contains(userId)) {
          opportunity.pendingApplicants.add(userId);
          await _dataSource.updateVolunteerById(opportunity);
          print(
              'FirestoreRepository.applyToOpportunity: User $userId applied to opportunity $oppId');
        }
      }
    } catch (e) {
      print('Error in FirestoreRepository.applyToOpportunity: $e');
    }
  }

  // Method to un-apply a user from a volunteer opportunity
  Future<void> unApplyToOpportunity(String userId, String oppId) async {
    try {
      VolunteerDetails? opportunity = await _dataSource.getVolunteerById(oppId);
      if (opportunity != null) {
        if (opportunity.pendingApplicants.contains(userId)) {
          opportunity.pendingApplicants.remove(userId);
          await _dataSource.updateVolunteerById(opportunity);
          print(
              'FirestoreRepository.unApplyToOpportunity: User $userId un-applied from opportunity $oppId');
        }
      }
    } catch (e) {
      print('Error in FirestoreRepository.unApplyToOpportunity: $e');
    }
  }

  // Method to get a list of volunteers from the data source
  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, Position? userPosition}) async {
    try {
      var result = await _dataSource.getVolunteers(
          query: query, userPosition: userPosition);
      print(
          'FirestoreRepository.getVolunteers: Fetched volunteers from data source');
      return result;
    } catch (e) {
      print('Error in FirestoreRepository.getVolunteers: $e');
      return [];
    }
  }

  // Method to get a volunteer's details by their ID
  Future<VolunteerDetails?> getVolunteerById(String id) async {
    try {
      var result = await _dataSource.getVolunteerById(id);
      print(
          'FirestoreRepository.getVolunteerById: Fetched volunteer details for ID: $id');
      return result;
    } catch (e) {
      print('Error in FirestoreRepository.getVolunteerById: $e');
      return null;
    }
  }
}

// Data source class to handle direct communication with Firebase services
class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreDataSource(this._firestore, this._storage);

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
