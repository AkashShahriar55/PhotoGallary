import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/permission/permission.dart';
import '../presentation/pages/splash/splash.dart';


abstract class _Routes {
  static const String splash = '/splash';
  static const String permission = '/permission';
  static const String gallery = '/gallery';
}


final GoRouter router = GoRouter(
  initialLocation: _Routes.splash,
  routes: [
    GoRoute(
        path: _Routes.splash,
        name: 'splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: _Routes.permission,
      name: 'permission',
      builder: (BuildContext context, GoRouterState state) {
        return const PermissionScreen();
      },
    )
  ]
);