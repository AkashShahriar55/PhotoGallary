import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/routes/router.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    listenForPhotoAccessPermission((bool isPermissionGranted) {
      if (isPermissionGranted) {
        router.goNamed(
          'gallery',
          // extra: true,
        );
      } else {
        router.goNamed("permission");
      }
    });
  }

  void listenForPhotoAccessPermission(
      Function(bool isPermissionGranted) callback,
      ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
      await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        bool res =
        await PermissionHandlerManager().isPermissionGranted(PermissionEnum.storage);
        callback.call(res);
      } else {
        bool res =
        await PermissionHandlerManager().isPermissionGranted(PermissionEnum.photos);
        callback.call(res);
      }
    } else {
      bool res =
      await PermissionHandlerManager().isPermissionGranted(PermissionEnum.photos);
      callback.call(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/icon/icon.png',width: 130,height: 130),
      ),
    );
  }
}