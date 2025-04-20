
import 'package:permission_handler/permission_handler.dart';

/// Defines the state of a [Permission].
enum PermissionStatusEnum {
  /// The user denied access to the requested feature, permission needs to be
  /// asked first.
  denied,

  /// The user granted access to the requested feature.
  granted,

  /// The OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  ///
  /// *Only supported on iOS.*
  restricted,

  /// The user has authorized this application for limited access. So far this
  /// is only relevant for the Photo Library picker.
  ///
  /// *Only supported on iOS (iOS14+) and Android (Android 14+)*
  limited,

  /// Permission to the requested feature is permanently denied, the permission
  /// dialog will not be shown when requesting this permission. The user may
  /// still change the permission status in the settings.
  permanentlyDenied,

  /// The application is provisionally authorized to post non-interruptive user
  /// notifications.
  ///
  /// *Only supported on iOS (iOS12+).*
  provisional,
}

/// Defines the state of a [Permissions].
enum PermissionEnum {
  /// Permission for accessing external storage.
  storage,
  /// Permission for accessing the device's photos.
  photos,

}


/// PermissionManager is an abstract class that defines the methods for
/// requesting and checking permissions.
abstract class PermissionManager{
  // Request permission for a specific Permission
  Future<PermissionStatusEnum> requestPermission(PermissionEnum permissionEnum);
  // Check if a permission is granted
  Future<bool> isPermissionGranted(PermissionEnum permissionEnum);

  // Check if a permission is granted
  Future<PermissionStatusEnum> permissionStatus(PermissionEnum permissionEnum);

  // Request multiple permissions at once
  Future<Map<PermissionEnum, PermissionStatusEnum>> requestPermissions(List<PermissionEnum> permissionEnums);

  openAppSettings();
}



class PermissionHandlerManager extends PermissionManager {


  // Request permission for a specific Permission
  @override
  Future<PermissionStatusEnum> requestPermission(PermissionEnum permissionEnum) async {
    final permission = _mapPermissionEnumToPermission(permissionEnum);
    return _mapPermissionStatusToPermissionStatusEnum(await permission.request());
  }

  // Check if a permission is granted
  @override
  Future<bool> isPermissionGranted(PermissionEnum permissionEnum) async {
    final permission = _mapPermissionEnumToPermission(permissionEnum);
    return permission.status.isGranted;
  }

  // Request multiple permissions at once
  @override
  Future<Map<PermissionEnum, PermissionStatusEnum>> requestPermissions(List<PermissionEnum> permissionEnums) async {
    final permissions = permissionEnums.map((e) => _mapPermissionEnumToPermission(e)).toList();
    final permissionStatus = await permissions.request();
    return permissionStatus.map((key, value) {
      return MapEntry(_mapPermissionToPermissionEnum(key), _mapPermissionStatusToPermissionStatusEnum(value));
    });
  }

  @override
  void openAppSettings() {
    openAppSettings(); // Calls platform-specific method to open settings
  }


  Permission _mapPermissionEnumToPermission(PermissionEnum permission) {
    switch (permission) {
      case PermissionEnum.storage:
        return Permission.storage;
      case PermissionEnum.photos:
        return Permission.photos;
    }
  }

  PermissionEnum _mapPermissionToPermissionEnum(Permission permission) {
    switch (permission) {
      case Permission.storage:
        return PermissionEnum.storage;
      case Permission.photos:
        return PermissionEnum.photos;
      default:
        throw Exception('Unknown permission: $permission');
    }
  }

  PermissionStatusEnum _mapPermissionStatusToPermissionStatusEnum(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        return PermissionStatusEnum.denied;
      case PermissionStatus.granted:
        return PermissionStatusEnum.granted;
      case PermissionStatus.restricted:
        return PermissionStatusEnum.restricted;
      case PermissionStatus.limited:
        return PermissionStatusEnum.limited;
      case PermissionStatus.permanentlyDenied:
        return PermissionStatusEnum.permanentlyDenied;
      case PermissionStatus.provisional:
        return PermissionStatusEnum.provisional;
    }
  }

  @override
  Future<PermissionStatusEnum> permissionStatus(PermissionEnum permissionEnum) {
    final permission = _mapPermissionEnumToPermission(permissionEnum);
    return permission.status.then((status) {
      return _mapPermissionStatusToPermissionStatusEnum(status);
    });
  }

}