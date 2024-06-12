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
  return ProfileRepository(ref.watch(firebaseFirestoreProvider), ref.watch(storageDataSourceProvider));
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
    print('initUSer: FirebaseUser = $user');
    if (user != null) {
      Volunteer? toSet = await getVolunteerById(user.uid);
      print('initUser: getVolunteerById=$toSet');
      if (toSet != null) {
        _userNotifier.set(toSet);
      }
    }
  }

  Future<Volunteer?> getVolunteerById(String id) async {
    return _repository.getVolunteerById(id);
  }

  Future<void> addFavoriteVolunteering(String opportunityId) async {
    if (_firebaseAuth.currentUser == null ) {
      return;
    }
    try{
      // get current user
      // Volunteer toSet = _currentUser;
      // // addFavorite
      // toSet.addFavoriteVolunteer(opportunityId);

      Volunteer toSet = Volunteer.fromVolunteer(_currentUser);
      toSet.addFavoriteVolunteer(opportunityId);
      // set notifier
      _userNotifier.set(toSet);

      // _currentUser.addFavoriteVolunteer(opportunityId);
      // store in Firestore async
      print('About to store in Firestore');
      // _repository.addFavoriteVolunteering(_currentUser.uid, opportunityId);
      _repository.setVolunteerFromJson(toSet.toJson());
      print('Stored in Firestore');
    }catch(e){
      print('Error in profileController.addFavoriteVolunteering: $e');
    }


    // await _repository.addFavoriteVolunteering(
    //     _firebaseAuth.currentUser!.uid, opportunityId);
    // Volunteer updatedUser =
    //     (await _repository.getVolunteerById(_firebaseAuth.currentUser!.uid))!;
    // _userNotifier.set(updatedUser);
  }

  Future<void> removeFavoriteVolunteering(String opportunityId) async {
    if (_firebaseAuth.currentUser == null) {
      return;
    }

    try{
      // get current user
      // Volunteer toSet = _currentUser;
      // // addFavorite
      // print('original User: $_currentUser');
      // toSet.removeFavoriteVolunteer(opportunityId);
      // // set notifier
      // print('toSet: $toSet');
      Volunteer toSet = Volunteer.fromVolunteer(_currentUser);
      toSet.removeFavoriteVolunteer(opportunityId);
      _userNotifier.set(toSet);

      // _currentUser.removeFavoriteVolunteer(opportunityId);
      // store in Firestore async
      // _repository.removeFavoriteVolunteering(_currentUser.uid, opportunityId);
      _repository.setVolunteerFromJson(toSet.toJson());
    }catch(e){
      print('Error in profileController.removeFavoriteVolunteering: $e');
    }



    // await _repository.removeFavoriteVolunteering(
    //     _firebaseAuth.currentUser!.uid, opportunityId);
    // Volunteer updatedUser =
    //     (await _repository.getVolunteerById(_firebaseAuth.currentUser!.uid))!;
    // _userNotifier.set(updatedUser);
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
  final StorageDataSource _storageDataSource;
  final AnalyticsService _analyticsService = AnalyticsService();

  ProfileRepository(this._firestore, this._storageDataSource);

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
    return null;
  }

  Future<void> setVolunteerFromJson(Map<String, dynamic> data)async {
    print('About to set VolunteerFromJson in Firestore');
    await _firestore.collection('volunteer').doc(data['uid']).set(data).onError((e, _) => print('Error setting Volunteer from Json: $e'));
  }

  Future<Volunteer?> editVolunteer(
      Volunteer user, Map<String, dynamic> data) async {
    try {
      // CREATE A USER DOCUMENT IN FIREBASE
      // SET riverpod volunteer
      Map<String,dynamic> cuJson = user.toJson();
      cuJson['profileImageURL'] = data['profilePicture'];
      cuJson['email'] = data['email'];
      cuJson['phoneNumber'] = data['phoneNumber'];
      cuJson['gender'] = data['gender'];
      cuJson['dateOfBirth'] = data['dateOfBirth'];


      if (cuJson['profileImageURL'] != user.profileImageURL) {
        cuJson['profileImageURL'] =
            await _storageDataSource.uploadPFP(cuJson['profileImageURL']);
      }

      cuJson['fcmToken'] = await FirebaseMessaging.instance.getToken();
      print("TOKEN = ${cuJson['fcmToken']}");

      await _firestore
          .collection('volunteer')
          .doc(user.uid)
          .set(cuJson)
          .onError((e, _) => print("Error writing document: $e"));
      
      _analyticsService.logCompleteVolunteerProfile(user.uid);

      // Persist in Riverpod
      print('editProfile: about to createVolunteer from JSON: $cuJson');
      return Volunteer.fromJson(cuJson);
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
