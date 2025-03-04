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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBIUFp2YyXi_luALDoOFg_NawDpTA6ie50',
    appId: '1:393103543743:web:17bd382d9a089dbc44650a',
    messagingSenderId: '393103543743',
    projectId: 'mitch-master-chat-app',
    authDomain: 'mitch-master-chat-app.firebaseapp.com',
    storageBucket: 'mitch-master-chat-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDV6OKPujvHdSCtGFCBO0QRAPP3ingU0X8',
    appId: '1:393103543743:android:77b54034a6ea5f9644650a',
    messagingSenderId: '393103543743',
    projectId: 'mitch-master-chat-app',
    storageBucket: 'mitch-master-chat-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0BjF873B5d2c5Ssvr8iR94NQ5JxVdE74',
    appId: '1:393103543743:ios:39fa7b3552e16a3a44650a',
    messagingSenderId: '393103543743',
    projectId: 'mitch-master-chat-app',
    storageBucket: 'mitch-master-chat-app.firebasestorage.app',
    iosBundleId: 'com.fuad.mitchMasterChatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0BjF873B5d2c5Ssvr8iR94NQ5JxVdE74',
    appId: '1:393103543743:ios:39fa7b3552e16a3a44650a',
    messagingSenderId: '393103543743',
    projectId: 'mitch-master-chat-app',
    storageBucket: 'mitch-master-chat-app.firebasestorage.app',
    iosBundleId: 'com.fuad.mitchMasterChatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBIUFp2YyXi_luALDoOFg_NawDpTA6ie50',
    appId: '1:393103543743:web:092cbc111528445944650a',
    messagingSenderId: '393103543743',
    projectId: 'mitch-master-chat-app',
    authDomain: 'mitch-master-chat-app.firebaseapp.com',
    storageBucket: 'mitch-master-chat-app.firebasestorage.app',
  );
}
