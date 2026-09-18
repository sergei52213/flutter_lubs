import 'package:flutter/material.dart';
import 'di/di.dart';
import 'flutter_application_1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  runApp(const FlutterApplication1());
}