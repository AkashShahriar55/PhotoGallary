sealed class GalleryEvent {
  const GalleryEvent();
}


class FetchPhotos extends GalleryEvent {
  final int pageNo;
  const FetchPhotos(this.pageNo);
}