import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase не поддерживается на этой платформе. '
          'Запустите приложение в браузере, на Android или iOS.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789012:web:0123456789abcdef',
    messagingSenderId: '123456789012',
    projectId: 'cross-lab-firebase',
    authDomain: 'cross-lab-firebase.firebaseapp.com',
    storageBucket: 'cross-lab-firebase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789012:android:0123456789abcdef',
    messagingSenderId: '123456789012',
    projectId: 'cross-lab-firebase',
    storageBucket: 'cross-lab-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789012:ios:0123456789abcdef',
    messagingSenderId: '123456789012',
    projectId: 'cross-lab-firebase',
    storageBucket: 'cross-lab-firebase.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789012:ios:0123456789abcdef',
    messagingSenderId: '123456789012',
    projectId: 'cross-lab-firebase',
    storageBucket: 'cross-lab-firebase.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789012:web:0123456789abcdef',
    messagingSenderId: '123456789012',
    projectId: 'cross-lab-firebase',
    authDomain: 'cross-lab-firebase.firebaseapp.com',
    storageBucket: 'cross-lab-firebase.appspot.com',
  );
}
