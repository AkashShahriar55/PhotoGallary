
import 'package:photo_gallary/app/core/extensions/permission_extentions.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

import '../../core/utils/permission_manager.dart';
import '../repository/gallery_repository.dart';
import '../result.dart';
import 'base/use_case.dart';

class SaveGalleryPhotos extends BaseUserCase<String, Photo> {
  final GalleryRepository _galleryRepository;
  final PermissionManager _permissionManager;

  SaveGalleryPhotos(this._galleryRepository,this._permissionManager);

  @override
  Future<Result<String>> call(Photo photo) async{
    try{
      final permission =await  _permissionManager.checkAndRequestPhotoPermission(false);
      if(permission == false){
        return Result.error(Exception("Permission denied"));
      }
      final isSaved = await _galleryRepository.savePhotos(photo);
      return Result.ok(isSaved);
    }catch(e){
      return Result.error(Exception(e.toString()));
    }
  }

}