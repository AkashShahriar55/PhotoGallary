sealed class GalleryEvent {
  const GalleryEvent();
}


class FetchPhotos extends GalleryEvent {
  const FetchPhotos();
}

class DownloadPhotos extends GalleryEvent {
  final List<String> photoIds;
  const DownloadPhotos(this.photoIds);
}