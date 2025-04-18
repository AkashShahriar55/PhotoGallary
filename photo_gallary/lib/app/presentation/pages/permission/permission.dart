import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallary/app/core/extensions/extensions.dart';

import '../../../core/theme/sizes.dart';
import '../../../core/widgets/primary_button.dart';

class PermissionScreen extends StatefulWidget{
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: (){},
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
  }

}