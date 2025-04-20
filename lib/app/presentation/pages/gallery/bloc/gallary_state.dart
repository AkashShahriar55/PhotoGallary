import '../../../../data/datasources/local/local_storage/model/photo.dart';


enum DownloadStatus {initial, downloading, success, error}

class GalleryState {
  final bool isPhotoLoading;
  final DownloadStatus status;
  final String? errorMessage;
  final int? progress;
  final List<Photo> photos;

  const GalleryState({
    this.isPhotoLoading = false,
    this.status = DownloadStatus.initial,
    this.errorMessage,
    this.progress,
    this.photos = const [],
  });

  GalleryState copyWith({
    bool? isPhotoLoading,
    DownloadStatus? status,
    String? errorMessage,
    int? progress,
    List<Photo>? photos,
  }) {
    return GalleryState(
      isPhotoLoading: isPhotoLoading ?? this.isPhotoLoading,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      photos: photos ?? this.photos,
    );
  }
}

