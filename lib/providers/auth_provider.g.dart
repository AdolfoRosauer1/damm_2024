// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'5501d0caf55fffc1c500e8c9f56578f74daa51af';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authControllerHash() => r'c173490fee8fe67245d389c57047decd215ea26b';

/// See also [authController].
@ProviderFor(authController)
final authControllerProvider = Provider<AuthController>.internal(
  authController,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthControllerRef = ProviderRef<AuthController>;
String _$firebaseAuthenticationHash() =>
    r'73300f5f37d552c559e048079af14c6af3e6d653';

/// See also [FirebaseAuthentication].
@ProviderFor(FirebaseAuthentication)
final firebaseAuthenticationProvider =
    NotifierProvider<FirebaseAuthentication, FirebaseAuth>.internal(
  FirebaseAuthentication.new,
  name: r'firebaseAuthenticationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthenticationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FirebaseAuthentication = Notifier<FirebaseAuth>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
