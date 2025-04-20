
import 'package:photo_gallary/app/core/extensions/permission_extentions.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/domain/repository/gallery_repository.dart';
import 'package:photo_gallary/app/domain/result.dart';
import 'package:photo_gallary/app/domain/usecase/base/use_case.dart';

class FetchGalleryPhotos extends BaseUserCase<List<Photo>, void> {
  final GalleryRepository _galleryRepository;
  final PermissionManager _permissionManager;

  FetchGalleryPhotos(
     this._galleryRepository,
     this._permissionManager,
  );

  @override
  Future<Result<List<Photo>>> call([void _]) async{
    try{
      final permission = await _permissionManager.checkAndRequestPhotoPermission(false);
      if(permission == false){
        return Result.error(Exception("Permission denied"));
      }
      final photos = await _galleryRepository.fetchPhotos();
      return Result.ok(photos);
    }catch(e){
      return Result.error(Exception(e.toString()));
    }
  }

}