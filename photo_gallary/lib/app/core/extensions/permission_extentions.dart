import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';

extension PermissionExtentions on PermissionManager {

  /// Requests (and/or opens Settings) for the proper photo/storage permissions
  /// on both Android and iOS.
  Future<bool> checkAndRequestPhotoPermission(bool shouldOpenSettings) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdk = androidInfo.version.sdkInt;

      // On Android 13+ you split by media type; below you still use storage
      final permission = (sdk >= 33) ? Permission.photos : Permission.storage;
      final status = await permission.request();

      if (status.isGranted) return true;
      if (status.isPermanentlyDenied && shouldOpenSettings) {
        await openAppSettings();
      }
      return false;
    }

    if (Platform.isIOS) {
      // iOS 14+ has a new permission for adding photos
      final statusRead = await Permission.photos.request();
      final readOk = statusRead.isGranted || statusRead.isLimited; // limited on iOS14+
      if (!readOk) {
        if (statusRead.isPermanentlyDenied && shouldOpenSettings) {
          await openAppSettings();
        }
        return false;
      }

      // // iOS 14+ has a new permission for adding photos
      // final statusAdd = await Permission.photosAddOnly.request();
      // if (!statusAdd.isGranted) {
      //   if (statusAdd.isPermanentlyDenied && shouldOpenSettings) {
      //     await openAppSettings();
      //   }
      //   return false;
      // }

      return true;
    }

    // Other platforms (web, desktop)– assume OK
    return true;
  }

  /// Just checks (no dialog) whether you already have the required permission.
  Future<bool> checkPhotoPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdk = androidInfo.version.sdkInt;
      final permission = (sdk >= 33) ? Permission.photos : Permission.storage;
      final status = await permission.status;
      return status.isGranted;
    }

    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      // on iOS14+ limited counts as “read” permission
      return status.isGranted || status.isLimited;
    }

    return true;
  }
}

