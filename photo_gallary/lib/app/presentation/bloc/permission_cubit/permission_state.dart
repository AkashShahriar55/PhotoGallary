import 'package:photo_gallary/app/core/utils/permission_manager.dart';

sealed class PermissionState {
  const PermissionState();
}

class PermissionInitial extends PermissionState {
  const PermissionInitial();
}

class PermissionStatus extends PermissionState {
  final Map<PermissionEnum,PermissionStatusEnum> permissionStatus;
  const PermissionStatus({required this.permissionStatus});

}


class PermissionCheckInProgress extends PermissionState {
  const PermissionCheckInProgress();
}