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
    apiKey: 'AIzaSyBTOI4dRItuNNMPXgnIdNYjABVjyQU1W84',
    appId: '1:700087777412:web:4124982ca191d1fc7dead1',
    messagingSenderId: '700087777412',
    projectId: 'docsview-5f2a3',
    authDomain: 'docsview-5f2a3.firebaseapp.com',
    storageBucket: 'docsview-5f2a3.firebasestorage.app',
    measurementId: 'G-NWM2ESFXDT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFEI9TDti-4CefEVwWl3634MY0-mh_Ng4',
    appId: '1:700087777412:android:a2ee60898cc374647dead1',
    messagingSenderId: '700087777412',
    projectId: 'docsview-5f2a3',
    storageBucket: 'docsview-5f2a3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALLTwYrJw23elZGgIpNn_uTkJrbHP_Vac',
    appId: '1:700087777412:ios:6ec22e2ca6ec9f097dead1',
    messagingSenderId: '700087777412',
    projectId: 'docsview-5f2a3',
    storageBucket: 'docsview-5f2a3.firebasestorage.app',
    iosBundleId: 'com.example.docsview',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyALLTwYrJw23elZGgIpNn_uTkJrbHP_Vac',
    appId: '1:700087777412:ios:6ec22e2ca6ec9f097dead1',
    messagingSenderId: '700087777412',
    projectId: 'docsview-5f2a3',
    storageBucket: 'docsview-5f2a3.firebasestorage.app',
    iosBundleId: 'com.example.docsview',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBTOI4dRItuNNMPXgnIdNYjABVjyQU1W84',
    appId: '1:700087777412:web:93e9d40aa93de5077dead1',
    messagingSenderId: '700087777412',
    projectId: 'docsview-5f2a3',
    authDomain: 'docsview-5f2a3.firebaseapp.com',
    storageBucket: 'docsview-5f2a3.firebasestorage.app',
    measurementId: 'G-HFSEDP7MRN',
  );
}
