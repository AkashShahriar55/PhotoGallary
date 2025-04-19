import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';

extension PermissionExtentions on PermissionManager {
  Future<bool> checkAndRequestPhotoPermission(bool shouldOpenSettings) async {
    PermissionEnum permission = PermissionEnum.photos;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
      await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = PermissionEnum.storage;
      } else {
        permission = PermissionEnum.photos;
      }
    }
    final res = await requestPermission(permission);
    if(res == PermissionStatusEnum.permanentlyDenied && shouldOpenSettings){
      openAppSettings();
    }
    return res == PermissionStatusEnum.granted;
  }

  Future<bool> checkPhotoPermission(bool shouldOpenSettings) async {
    PermissionEnum permission = PermissionEnum.photos;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
      await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = PermissionEnum.storage;
      } else {
        permission = PermissionEnum.photos;
      }
    }
    return await isPermissionGranted(permission);
  }
}

