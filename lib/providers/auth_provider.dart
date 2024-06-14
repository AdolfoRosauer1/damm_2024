import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  final AnalyticsService _analyticsService = AnalyticsService();
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
        _analyticsService.logSignup(user!.uid);

      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e,stackTrace) {
      FirebaseCrashlytics.instance.recordError(e,stackTrace);
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
      await _authRepo.registerUser(email, password, name, lastName);
      return await _profileController.registerVolunteer(name, lastName);
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
    return null;
  }

  Future<void> signOut() async {
    _currentUserNotifier.set(Volunteer.empty());
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

  // Restore connection if needed
  if (authUser != null) {
    try {
      // renew token if needed
      await authUser.getIdToken(true);
    } catch (error,stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
