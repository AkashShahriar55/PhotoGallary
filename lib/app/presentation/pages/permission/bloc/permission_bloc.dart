import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_event.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/permission_manager.dart';

class PermissionBloc extends Bloc<PermissionEvent,PermissionState>{
  final PermissionManager permissionManager;

  PermissionBloc( this.permissionManager) : super(PermissionInitial()){
    on<PhotoPermissionRequest>((event, emit) async {
      emit(PermissionRequestInProgress());

      // Request permission
      final bool isGranted = await permissionManager.checkAndRequestPhotoPermission(event.shouldOpenSettings,shouldAddImage: true);

      Log.d('Permission granted: $isGranted');
      // Emit the success state with the permission status
      emit(PermissionRequestSuccess(isPermissionGranted: isGranted));
    });

    add(PhotoPermissionRequest());
  }

}