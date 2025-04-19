import 'package:flutter/services.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

import '../../photo_datasource.dart';

class LocalPhotoDatasource extends PhotoDataSource {

  final MethodChannel _channel = const MethodChannel('com.photogallary.cheq/gallery');

  // Method to fetch photos from a specific album
  @override
  Future<List<Photo>?> fetchPhotos() async {
    try {
      final List<dynamic>? photos = await _channel.invokeMethod('getImages');
      if(photos == null) {
        return null;
      }
      List<Photo> photoList = photos.map((dynamic photoJson){return Photo.fromJson(photoJson);}).toList();
      return photoList;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<Map<Photo,bool>> savePhotos(List<Photo> photos) {
    // TODO: implement savePhotos
    throw UnimplementedError();
  }

}