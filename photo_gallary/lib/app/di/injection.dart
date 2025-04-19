

import 'package:get_it/get_it.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/local_photo_storage.dart';
import 'package:photo_gallary/app/domain/usecase/fetch_paginated_gallery_photos.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';

import '../data/repository/gallery_repository_impl.dart';
import '../domain/repository/gallery_repository.dart';

final GetIt getIt = GetIt.instance;
void setupDependencyInjection() {
  getIt.registerLazySingleton<PermissionManager>(() => PermissionHandlerManager());
  getIt.registerFactory<LocalPhotoStorage>(() => LocalPhotoStorage());
  getIt.registerFactory<GalleryRepository>(() => GalleryRepositoryImpl(getIt<LocalPhotoStorage>()));
  getIt.registerFactory<FetchGalleryPhotos>(() => FetchGalleryPhotos(galleryRepository: getIt<GalleryRepository>()));
  getIt.registerFactory<SplashBloc>(()=>SplashBloc(getIt<PermissionManager>()));
  getIt.registerFactory<PermissionBloc>(()=>PermissionBloc(getIt<PermissionManager>()));
  getIt.registerFactory<GalleryBloc>(()=>GalleryBloc(getIt<FetchGalleryPhotos>()));
}