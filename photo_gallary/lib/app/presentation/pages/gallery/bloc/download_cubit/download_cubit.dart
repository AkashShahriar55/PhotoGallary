import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/download_cubit/download_state.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/selection_cubit/selection_cubit.dart';

import '../../../../../core/utils/logger.dart';

class DownloadCubit extends Cubit<DownloadState>{

  final SelectionCubit selectionCubit;
  late final StreamSubscription<List<Photo>> _sub;


  DownloadCubit(this.selectionCubit) : super(DownloadState()){
    _sub = selectionCubit.stream.listen((event) {
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
    final photos = selectionCubit.state;
    if (photos.isEmpty) return;

    //emit loading
    emit(state.copyWith(
      status: DownloadStatus.downloading,
    ));

    try {
      //get external storage directory
      final baseDir = await getExternalStorageDirectory();
      final downloadDir = Directory(path.join(baseDir!.path, 'Download'));
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Check for access premission
      final hasAccess = await Gal.hasAccess();
      Log.d("hasAccess: $hasAccess");
      // Request access premission
      await Gal.requestAccess();

      //copy each file
      int index = 0;
      for (final photo in photos) {
        final src = File(photo.path);
        await Gal.putImage(src.path,album: "cheq");
        emit(state.copyWith(
          progress: index++
        ));
      }
      //emit success
      emit(state.copyWith(
        status: DownloadStatus.success,
      ));

    } catch (e) {
      Log.e('downloadPhotos error ${e.toString()}');
      emit(state.copyWith(
        status: DownloadStatus.error,
        errorMessage: e.toString(),
      ));
    }

    emit(state.copyWith(
      status: DownloadStatus.initial,
      progress: null,
      errorMessage: null,
    ));
  }

}