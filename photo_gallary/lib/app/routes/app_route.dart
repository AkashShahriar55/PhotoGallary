/// Represents a single route in the application.
///
/// Each [AppRoute] pairs a human‑readable [name] with a URL [path]
/// that the router can navigate to.
class AppRoute{

  /// The display name of the route.
  final String name;
  /// The URL or path string for navigation.
  final String path;

  AppRoute({
    required this.name,
    required this.path,
  });
}