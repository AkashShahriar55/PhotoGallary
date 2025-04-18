import 'package:go_router/go_router.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/gallery.dart';
import 'package:photo_gallary/app/presentation/pages/permission/permission.dart';
import 'package:photo_gallary/app/routes/routes.dart';

import '../presentation/pages/splash/splash.dart';




final GoRouter router = GoRouter(
  initialLocation: Routes.splashRoute.path,
  routes: [
    GoRoute(
        path: Routes.splashRoute.path,
        name: Routes.splashRoute.name,
        builder: (context, state) {
          return const SplashScreen();
        }
    ),
    GoRoute(
        path: Routes.permissionRoute.path,
        name: Routes.permissionRoute.name,
        builder: (context, state) {
          return const PermissionScreen();
        }
    ),
    GoRoute(
        path: Routes.galleryRoute.path,
        name: Routes.galleryRoute.name,
        builder: (context, state) {
          return const GalleryScreen();
        }
    )
  ]
);