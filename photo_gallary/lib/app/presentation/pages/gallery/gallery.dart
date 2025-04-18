import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallary/app/core/extensions/extensions.dart';

class GalleryScreen extends StatefulWidget{
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Photos',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.black
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: (){},
            icon: SvgPicture.asset(
              'assets/svgs/chevron_left.svg',
            )
        ),
      ),
    );
  }
}