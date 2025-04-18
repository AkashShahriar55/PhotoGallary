import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_event.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/utils/permission_manager.dart';

class PermissionBloc extends Bloc<PermissionEvent,PermissionState>{
  final PermissionManager permissionManager;

  PermissionBloc(super.initialState, this.permissionManager){
    on<PhotoPermissionRequest>((event, emit) async {
      // Request permission
      final bool isGranted = await _requestPhotoAccess();

      // Emit the success state with the permission status
      emit(PermissionRequestSuccess(isPermissionGranted: isGranted));
    });
  }


  Future<bool> _requestPhotoAccess() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
      await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        final res = await permissionManager.requestPermission(PermissionEnum.storage);
        Log().d("Permission status: $res");
        return res == PermissionStatusEnum.granted;
      } else {
        final res = await permissionManager.requestPermission(PermissionEnum.photos);
        Log().d("Permission status: $res");
        return res == PermissionStatusEnum.granted;
      }
    } else {
      final res = await permissionManager.requestPermission(PermissionEnum.photos);
      Log().d("Permission status: $res");
      return res == PermissionStatusEnum.granted;
    }
  }


}