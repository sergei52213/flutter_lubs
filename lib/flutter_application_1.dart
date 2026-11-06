import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/app.dart';
import 'di/di.dart';

class FlutterApplication1 extends StatefulWidget {
  const FlutterApplication1({super.key});

  @override
  State<FlutterApplication1> createState() => _FlutterApplication1State();
}

class _FlutterApplication1State extends State<FlutterApplication1> {
  late final GoRouter _router = createRouter(getIt<AuthBloc>());

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GameVault',
      theme: AppTheme.lightTheme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
