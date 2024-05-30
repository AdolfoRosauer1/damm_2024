import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

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
      return null;
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
      return null;
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

@Riverpod(keepAlive: true)
AuthRepository firebaseAuth(FirebaseAuthRef ref) {
  var auth = AuthRepository(FirebaseAuth.instance);
  // auth.signInWithEmailAndPassword("adolfo@prueba.com", "123456");
  // var user = auth.currentUser;
  // print('current user: $user');
  return auth;
}

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Initialize all providers for bootstrap
Future<void> initializeProviders(ProviderContainer container) async {
  // initialize Firebase
  final authProvider = container.read(firebaseAuthProvider);
  final authUser = authProvider.currentUser;

  // Restore connection if needed
  if (authUser != null) {
    try {
      // renew token if needed
      await authUser.getIdToken(true);
    } catch (e) {
      print(e);
    }
  }
}

// @Riverpod(keepAlive: true)
// AuthRepository authRepository(AuthRepositoryRef ref) {
//   return AuthRepository(ref.watch(firebaseAuthProvider));
// }

// @riverpod
// Stream<User?> authStateChanges(AuthStateChangesRef ref) {
//   return ref.watch(authRepositoryProvider).authStateChanges();
// }

//final firebaseAuthClient = ref.read(firebaseAuthProvider); final User? firebaseAuthUser = firebaseAuthClient.currentUser; logger.d("Trying to restore Firebase session"); if (firebaseAuthUser != null) { /// Restore firebase user session try { /// Returns the current token if it has not expired. Otherwise, this will /// restore the token and return a new one. await firebaseAuthUser.getIdToken(true);
