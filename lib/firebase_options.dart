import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'your-api-key',
    appId: 'your-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkG4wfnEC1HQu0XeEwV1eU7eGLhnKNfyc',
    appId: '1:552741042562:android:186703d374210c32d3779b',
    messagingSenderId: 'your-sender-id',
    projectId: 'toogoodtogo-f458f',
    storageBucket: 'toogoodtogo-f458f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDc0624FcMUGA53NMPowLPPJFlKSzedWHI',
    appId: 'com.example.tooGoodToGoClone',
    messagingSenderId: '552741042562',
    projectId: 'toogoodtogo-f458f',
    storageBucket: 'toogoodtogo-f458f.appspot.com',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'com.example.tooGoodToGoClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'your-api-key',
    appId: 'your-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'com.example.tooGoodToGoClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'your-api-key',
    appId: 'your-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );
} 