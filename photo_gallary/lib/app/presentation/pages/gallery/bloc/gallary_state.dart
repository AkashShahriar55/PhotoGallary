import '../../../../data/datasources/local/local_storage/model/photo.dart';

sealed class GalleryState {
  const GalleryState();
}

class GalleryInitial extends GalleryState {
  const GalleryInitial();
}

class GalleryLoading extends GalleryState {
  const GalleryLoading();
}

class GalleryLoaded extends GalleryState {
  final List<Photo> photos;
  const GalleryLoaded({required this.photos});
}

class GalleryError extends GalleryState {
  final String error;
  const GalleryError({required this.error});
}