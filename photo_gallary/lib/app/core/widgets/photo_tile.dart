import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';
class PhotoTile extends StatelessWidget {
  final String path;
  final bool selected;
  final VoidCallback? onTap;

  const PhotoTile({
    required this.path,
    this.selected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    if (selected) {
      image = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: image,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.dimen_5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            if (selected) ...[
              Container(color: Colors.black.withOpacity(0.2)),
              const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Color(0XFF66FFB6),
                  size: 32,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}