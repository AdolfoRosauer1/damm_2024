import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthController authController(AuthControllerRef ref) {
  return AuthController(ref.watch(authRepositoryProvider));
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
      return null;
    }
  }
}

class AuthController {
  AuthRepository _authRepo;
  AuthController(this._authRepo);

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    return _authRepo.signInWithEmailAndPassword(email, password);
  }

  Future<User?> registerUser(
      String email, String password, String name, String lastName) async {
    return _authRepo.registerUser(email, password, name, lastName);
  }

  Future<void> signOut() async {
    return _authRepo.signOut();
  }
}

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Initialize all providers for bootstrap
Future<void> initializeProviders(ProviderContainer container) async {
  // initialize Firebase
  final authProvider = container.read(firebaseAuthProvider);
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
