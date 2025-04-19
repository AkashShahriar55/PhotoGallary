import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_state.dart';
import 'package:photo_gallary/app/routes/router.dart';
import '../../../routes/routes.dart';
import 'bloc/splash_event.dart';

class SplashScreen extends StatelessWidget{

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc,SplashState>(
      bloc: getIt<SplashBloc>()..add(SplashInitializeEvent()),
      listener: (context,state){
        if(state is SplashInitializationSuccess){
          if(state.isPermissionGranted){
            _goToGallery();
          } else {
            _goToPermission();
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/icon/icon.png',width: 130,height: 130),
        ),
      ),
    );
  }

  _goToGallery(){
    router.goNamed(Routes.galleryRoute.name);
  }

  _goToPermission(){
    router.goNamed(Routes.permissionRoute.name);
  }

}