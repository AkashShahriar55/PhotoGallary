import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
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
  Future<String> savePhoto(Photo photo, {int blurRadius = 10}) async{
    //get external storage directory
    final src = File(photo.path);
    await Gal.putImage(src.path);
    return "";
  }

}