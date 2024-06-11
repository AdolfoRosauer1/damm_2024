// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'2e7f8bd195d91c027c5155f34b719187867bc113';

/// See also [firebaseFirestore].
@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>.internal(
  firebaseFirestore,
  name: r'firebaseFirestoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseFirestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseFirestoreRef = ProviderRef<FirebaseFirestore>;
String _$firebaseStorageHash() => r'ddec157566e3f96dac39d44de2cd99f9d71f9b54';

/// See also [firebaseStorage].
@ProviderFor(firebaseStorage)
final firebaseStorageProvider = Provider<FirebaseStorage>.internal(
  firebaseStorage,
  name: r'firebaseStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseStorageRef = ProviderRef<FirebaseStorage>;
String _$profileRepositoryHash() => r'8b4158ec48f73c3bac2c4c4541a80a32225b5e22';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider = Provider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileRepositoryRef = ProviderRef<ProfileRepository>;
String _$profileControllerHash() => r'8c905cfc46053d95d62909ca102b42321d389b05';

/// See also [profileController].
@ProviderFor(profileController)
final profileControllerProvider = Provider<ProfileController>.internal(
  profileController,
  name: r'profileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileControllerRef = ProviderRef<ProfileController>;
String _$storageDataSourceHash() => r'f1a03683f42a234b2360543cc7530b6ac262478e';

/// See also [storageDataSource].
@ProviderFor(storageDataSource)
final storageDataSourceProvider = Provider<StorageDataSource>.internal(
  storageDataSource,
  name: r'storageDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StorageDataSourceRef = ProviderRef<StorageDataSource>;
String _$currentUserHash() => r'4c56bfebe92060645ba1a978caec320f2c863839';

/// See also [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider = NotifierProvider<CurrentUser, Volunteer>.internal(
  CurrentUser.new,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUser = Notifier<Volunteer>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
