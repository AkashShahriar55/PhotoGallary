import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallary/app/constants/assets.dart';
import 'package:photo_gallary/app/constants/strings.dart';
import 'package:photo_gallary/app/core/extensions/extensions.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_event.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';
import 'package:photo_gallary/app/routes/router.dart';
import '../../../core/theme/sizes.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../di/injection.dart';
import '../../../routes/routes.dart';

class PermissionScreen extends StatefulWidget{

  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late final PermissionBloc _permissionBloc;

  @override
  void initState() {
    _permissionBloc = getIt<PermissionBloc>();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return BlocListener<PermissionBloc,PermissionState>(
      bloc: _permissionBloc,
      listener: (context, state) {
        if(state is PermissionRequestSuccess){
          if(state.isPermissionGranted){
            _goToGallery();
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.permissionIcon,width: Dimens.dimen_123,height: Dimens.dimen_149),
              SizedBox(height: Dimens.dimen_42),
              Text(
                AppStrings.requirePermission,
                style: context.textTheme.bodyMedium,
              ),
              SizedBox(height: Dimens.dimen_8),
              Text(
                AppStrings.requirePermissionDescription,
                style: context.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.dimen_42),
              SizedBox(
                width: Dimens.dimen_296,
                height: Dimens.dimen_42,
                child: PrimaryButton(
                    onTap: (){
                      _permissionBloc.add(PhotoPermissionRequest(shouldOpenSettings: true));
                    },
                    child:  Text(
                     AppStrings.grantAccess,
                      style: context.textTheme.labelMedium,
                    )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  _goToGallery(){
    router.goNamed(Routes.galleryRoute.name);
  }
}