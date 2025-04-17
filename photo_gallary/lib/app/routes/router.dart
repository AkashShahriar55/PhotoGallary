
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallary/app/features/splash/splash.dart';

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
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    )
  ]
);