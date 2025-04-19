
import 'package:bloc/bloc.dart';
import 'package:photo_gallary/app/core/extensions/permission_extentions.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_event.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_state.dart';


class SplashBloc extends Bloc<SplashEvent,SplashState>{

  final PermissionManager permissionManager;

  SplashBloc(this.permissionManager):super(SplashInitial()){
    on<SplashInitializeEvent>((event,emit) async{

      // Doing initialization task here
      await Future<void>.delayed(const Duration(seconds: 3));

      // Check if permission is granted
      final bool isPermissionGranted = await permissionManager.checkAndRequestPhotoPermission(false);

      // Emit the success state with the permission status
      emit(SplashInitializationSuccess(isPermissionGranted: isPermissionGranted));
    });

    add(SplashInitializeEvent());
  }


}