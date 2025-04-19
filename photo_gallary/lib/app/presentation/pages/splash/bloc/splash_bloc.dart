import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_event.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_state.dart';

import '../../../../core/utils/logger.dart';

class SplashBloc extends Bloc<SplashEvent,SplashState>{

  final PermissionManager permissionManager;

  SplashBloc(this.permissionManager):super(SplashInitial()){
    on<SplashInitializeEvent>((event,emit) async{

      // Doing initialization task here
      await Future<void>.delayed(const Duration(seconds: 5));

      // Check if permission is granted
      final bool isPermissionGranted = await _checkIfPermissionIsGiven();

      Log.d("Permission status: $isPermissionGranted");

      // Emit the success state with the permission status
      emit(SplashInitializationSuccess(isPermissionGranted: isPermissionGranted));
    });
  }


  Future<bool> _checkIfPermissionIsGiven() async {
    PermissionEnum permissionEnum = PermissionEnum.photos;
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
      await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permissionEnum = PermissionEnum.storage;
      } else {
        permissionEnum = PermissionEnum.photos;
      }
    }
    return await permissionManager.isPermissionGranted(permissionEnum);
  }
}