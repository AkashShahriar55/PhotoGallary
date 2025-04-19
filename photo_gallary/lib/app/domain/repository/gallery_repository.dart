import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

abstract class GalleryRepository{
  Future<List<Photo>?> fetchPhotos();
}