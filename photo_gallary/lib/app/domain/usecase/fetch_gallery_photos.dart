
import 'package:photo_gallary/app/core/extensions/permission_extentions.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/domain/repository/gallery_repository.dart';
import 'package:photo_gallary/app/domain/result.dart';
import 'package:photo_gallary/app/domain/usecase/base/use_case.dart';

class FetchGalleryPhotos extends BaseUserCase<List<Photo>, void> {
  final GalleryRepository galleryRepository;
  final PermissionManager permissionManager;

  FetchGalleryPhotos({
    required this.permissionManager,
    required this.galleryRepository,
  });

  @override
  Future<Result<List<Photo>>> call([void _]) async{
    try{
      final permission = await permissionManager.checkAndRequestPhotoPermission(false);
      if(permission == false){
        return Result.error(Exception("Permission denied"));
      }
      final photos = await galleryRepository.fetchPhotos();
      return Result.ok(photos);
    }catch(e){
      return Result.error(Exception(e.toString()));
    }
  }

}