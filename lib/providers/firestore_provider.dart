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

class FirestoreController {
  final FirestoreRepository _firestoreRepository;
  final Volunteer user;

  FirestoreController(this._firestoreRepository, this.user);

  Future<void> applyToOpportunity(String oppId) async {
    return _firestoreRepository.applyToOpportunity(user.uid, oppId);
  }

  Future<void> unApplyToOpportunity(String oppId) async {
    return _firestoreRepository.unApplyToOpportunity(user.uid, oppId);
  }
}

class FirestoreRepository {
  final FirestoreDataSource _dataSource;

  FirestoreRepository(this._dataSource);

  Future<void> applyToOpportunity(String userId, String oppId) async {
    try {
      VolunteerDetails? opportunity = await _dataSource.getVolunteerById(oppId);
      if (opportunity != null) {
        if (!opportunity.pendingApplicants.contains(userId)) {
          opportunity.pendingApplicants.add(userId);
          _dataSource.updateVolunteerById(opportunity);
        }
      }
    } catch (e) {
      print('Error applying to opportunity: $e');
    }
  }

  Future<void> unApplyToOpportunity(String userId, String oppId) async {
    try {
      VolunteerDetails? opportunity = await _dataSource.getVolunteerById(oppId);
      if (opportunity != null) {
        if (opportunity.pendingApplicants.contains(userId)) {
          opportunity.pendingApplicants.remove(userId);
          _dataSource.updateVolunteerById(opportunity);
        }
      }
    } catch (e) {
      print('Error un-applying to opportunity: $e');
    }
  }
}

class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreDataSource(this._firestore, this._storage);

  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, Position? userPosition}) async {
    List<VolunteerDetails> volunteers = [];
    QuerySnapshot snapshot =
        await _firestore.collection('volunteerOpportunities').get();
    for (var element in snapshot.docs) {
      var data = element.data() as Map<String, dynamic>;
      var imageUrl =
          await _storage.ref().child(data['imagePath']).getDownloadURL();
      data['id'] = element.id;
      data['imageUrl'] = imageUrl;
      Timestamp timestamp = data['createdAt'];
      data['createdAt'] = timestamp.toDate();

      if (data['pendingApplicants'] == null) {
        data['pendingApplicants'] = [''];
      }
      if (data['confirmedApplicants'] == null) {
        data['confirmedApplicants'] = [''];
      }

      if (query != null && query.isNotEmpty) {
        if (data['title'].toLowerCase().contains(query.toLowerCase()) ||
            data['mission'].toLowerCase().contains(query.toLowerCase()) ||
            data['details'].toLowerCase().contains(query.toLowerCase())) {
          volunteers.add(VolunteerDetails.fromJson(data));
        }
      } else {
        volunteers.add(VolunteerDetails.fromJson(data));
      }
    }

    if (userPosition != null) {
      volunteers.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(userPosition.latitude,
            userPosition.longitude, a.location.latitude, a.location.longitude);
        double distanceB = Geolocator.distanceBetween(userPosition.latitude,
            userPosition.longitude, b.location.latitude, b.location.longitude);

        if (distanceA == distanceB) {
          return b.createdAt.compareTo(a.createdAt);
        }
        return distanceA.compareTo(distanceB);
      });
    } else {
      volunteers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return volunteers;
  }

  Future<void> updateVolunteerById(VolunteerDetails volunteer) async {
    // Convert VolunteerDetails instance to a map
    Map<String, dynamic> data = volunteer.toJson();

    // Update the Firestore document with the given data
    await _firestore
        .collection('volunteerOpportunities')
        .doc(volunteer.id)
        .update(data);
  }

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
        return VolunteerDetails.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting volunteer details by id: $e");
      return null;
    }
  }
}
