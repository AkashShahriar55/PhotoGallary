import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/domain/usecase/fetch_paginated_gallery_photos.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_event.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';

import '../../../../core/utils/logger.dart';
import 'gallary_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {

  final FetchGalleryPhotos fetchPaginatedGalleryPhotos;

  GalleryBloc(this.fetchPaginatedGalleryPhotos) : super(GalleryInitial()) {
    on<FetchPhotos>((event, emit) async{
      // Emit the loading state
      emit(GalleryLoading());
      try{
        final photos = await fetchPaginatedGalleryPhotos.execute();
        emit(GalleryLoaded(photos: photos));
      }catch(e){
        emit(GalleryError(error: e.toString()));
      }

    });
  }
}