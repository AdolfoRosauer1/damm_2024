// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOMtVP-5vlZ8s1SZLIsg7ZBNTkeiWe1r0',
    appId: '1:958761820636:android:77b5ac2f69080de7cc2f19',
    messagingSenderId: '958761820636',
    projectId: 'damm-dc6d1',
    databaseURL: 'https://damm-dc6d1-default-rtdb.firebaseio.com',
    storageBucket: 'damm-dc6d1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnL1aECOZzvwuv7b-nb2oYqoGXXABXAeY',
    appId: '1:958761820636:ios:1481d31a9e650f99cc2f19',
    messagingSenderId: '958761820636',
    projectId: 'damm-dc6d1',
    databaseURL: 'https://damm-dc6d1-default-rtdb.firebaseio.com',
    storageBucket: 'damm-dc6d1.appspot.com',
    iosBundleId: 'itba.edu.ar.damm2024',
  );

}