import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/domain/repository/gallery_repository.dart';

class FetchGalleryPhotos {
  final GalleryRepository galleryRepository;


  FetchGalleryPhotos({
    required this.galleryRepository,
  });

  Future<List<Photo>> execute() async{
    return await galleryRepository.fetchPhotos() ?? [];
  }

}