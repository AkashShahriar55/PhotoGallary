import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/data/datasources/photo_datasource.dart';
import '../../domain/repository/gallery_repository.dart';

class GalleryRepositoryImpl extends GalleryRepository{

  final PhotoDataSource _photoDatasource;

  GalleryRepositoryImpl(this._photoDatasource);

  @override
  Future<List<Photo>> fetchPhotos() async{
    final value = await _photoDatasource.fetchPhotos();
    return value ?? [];
  }

  @override
  Future<bool> savePhotos(Photo photo) async{
    return await _photoDatasource.savePhoto(photo);
  }
}