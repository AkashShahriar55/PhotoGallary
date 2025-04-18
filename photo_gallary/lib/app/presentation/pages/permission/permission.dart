import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallary/app/core/extensions/extensions.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_event.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';

import '../../../core/theme/sizes.dart';
import '../../../core/utils/permission_manager.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../di/injection.dart';

class PermissionScreen extends StatefulWidget{
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>{

  final PermissionBloc _bloc = PermissionBloc(PermissionInitial(),getIt<PermissionManager>());

  @override
  void initState() {
    super.initState();
    _bloc.add(PhotoPermissionRequest());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc,PermissionState>(
      bloc: _bloc,
      listener: (context, state) {
        if(state is PermissionRequestSuccess){
          context.read<PermissionBloc>().add(PhotoPermissionRequest());
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                        _bloc.add(PhotoPermissionRequest());
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
        );
      },
    );
  }

}