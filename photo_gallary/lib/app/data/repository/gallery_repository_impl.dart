import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import '../../core/utils/logger.dart';
import '../../domain/repository/gallery_repository.dart';
import '../datasources/local/local_storage/local_photo_storage.dart';

class GalleryRepositoryImpl extends GalleryRepository{

  final LocalPhotoStorage _localPhotoStorage;

  GalleryRepositoryImpl(this._localPhotoStorage);

  @override
  Future<List<Photo>?> fetchPhotos() async{
    final value = await _localPhotoStorage.fetchPhotos();
    return value;
  }
}