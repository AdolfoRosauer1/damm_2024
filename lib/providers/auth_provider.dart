import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthenticationProvider));
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuthentication(FirebaseAuthenticationRef ref) {
  return FirebaseAuth.instance;
}

// @Riverpod(keepAlive: true)
// class FirebaseAuthentication extends _$FirebaseAuthentication {
//   @override
//   FirebaseAuth build() {
//     return FirebaseAuth.instance;
//   }
//
//   void reset() {
//     state = FirebaseAuth.instance;
//   }
// }

@Riverpod(keepAlive: true)
AuthController authController(AuthControllerRef ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(profileControllerProvider),
    ref.watch(currentUserProvider.notifier),
    ref.watch(currentUserProvider),
  );
}

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Iniciar sesión con email y contraseña
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Registrar usuario con email y contraseña
  Future<User?> registerUser(
      String email, String password, String name, String lastName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName('$name $lastName');
        await user.reload();
        user = _auth.currentUser;
      }
      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}

class AuthController {
  final AuthRepository _authRepo;
  final ProfileController _profileController;
  final CurrentUser _currentUserNotifier;
  final Volunteer _currentUser;
  AuthController(this._authRepo, this._profileController,
      this._currentUserNotifier, this._currentUser);

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    await _authRepo.signInWithEmailAndPassword(email, password);
    _profileController.initUser();
    return _authRepo.currentUser;
  }

  Future<User?> registerUser(
      String email, String password, String name, String lastName) async {
    try {
      print('AuthRepo currentUser before register: ${_authRepo.currentUser}');
      await _authRepo.registerUser(email, password, name, lastName);
      print('AuthRepo currentUser after register: ${_authRepo.currentUser}');
      return await _profileController.registerVolunteer(name, lastName);
    } catch (e) {
      print('Error AuthController.registerUser: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    _currentUserNotifier.set(Volunteer.empty());
    print('Current User should be empty: $_currentUser');
    await _authRepo.signOut();
    return;
  }
}

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthenticationProvider).authStateChanges();
});

// Initialize all providers for bootstrap
Future<void> initializeProviders(ProviderContainer container) async {
  // initialize Firebase
  final authProvider = container.read(firebaseAuthenticationProvider);
  final authUser = authProvider.currentUser;

  print('Initializing the authStateProvider: $authUser');
  // Restore connection if needed
  if (authUser != null) {
    try {
      // renew token if needed
      await authUser.getIdToken(true);
    } catch (e) {
      print('Error getting the refresh Token: $e');
    }
  }
  print('Initialized authStateProvider');
}
