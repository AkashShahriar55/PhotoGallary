import 'package:flutter/services.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

import '../../../../core/utils/logger.dart';

class LocalPhotoStorage{
  final MethodChannel _channel = const MethodChannel('com.photogallary.cheq/gallery');

  // Method to fetch photos from a specific album
  Future<List<Photo>?> fetchPhotos() async {
    try {
      final List<dynamic>? photos = await _channel.invokeMethod('getImages');
      Log.d("photos: $photos");
      if(photos == null) {
        return null;
      }
      List<Photo> photoList = photos.map((dynamic photoJson){return Photo.fromJson(photoJson);}).toList();
      return photoList;
    } on PlatformException catch (e) {
      Log.e("Failed to fetch photos: '${e.message}'.");
      return null;
    } on Exception catch (e) {
      Log.e("Failed to fetch photos: '${e.toString()}'.");
      return null;
    } on Error catch (e) {
      Log.e("Failed to fetch photos: '${e.toString()}'.");
      return null;
    }
  }

}