import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volunteer_provider.g.dart';

// CurrentUser Notifier:
// Notifier allows for a change of state method and default value
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Volunteer build() {
    return Volunteer.empty();
  }

  void set(Volunteer data) {
    state = data;
  }
}

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) {
  return FirebaseStorage.instance;
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref.watch(firebaseFirestoreProvider),
      ref.watch(firebaseStorageProvider), ref.watch(storageDataSourceProvider));
}

@Riverpod(keepAlive: true)
ProfileController profileController(ProfileControllerRef ref) {
  return ProfileController(
      ref.watch(profileRepositoryProvider),
      ref.watch(currentUserProvider.notifier),
      ref.watch(currentUserProvider),
      ref.watch(firebaseAuthenticationProvider));
}

@Riverpod(keepAlive: true)
StorageDataSource storageDataSource(StorageDataSourceRef ref) {
  return StorageDataSource(ref.watch(firebaseStorageProvider),
      ref.watch(firebaseAuthenticationProvider));
}

class ProfileController {
  final ProfileRepository _repository;
  final CurrentUser _userNotifier;
  final Volunteer _currentUser;
  final FirebaseAuth _firebaseAuth;

  ProfileController(this._repository, this._userNotifier, this._currentUser,
      this._firebaseAuth);

  Future<void> finishSetup(Map<String, dynamic> data) async {
    User? user = _firebaseAuth.currentUser;
    print('Starting finishSetup!: $user, $data');
    try {
      if (user != null) {
        Volunteer? toSet = await _repository.editVolunteer(_currentUser, data);
        if (toSet != null) {
          _userNotifier.set(toSet);
        }

      }
    } catch (e) {
      print('Error in ProfileController.finishSetup: $e');
    }
  }

  void initUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      Volunteer? toSet = await getVolunteerById(user.uid);
      if (toSet != null) {
        _userNotifier.set(toSet);
      }
    }
  }

  Future<Volunteer?> getVolunteerById(String id) async {
    return _repository.getVolunteerById(id);
  }

  Future<void> addFavoriteVolunteering(String opportunityId) async {
    if (_firebaseAuth.currentUser == null) {
      return;
    }
    await _repository.addFavoriteVolunteering(
        _firebaseAuth.currentUser!.uid, opportunityId);
    Volunteer updatedUser =
        (await _repository.getVolunteerById(_firebaseAuth.currentUser!.uid))!;
    _userNotifier.set(updatedUser);
  }

  Future<void> removeFavoriteVolunteering(String opportunityId) async {
    if (_firebaseAuth.currentUser == null) {
      return;
    }
    await _repository.removeFavoriteVolunteering(
        _firebaseAuth.currentUser!.uid, opportunityId);
    Volunteer updatedUser =
        (await _repository.getVolunteerById(_firebaseAuth.currentUser!.uid))!;
    _userNotifier.set(updatedUser);
  }

  Future<User?> registerVolunteer(String name, String lastName) async {
    _firebaseAuth.currentUser?.reload();
    final user = _firebaseAuth.currentUser;
    print('registerVolunteer: user = $user');
    if (user != null) {
      final json = {
        "firstName": name,
        "lastName": lastName,
        "email": user.email ?? '',
        "uid": user.uid,
        "gender": '',
        "profileImageURL": '',
        "dateOfBirth": null,
        "phoneNumber": '',
        "favoriteVolunteerings": [],
      };
      try {
        Volunteer? toSet = await _repository.createVolunteerFromJSON(json);
        if (toSet != null) {
          _userNotifier.set(toSet);
          print('Set volunteer: $_currentUser');
        }
      } catch (e) {
        print('Error in profileController.registerVolunteer: $e');
      }
      return _firebaseAuth.currentUser;
    }
    return null;
  }
}

class StorageDataSource {
  final FirebaseStorage _storage;
  final FirebaseAuth _firebaseAuth;

  StorageDataSource(this._storage, this._firebaseAuth);

  // Upload PFP to FirestoreStorage. Returns URL
  Future<String?> uploadPFP(String filePath) async {
    User? user = _firebaseAuth.currentUser;
    print('Uploading PFP!');
    if (user != null) {
      final rootRef = _storage.ref();
      String uid = user.uid;
      final imageRef = rootRef.child('pfps/$uid');

      File file = File(filePath);

      try {
        await imageRef.putFile(file);
        print('PFP uploaded correctly!');
        return imageRef.getDownloadURL();
      } catch (e, stackTrace) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        print('Error uploading PFP: $e');
        return null;
      }
    }
    return null;
  }
}

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final StorageDataSource _storageDataSource;
  final AnalyticsService _analyticsService = AnalyticsService();

  ProfileRepository(this._firestore, this._storage, this._storageDataSource);

  Future<Volunteer?> createVolunteerFromJSON(Map<String, dynamic> data) async {
    try {
      print('About to createVolunteer from JSON: $data');
      await _firestore
          .collection('volunteer')
          .doc(data['uid'])
          .set(data)
          .onError((e, _) => print("Error writing document: $e"));
      return Volunteer.fromJson(data);
    } catch (e) {
      print('Error in ProfileRepository.createVolunteerFromJSON: $e');
    }
  }

  Future<Volunteer?> editVolunteer(
      Volunteer user, Map<String, dynamic> data) async {
    try {
      // CREATE A USER DOCUMENT IN FIREBASE

      // Create a mutable copy of the data map
      Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
      mutableData['profileImageURL'] = mutableData['profilePicture'];
      mutableData.remove('profilePicture');
      // SET riverpod volunteer

      mutableData['firstName'] = user.firstName;
      mutableData['lastName'] = user.lastName;

      if (mutableData['profileImageURL'] != user.profileImageURL) {
        mutableData['profileImageURL'] =
            await _storageDataSource.uploadPFP(mutableData['profileImageURL']);
      }

      mutableData['uid'] = user.uid;

      mutableData['fcmToken'] = await FirebaseMessaging.instance.getToken();
      mutableData['favoriteVolunteerings'] = [];
      print("TOKEN = ${mutableData['fcmToken']}");

      await _firestore
          .collection('volunteer')
          .doc(user.uid)
          .set(mutableData)
          .onError((e, _) => print("Error writing document: $e"));
      
      _analyticsService.logCompleteVolunteerProfile(user.uid);

      // Persist in Riverpod
      print('editProfile: about to createVolunteer from JSON: $mutableData');
      return Volunteer.fromJson(mutableData);
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      print('Error finishing setup: $e');
    }
    return null;
  }

  Future<void> addFavoriteVolunteering(
      String userId, String opportunityId) async {
    try {
      Volunteer? user = await getVolunteerById(userId);
      if (user != null) {
        user.favoriteVolunteerings.add(opportunityId);
        await _firestore
            .collection('volunteer')
            .doc(userId)
            .update({'favoriteVolunteerings': user.favoriteVolunteerings});
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      print('Error adding favorite volunteering: $e');
    }
  }

  Future<Volunteer?> getVolunteerById(String id) async {
    try {
      print('Fetching Volunteer by ID: $id');
      DocumentSnapshot doc =
          await _firestore.collection('volunteer').doc(id).get();
      print('Fetched Firestore Document: $doc');
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        Timestamp ts = data['dateOfBirth'] as Timestamp;
        data['dateOfBirth'] = ts.toDate();
        data['favoriteVolunteerings'] ??= [];
        return Volunteer.fromJson(data);
      }
      return null;
    } catch (e, stackTrace) {
      print('Error getting user by id: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return null;
    }
  }

  Future<void> removeFavoriteVolunteering(
      String uid, String opportunityId) async {
    try {
      Volunteer? user = await getVolunteerById(uid);
      if (user != null) {
        if (user.favoriteVolunteerings.contains(opportunityId)) {
          user.favoriteVolunteerings.remove(opportunityId);
          await _firestore
              .collection('volunteer')
              .doc(uid)
              .update({'favoriteVolunteerings': user.favoriteVolunteerings});
        }
      }
    } catch (e, stackTrace) {
      print('Error removing favorite volunteering: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }
}

// static method for Provider initialization
Future<void> initializeProvider(ProviderContainer container) async {
  ProfileController controller = container.read(profileControllerProvider);

  controller.initUser();

  return;
}

//
// Tenes:
// - controller: invoca metodo de un repository
// - repository: tiene los metodos que invocas con la logica de negocio q haga falta
// - datasource: accesos a data externa, expone metodos que puede consumir el repository
