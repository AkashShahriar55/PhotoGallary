import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';
class PhotoTile extends StatelessWidget {
  final String path;

  const PhotoTile({
    required this.path,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.dimen_5),
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
      ),
    );
  }
}
