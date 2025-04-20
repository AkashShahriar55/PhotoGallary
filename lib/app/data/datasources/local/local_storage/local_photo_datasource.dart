import 'dart:io';
import 'package:flutter/services.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

import '../../../../core/utils/logger.dart';
import '../../photo_datasource.dart';

class LocalPhotoDatasource extends PhotoDataSource {

  final MethodChannel _channel = const MethodChannel('com.photogallary.cheq/gallery');
  final String _fetchPhotosMethod = 'getImages';
  final String _savePhotosMethod = 'saveAndFetchPhoto';
  final String _pathArg = 'path';


  // Method to fetch photos from a specific album
  @override
  Future<List<Photo>?> fetchPhotos() async {
    try {
      final List<dynamic>? photos = await _channel.invokeMethod(_fetchPhotosMethod);
      if(photos == null) {
        return null;
      }
      List<Photo> photoList = photos.map((dynamic photoJson){return Photo.fromJson(photoJson);}).toList();
      return photoList;
    } on PlatformException catch (e) {
      Log.e("Error fetching photos: ${e.message}");
      return null;
    }
  }

  @override
  Future<Photo?> savePhoto(Photo photo) async{
    final src = File(photo.path);
    final result = await _channel.invokeMethod(_savePhotosMethod, {_pathArg: src.path});
    return result != null ? Photo.fromJson(result) : null;
  }

}