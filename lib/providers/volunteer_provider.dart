import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _firebaseAuth;

  ProfileController(this._repository, this._userNotifier, this._firebaseAuth);

  Future<void> finishSetup(Map<String, dynamic> data) async {
    User? user = _firebaseAuth.currentUser;
    print('Starting finishSetup!: $user, $data');
    try {
      if (user != null) {
        Volunteer? toSet = await _repository.createVolunteer(user, data);
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
      } catch (e) {
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

  ProfileRepository(this._firestore, this._storage, this._storageDataSource);

  Future<Volunteer?> createVolunteer(
      User user, Map<String, dynamic> data) async {
    try {
      // CREATE A USER DOCUMENT IN FIREBASE

      // Create a mutable copy of the data map
      Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
      mutableData['profileImageURL'] = mutableData['profilePicture'];
      mutableData.remove('profilePicture');
      // SET riverpod volunteer

      List<String> nameParts = user.displayName.toString().split(' ');
      if (nameParts.length > 1) {
        mutableData['firstName'] = nameParts[0];
        mutableData['lastName'] = nameParts[1];
      } else {
        mutableData['firstName'] = nameParts[0];
        mutableData['lastName'] = '';
      }
      mutableData['profileImageURL'] =
          await _storageDataSource.uploadPFP(mutableData['profileImageURL']);
      mutableData['uid'] = user.uid;
      await _firestore
          .collection('volunteer')
          .doc(user.uid)
          .set(mutableData)
          .onError((e, _) => print("Error writing document: $e"));

      // Persist in Riverpod
      return Volunteer.fromJson(mutableData);
    } catch (e) {
      print('Error finishing setup: $e');
    }
    return null;
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
        return Volunteer.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
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
