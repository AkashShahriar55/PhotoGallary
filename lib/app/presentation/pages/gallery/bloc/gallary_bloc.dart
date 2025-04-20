import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_event.dart';
import '../../../../core/utils/logger.dart';
import '../../../../domain/usecase/fetch_gallery_photos.dart';
import '../../../../domain/usecase/save_gallery_photos.dart';
import 'gallary_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {

  final FetchGalleryPhotos _fetchGalleryPhotos;
  final SaveGalleryPhotos _saveGalleryPhotos;

  GalleryBloc(this._fetchGalleryPhotos,this._saveGalleryPhotos) : super(GalleryState(isPhotoLoading: true)) {

    on<FetchPhotos>((event, emit) async{
      // Emit the loading state
      emit(state.copyWith(
        errorMessage: null,
      ));
      final result = await _fetchGalleryPhotos();

      result.when(onSuccess: (value){
        emit(state.copyWith(
          isPhotoLoading: false,
          photos: value,
        ));
      }, onError: (error,st){
        emit(state.copyWith(
          isPhotoLoading: false,
          errorMessage: error.toString(),
        ));
      });
    });


    on<DownloadPhotos>(
      (event, emit) async {
        // Call the download function
        await _downloadPhotos(event, emit);
      },
    );

    add(FetchPhotos());
  }




  Future<void> _downloadPhotos(DownloadPhotos event, Emitter<GalleryState> emit) async {
    if (event.photoIds.isEmpty) return;

    final photos = state.photos.where((photo) => event.photoIds.contains(photo.id)).toList();

    //emit loading

    // Emit the loading state
    emit(state.copyWith(
      errorMessage: null,
      progress: 0
    ));


    int index = 0;
    for (final photo in photos) {
      emit(state.copyWith(
        status: DownloadStatus.downloading,
      ));
      final result = await _saveGalleryPhotos(photo);
      result.when(onSuccess: (newPhoto){
        //emit success
        emit(state.copyWith(
          status: DownloadStatus.success,
          progress: ((++index) / photos.length * 100).toInt(),
          photos: [newPhoto,...state.photos],
        ));

      }, onError: (e,st){
        emit(state.copyWith(
          status: DownloadStatus.error,
          errorMessage: e.toString(),
        ));
      });
    }

    emit(state.copyWith(
      status: DownloadStatus.initial,
      progress: null,
      errorMessage: null,
    ));
  }
}