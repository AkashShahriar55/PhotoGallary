import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_event.dart';
import '../../../../domain/usecase/fetch_gallery_photos.dart';
import 'gallary_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {

  final FetchGalleryPhotos fetchGalleryPhotos;

  GalleryBloc(this.fetchGalleryPhotos) : super(GalleryInitial()) {
    on<FetchPhotos>((event, emit) async{
      // Emit the loading state
      if(state is GalleryInitial){
        emit(GalleryLoading());
      }

      final result = await fetchGalleryPhotos();

      result.when(onSuccess: (value){
        emit(GalleryLoaded(photos: value));
      }, onError: (error,st){
        emit(GalleryError(error: error.toString()));
      });

    });

  }
}