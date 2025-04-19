import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/domain/usecase/save_gallery_photos.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/download_cubit/download_state.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/selection_cubit/selection_cubit.dart';

import '../../../../../core/utils/logger.dart';

class DownloadCubit extends Cubit<DownloadState>{

  final SelectionCubit _selectionCubit;
  late final StreamSubscription<List<Photo>> _sub;

  final SaveGalleryPhotos _saveGalleryPhotos;


  DownloadCubit(this._selectionCubit, this._saveGalleryPhotos) : super(DownloadState()){
    _sub = _selectionCubit.stream.listen((event) {
      if(event.isNotEmpty){
        emit(state.copyWith(isPhotoSelected: true));
      }else{
        emit(state.copyWith(isPhotoSelected: false));
      }
    });
  }


  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }

  Future<void> downloadPhotos() async {
    final photos = _selectionCubit.state;
    if (photos.isEmpty) return;

    //emit loading


    for (final photo in photos) {
      emit(state.copyWith(
        status: DownloadStatus.downloading,
      ));
      final result = await _saveGalleryPhotos(photo);
      result.when(onSuccess: (value){
        //emit success
        emit(state.copyWith(
          status: DownloadStatus.success,
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