// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBvKdDZMxz5rTzM9ph8V5bGPMjki_3MPL4',
    appId: '1:1088206766470:web:8cc4546d172bcbb7166c07',
    messagingSenderId: '1088206766470',
    projectId: 'nosh-canteen-mgt',
    authDomain: 'nosh-canteen-mgt.firebaseapp.com',
    storageBucket: 'nosh-canteen-mgt.appspot.com',
    measurementId: 'G-9JXZZ3QGM2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsL8aYoPzlrpUDmCfhb0klbu-ntQyqAHs',
    appId: '1:1088206766470:android:716c14bad49e20ab166c07',
    messagingSenderId: '1088206766470',
    projectId: 'nosh-canteen-mgt',
    storageBucket: 'nosh-canteen-mgt.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_6VC4jsiSsrwtHIKvG4u5QRVNoDyTFb0',
    appId: '1:1088206766470:ios:055d1c6c5b055826166c07',
    messagingSenderId: '1088206766470',
    projectId: 'nosh-canteen-mgt',
    storageBucket: 'nosh-canteen-mgt.appspot.com',
    iosClientId: '1088206766470-acvc95qv6hi1m0uf3ntgg0uevoi8m00p.apps.googleusercontent.com',
    iosBundleId: 'com.example.noshApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_6VC4jsiSsrwtHIKvG4u5QRVNoDyTFb0',
    appId: '1:1088206766470:ios:055d1c6c5b055826166c07',
    messagingSenderId: '1088206766470',
    projectId: 'nosh-canteen-mgt',
    storageBucket: 'nosh-canteen-mgt.appspot.com',
    iosClientId: '1088206766470-acvc95qv6hi1m0uf3ntgg0uevoi8m00p.apps.googleusercontent.com',
    iosBundleId: 'com.example.noshApp',
  );
}