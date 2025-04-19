import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallary/app/core/extensions/extensions.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_event.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';
import 'package:photo_gallary/app/routes/router.dart';
import '../../../core/theme/sizes.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../di/injection.dart';
import '../../../routes/routes.dart';

class PermissionScreen extends StatelessWidget{
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionBloc,PermissionState>(
      bloc: getIt<PermissionBloc>()..add(PhotoPermissionRequest()),
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
              SvgPicture.asset('assets/svgs/permission_icon.svg',width: 123,height: 149),
              SizedBox(height: Dimens.dimen_42),
              Text(
                'Require Permission',
                style: context.textTheme.bodyMedium,
              ),
              SizedBox(height: Dimens.dimen_8),
              Text(
                'To show your black and white photos\nwe just need your folder permission.\nWe promise, we don’t take your photos.',
                style: context.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.dimen_42),
              SizedBox(
                width: Dimens.dimen_296,
                height: Dimens.dimen_42,
                child: PrimaryButton(
                    onTap: (){
                      getIt<PermissionBloc>().add(PhotoPermissionRequest(shouldOpenSettings: true));
                    },
                    child:  Text(
                      'Grant Access',
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