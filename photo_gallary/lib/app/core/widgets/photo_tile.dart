import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';

import '../../data/datasources/local/local_storage/model/photo.dart';
import '../utils/logger.dart';

class PhotoTile extends StatelessWidget {
  final Photo photo;
  final bool selected;
  final VoidCallback? onTap;

  const PhotoTile({
    required this.photo,
    this.selected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.dimen_5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // determine the target decode size (in device pixels)

            Log.d("PhotoTile width: ${photo.width}, height: ${photo.height} , orientation: ${photo.orientation}");

            final int actualHeight = photo.orientation == 90 ? photo.width : photo.height;
            final int actualWidth = photo.orientation == 90 ? photo.height : photo.width;

            final int targetWidth  = (constraints.maxWidth  * MediaQuery.of(context).devicePixelRatio).toInt();
            final int targetHeight = (targetWidth * actualHeight/actualWidth).toInt();

            // a simple grey box as placeholder
            final placeholder = Container(color: Colors.grey.shade300);

            Widget image = Image.file(
              File(photo.path),
              fit: BoxFit.cover,
              width: constraints.maxWidth,
              height: constraints.maxWidth * actualHeight/actualWidth,
              cacheWidth: targetWidth,
              cacheHeight: targetHeight,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                // once the first frame is available, show the real image
                if (wasSynchronouslyLoaded || frame != null) {
                  return child;
                }
                // otherwise show placeholder
                return placeholder;
              },
              errorBuilder: (context, error, stack) => const Center(
                child: Icon(Icons.broken_image, size: 32, color: Colors.grey),
              ),
            );

            // apply your blur‐and‐check overlay if selected
            if (selected) {
              image = ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: image,
              );
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                image,
                if (selected) ...[
                  Container(color: Colors.black.withOpacity(0.2)),
                  const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xFF66FFB6),
                      size: 32,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
