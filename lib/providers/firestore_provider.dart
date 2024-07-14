import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/services/analytics_service.dart';
import 'package:damm_2024/utils/maps_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_provider.g.dart';

@Riverpod(keepAlive: true)
class VolunteerDetailsProvider extends _$VolunteerDetailsProvider {
  @override
  Stream<VolunteerDetails?> build(String id) async* {
    final firestoreDataSource = ref.watch(firestoreDataSourceProvider);
    await for (final snapshot in firestoreDataSource.getVolunteerByIdSnapshot(id)) {
      if (snapshot.exists) {
        var data = snapshot.data()!;
        var imageUrl = await FirebaseStorage.instance
            .ref()
            .child(data['imagePath'])
            .getDownloadURL();
        data['id'] = snapshot.id;
        data['imageUrl'] = imageUrl;
        Timestamp timestamp = data['createdAt'];
        data['createdAt'] = timestamp.toDate();
        data['pendingApplicants'] ??= [];
        data['confirmedApplicants'] ??= [];
        data['remainingVacancies'] ??= data['vacancies'] -
            List<String>.from(data['confirmedApplicants'] as List).length;
        yield VolunteerDetails.fromJson(data);
      } else {
        yield null;
      }
    }
  }
}

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
    ref.watch(firestoreRepositoryProvider),
    ref.watch(currentUserProvider),
    ref.watch(currentUserProvider.notifier),
  );
}

// Controller class to handle higher-level business logic
class FirestoreController {
  final FirestoreRepository _firestoreRepository;
  final Volunteer user;
  final CurrentUser notifier;

  FirestoreController(this._firestoreRepository, this.user, this.notifier);

  Future<bool> areVolunteersAvailable() async {
    return _firestoreRepository.areVolunteersAvailable();
  }

  void openLocationInMap(GeoPoint location) {
    openMap(location.latitude, location.longitude);
  }

  // Method to apply to a volunteer opportunity
  Future<void> applyToOpportunity(String oppId) async {
    try {
      if (user.currentApplication == null) {
        user.applyToVolunteer(oppId);
        await _firestoreRepository.applyToOpportunity(user.uid, oppId);
        notifier.set(Volunteer.fromVolunteer(user));
       
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  // Method to un-apply from a volunteer opportunity
  Future<void> unApplyToOpportunity(String oppId) async {
    try {
      if (user.currentApplication != null) {
        user.unApplyToVolunteer();
        await _firestoreRepository.unApplyToOpportunity(user.uid, oppId);
        notifier.set(Volunteer.fromVolunteer(user));
      
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  Future<void> cancelOpportunity(String oppId) async {
    try {
      if (user.currentVolunteering != null) {
        user.currentVolunteering = null;
        await _firestoreRepository.cancelOpportunity(user.uid, oppId);
        notifier.set(Volunteer.fromVolunteer(user));
      }
    } catch (e,stackTrace){
      FirebaseCrashlytics.instance.recordError(e,stackTrace);
    }
  }

  // Method to get a volunteer's details by their ID
  Future<VolunteerDetails?> getVolunteerById(String id) async {
    try {
      var result = await _firestoreRepository.getVolunteerById(id);
    
      return result;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return null;
    }
  }

  // Method to get a list of volunteers, optionally filtered by a query or user position
  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, GeoPoint? userPosition}) async {
    try {
      var result = await _firestoreRepository.getVolunteers(
          query: query, userPosition: userPosition);
      return result;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return [];
    }
  }
}

// Repository class to handle communication with the Firestore data source
class FirestoreRepository {
  final FirestoreDataSource _dataSource;
  final AnalyticsService _analyticsService = AnalyticsService();

  FirestoreRepository(this._dataSource);

  Future<bool> areVolunteersAvailable() async {
    return _dataSource.areVolunteersAvailable();
  }

  // Method to apply a user to a volunteer opportunity
  Future<void> applyToOpportunity(String userId, String oppId) async {
    try {
      VolunteerDetails? opportunity = await _dataSource.getVolunteerById(oppId);
      if (opportunity != null) {
        if (!opportunity.pendingApplicants.contains(userId)) {
          opportunity.pendingApplicants.add(userId);
          await _dataSource.updateVolunteerById(opportunity);
          _analyticsService.logApplyToVolunteer(oppId, userId);
        
        }
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
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
          _analyticsService.logUnapplyToVolunteer(oppId, userId);

        }
      }
    } catch (e, stacTrace) {
      FirebaseCrashlytics.instance.recordError(e, stacTrace);
    }
  }

  Future<void> cancelOpportunity(String userId, String oppId) async {
    try {
      VolunteerDetails? opportunity = await _dataSource.getVolunteerById(oppId);
      if (opportunity != null) {
        if (opportunity.isUserConfirmed(userId)) {
          opportunity.confirmedApplicants.remove(userId);
          await _dataSource.updateVolunteerById(opportunity);
        
        }
      }
    } catch (e,stackTrace) {
      FirebaseCrashlytics.instance.recordError(e,stackTrace);
    }
  }

  // Method to get a list of volunteers from the data source
  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, GeoPoint? userPosition}) async {
    try {
      var result = await _dataSource.getVolunteers(
          query: query, userPosition: userPosition);

      return result;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return [];
    }
  }

  // Method to get a volunteer's details by their ID
  Future<VolunteerDetails?> getVolunteerById(String id) async {
    try {
      var result = await _dataSource.getVolunteerById(id);

      return result;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return null;
    }
  }
}

// Data source class to handle direct communication with Firebase services
class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreDataSource(this._firestore, this._storage);

  Future<bool> areVolunteersAvailable() async {
    QuerySnapshot snapshot =
        await _firestore.collection('volunteerOpportunities').get();
    return snapshot.docs.isNotEmpty;
  }

  // Method to get a list of volunteers from Firestore, optionally filtered by a query or user position
  Future<List<VolunteerDetails>> getVolunteers(
      {String? query, GeoPoint? userPosition}) async {
    try {
      List<VolunteerDetails> volunteers = [];
      QuerySnapshot snapshot =
          await _firestore.collection('volunteerOpportunities').get();


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
          data['pendingApplicants'] ??= [];
          data['confirmedApplicants'] ??= [];
          data['remainingVacancies'] ??= data['vacancies'] -
              List<String>.from(data['confirmedApplicants'] as List).length;
          data['cost'] ??= 0.0;

          if (query != null && query.isNotEmpty) {
            if (data['title'].toLowerCase().contains(query.toLowerCase()) ||
                data['mission'].toLowerCase().contains(query.toLowerCase()) ||
                data['details'].toLowerCase().contains(query.toLowerCase())) {
              volunteers.add(VolunteerDetails.fromJson(data));
            }
          } else {
            volunteers.add(VolunteerDetails.fromJson(data));
          }
        } catch (e, stackTrace) {
          FirebaseCrashlytics.instance.recordError(e, stackTrace);

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

      return volunteers;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
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

    } catch (e, stacTrace) {
      FirebaseCrashlytics.instance.recordError(e, stacTrace);
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
        data['pendingApplicants'] ??= [];
        data['confirmedApplicants'] ??= [];
        data['remainingVacancies'] ??= data['vacancies'] -
            List<String>.from(data['confirmedApplicants'] as List).length;
        data['cost'] ??= 0.0;


        return VolunteerDetails.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
     
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVolunteersSnapshot() {
    return _firestore.collection('volunteerOpportunities').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getVolunteerByIdSnapshot(
      String id) {
    return _firestore.collection('volunteerOpportunities').doc(id).snapshots();
  }
}
