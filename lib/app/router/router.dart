import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../di/di.dart';
import '../features/features.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    observers: [TalkerRouteObserver(talker)],
    debugLogDiagnostics: true,
    initialLocation: '/home',
    navigatorKey: _rootNavigationKey,
    refreshListenable: _AuthRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AuthAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && isLoginRoute) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const HomeScreen()),
      ),
      GoRoute(
        path: '/favorites',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const FavoritesScreen()),
      ),
      GoRoute(
        path: '/detail/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;

          return MaterialPage(
            key: state.pageKey,
            child: DetailScreen(id: id),
          );
        },
      ),
    ],
  );
}

class _AuthRefreshStream extends ChangeNotifier {
  _AuthRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
