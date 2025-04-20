sealed class PermissionState {
  const PermissionState();
}


final class PermissionInitial extends PermissionState {
  const PermissionInitial();
}

final class PermissionRequestInProgress extends PermissionState {
  const PermissionRequestInProgress();
}

final class PermissionRequestSuccess extends PermissionState {
  const PermissionRequestSuccess({required this.isPermissionGranted});
  final bool isPermissionGranted;
}

final class PermissionRequestFailure extends PermissionState {
  const PermissionRequestFailure({required this.exception});
  final Exception exception;
}