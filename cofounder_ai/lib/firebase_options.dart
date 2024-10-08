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
    apiKey: 'AIzaSyDA5Y_XWlIOC0Ni78_Q_UKrij4Ku1piDUQ',
    appId: '1:972308486238:web:74162a94f20d5ecb113ccf',
    messagingSenderId: '972308486238',
    projectId: 'cofounder-ai-e647c',
    authDomain: 'cofounder-ai-e647c.firebaseapp.com',
    storageBucket: 'cofounder-ai-e647c.appspot.com',
    measurementId: 'G-5L1YW55H6T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAH52oHUFNZYV0yEAgkcJT275IWP7DTzeo',
    appId: '1:972308486238:android:49b2e25e7126ca0b113ccf',
    messagingSenderId: '972308486238',
    projectId: 'cofounder-ai-e647c',
    storageBucket: 'cofounder-ai-e647c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANqJncnZ6qdgrRO2bzhwz_LI4smgPZD-I',
    appId: '1:972308486238:ios:79bb8e4ad4be99a8113ccf',
    messagingSenderId: '972308486238',
    projectId: 'cofounder-ai-e647c',
    storageBucket: 'cofounder-ai-e647c.appspot.com',
    androidClientId: '972308486238-anb8vpkd3q7u1382djhi7sk206bbkms4.apps.googleusercontent.com',
    iosClientId: '972308486238-gjp7qmhmi41jpukvbltr90ap484jpja1.apps.googleusercontent.com',
    iosBundleId: 'com.example.cofounderAi',
  );

}