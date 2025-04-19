
import 'package:photo_gallary/app/core/extensions/permission_extentions.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

import '../../core/utils/permission_manager.dart';
import '../repository/gallery_repository.dart';
import '../result.dart';
import 'base/use_case.dart';

class SaveGalleryPhotos extends BaseUserCase<Map<Photo,bool>, List<Photo>> {
  final GalleryRepository galleryRepository;
  final PermissionManager permissionManager;

  SaveGalleryPhotos({
    required this.permissionManager,
    required this.galleryRepository,
  });

  @override
  Future<Result<Map<Photo,bool>>> call(List<Photo> photos) async{
    try{
      final permission =await  permissionManager.checkAndRequestPhotoPermission(false);
      if(permission == false){
        return Result.error(Exception("Permission denied"));
      }
      final isSaved = await galleryRepository.savePhotos(photos);
      return Result.ok(isSaved);
    }catch(e){
      return Result.error(Exception(e.toString()));
    }
  }

}