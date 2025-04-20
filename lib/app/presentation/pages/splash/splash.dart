import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/constants/assets.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_state.dart';
import 'package:photo_gallary/app/routes/router.dart';
import '../../../routes/routes.dart';


class SplashScreen extends StatefulWidget{

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc,SplashState>(
      bloc: getIt<SplashBloc>(),
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
          child: Image.asset(AppAssets.icon,width: Dimens.dimen_130,height: Dimens.dimen_130),
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