import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_event.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent,SplashState>{

  final PermissionManager permissionManager;

  SplashBloc(this.permissionManager,super.initialState){
    on<SplashInitializeEvent>((event,emit) async{

      // Doing initialization task here
      await Future<void>.delayed(const Duration(seconds: 5));

      // Check if permission is granted
      final bool isPermissionGranted = await _checkIfPermissionIsGiven();

      // Emit the success state with the permission status
      emit(SplashInitializationSuccess(isPermissionGranted: isPermissionGranted));
    });
  }


  Future<bool> _checkIfPermissionIsGiven() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
      await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        return await permissionManager.isPermissionGranted(PermissionEnum.storage);
      } else {
        return await permissionManager.isPermissionGranted(PermissionEnum.photos);
      }
    } else {
      return await permissionManager.isPermissionGranted(PermissionEnum.photos);
    }
  }
}