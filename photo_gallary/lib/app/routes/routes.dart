import 'package:photo_gallary/app/routes/app_route.dart';


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