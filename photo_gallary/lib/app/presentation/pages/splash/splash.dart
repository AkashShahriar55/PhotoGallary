import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_event.dart';
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
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SplashBloc(getIt<PermissionManager>(), SplashInitial())..add(SplashInitializeEvent()),
      child: BlocListener<SplashBloc,SplashState>(
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
      )
    );
  }


  _goToGallery(){
    router.goNamed(Routes.galleryRoute.name);
  }

  _goToPermission(){
    router.goNamed(Routes.permissionRoute.name);
  }
}