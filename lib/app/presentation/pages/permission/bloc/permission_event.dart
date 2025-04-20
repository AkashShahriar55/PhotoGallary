sealed class PermissionEvent{}

final class PhotoPermissionRequest extends PermissionEvent {
  final bool shouldOpenSettings;

  PhotoPermissionRequest({this.shouldOpenSettings = false});
}

