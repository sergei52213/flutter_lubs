import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'di/di.dart';
import 'firebase_options.dart';
import 'flutter_application_1.dart';

const _useFirebaseEmulator = bool.fromEnvironment(
  'USE_FIREBASE_EMULATOR',
  defaultValue: false,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (_useFirebaseEmulator) {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    }
  } catch (exception) {
    runApp(FirebaseStartupError(exception: exception));
    return;
  }

  await setupLocator();

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  runApp(const FlutterApplication1());
}

class FirebaseStartupError extends StatelessWidget {
  const FirebaseStartupError({super.key, required this.exception});

  final Object exception;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Не удалось инициализировать Firebase',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(exception.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                const Text(
                  'Firebase поддерживается на Android, iOS и в браузере. '
                  'Для Linux используйте веб-версию приложения.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
