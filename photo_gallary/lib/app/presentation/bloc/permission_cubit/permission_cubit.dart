import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/presentation/bloc/permission_cubit/permission_state.dart';

import '../../../core/utils/permission_manager.dart';

class PermissionCubit extends Cubit<PermissionState>{
  final PermissionManager permissionManager;


  PermissionCubit(this.permissionManager):super(PermissionInitial());


  // Future<bool> isPermissionGiven() async => await _checkIfPermissionIsGiven();



  checkPermission(List<PermissionEnum> permissions) async{
    final status = await permissionManager.requestPermissions(permissions);

    emit(PermissionStatus(permissionStatus: status));
  }


  //
  // Future<bool> _requestPhotoAccess() async {
  //   if (Platform.isAndroid) {
  //     final AndroidDeviceInfo androidInfo =
  //     await DeviceInfoPlugin().androidInfo;
  //     if (androidInfo.version.sdkInt <= 32) {
  //       final res = await permissionManager.requestPermission(PermissionEnum.storage);
  //       Log.d("Permission status: $res");
  //       return res == PermissionStatusEnum.granted;
  //     } else {
  //       final res = await permissionManager.requestPermission(PermissionEnum.photos);
  //       Log.d("Permission status: $res");
  //       return res == PermissionStatusEnum.granted;
  //     }
  //   } else {
  //     final res = await permissionManager.requestPermission(PermissionEnum.photos);
  //     Log.d("Permission status: $res");
  //     return res == PermissionStatusEnum.granted;
  //   }
  // }
  //
  //
  // Future<bool> _checkIfPermissionIsGiven() async {
  //   if (Platform.isAndroid) {
  //     final AndroidDeviceInfo androidInfo =
  //     await DeviceInfoPlugin().androidInfo;
  //     if (androidInfo.version.sdkInt <= 32) {
  //       return await permissionManager.isPermissionGranted(PermissionEnum.storage);
  //     } else {
  //       return await permissionManager.isPermissionGranted(PermissionEnum.photos);
  //     }
  //   } else {
  //     return await permissionManager.isPermissionGranted(PermissionEnum.photos);
  //   }
  // }



}