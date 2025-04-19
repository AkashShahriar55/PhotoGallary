import 'local/local_storage/model/photo.dart';

abstract class PhotoDataSource {
  Future<List<Photo>?> fetchPhotos();
  Future<Photo?> savePhoto(Photo photo);
}