import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallary/app/core/extensions/extensions.dart';

AppBar galleryAppBar({required BuildContext context, required String title}) => AppBar(
  title: Text(
    title,
    style: context.textTheme.bodyMedium?.copyWith(
        color: Colors.black
    ),
  ),
  centerTitle: true,
  leading: IconButton(
      onPressed: (){
        context.pop();
      },
      icon: SvgPicture.asset(
        'assets/svgs/chevron_left.svg',
      )
  ),
);