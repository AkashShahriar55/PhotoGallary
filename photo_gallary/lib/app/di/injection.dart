import 'package:get_it/get_it.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/data/datasources/photo_datasource.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';
import '../data/datasources/local/local_storage/local_photo_datasource.dart';
import '../data/repository/gallery_repository_impl.dart';
import '../domain/repository/gallery_repository.dart';
import '../domain/usecase/fetch_gallery_photos.dart';
import '../domain/usecase/save_gallery_photos.dart';

final GetIt getIt = GetIt.instance;

// This is the main function to setup dependency injection
void setupDependencyInjection() {
  _injectManagers();
  _injectDataSources();
  _injectRepositories();
  _injectUseCases();
  _injectBlocs();
}

// This injects Managers and Helpers
void _injectManagers(){
  getIt.registerLazySingleton<PermissionManager>(() => PermissionHandlerManager());
}

// This injects Data Sources
void _injectDataSources(){
  getIt.registerFactory<PhotoDataSource>(() => LocalPhotoDatasource());
}

// This injects Repositories
void _injectRepositories(){
  getIt.registerFactory<GalleryRepository>(() => GalleryRepositoryImpl(getIt<PhotoDataSource>()));
}

// This injects Use Cases
void _injectUseCases(){
  getIt.registerFactory<FetchGalleryPhotos>(() => FetchGalleryPhotos(getIt<GalleryRepository>(),getIt<PermissionManager>()));
  getIt.registerFactory<SaveGalleryPhotos>(() => SaveGalleryPhotos(getIt<GalleryRepository>(), getIt<PermissionManager>()));
}

// This injects Blocs
void _injectBlocs(){
  getIt.registerFactory<SplashBloc>(() => SplashBloc(getIt<PermissionManager>()));
  getIt.registerFactory<PermissionBloc>(() => PermissionBloc(getIt<PermissionManager>()));
  getIt.registerFactory<GalleryBloc>(() => GalleryBloc(getIt<FetchGalleryPhotos>()));
}