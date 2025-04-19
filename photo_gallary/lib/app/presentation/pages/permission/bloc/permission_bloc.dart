import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_event.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/utils/permission_manager.dart';

class PermissionBloc extends Bloc<PermissionEvent,PermissionState>{
  final PermissionManager permissionManager;

  PermissionBloc( this.permissionManager) : super(PermissionInitial()){
    on<PhotoPermissionRequest>((event, emit) async {
      // Request permission
      final bool isGranted = await _requestPhotoAccess();

      // Emit the success state with the permission status
      emit(PermissionRequestSuccess(isPermissionGranted: isGranted));
    });
  }


  Future<bool> _requestPhotoAccess() async {
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
    final res = await permissionManager.requestPermission(permission);
    if(res == PermissionStatusEnum.permanentlyDenied){
      openAppSettings();
    }
    return res == PermissionStatusEnum.granted;
  }


}