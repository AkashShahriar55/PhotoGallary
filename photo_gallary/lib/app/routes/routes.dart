import 'package:go_router/go_router.dart';
import 'package:photo_gallary/app/routes/app_route.dart';

import '../presentation/pages/splash/splash.dart';

final class Routes{
  static final AppRoute splashRoute = AppRoute(
      path: "/splash",
      name: "splash",
  );

  static final AppRoute permissionRoute = AppRoute(
      path: "/permission",
      name: "permission",
  );

  static final AppRoute galleryRoute = AppRoute(
      path: "/gallery",
      name: "gallery",
  );

}