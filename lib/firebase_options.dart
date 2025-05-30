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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAuaW9tbqdBJroo2zxWaddD-cOfx9LmLGU',
    appId: '1:122833301442:web:6d6846ab2cbbc75b03b05b',
    messagingSenderId: '122833301442',
    projectId: 'expensetracker-1347c',
    authDomain: 'expensetracker-1347c.firebaseapp.com',
    storageBucket: 'expensetracker-1347c.firebasestorage.app',
    measurementId: 'G-BPS8JX75C3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEl0aM_qdTTiy-z_iUSeHLVpHktjHqCAk',
    appId: '1:122833301442:android:11e61b5f729533f703b05b',
    messagingSenderId: '122833301442',
    projectId: 'expensetracker-1347c',
    storageBucket: 'expensetracker-1347c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQTq4dn0jDDMSCGM3RTpDDkFE8MvNH-vQ',
    appId: '1:122833301442:ios:c4bfe4fa00fbb97703b05b',
    messagingSenderId: '122833301442',
    projectId: 'expensetracker-1347c',
    storageBucket: 'expensetracker-1347c.firebasestorage.app',
    iosBundleId: 'com.cipherschools.assignment',
  );

}