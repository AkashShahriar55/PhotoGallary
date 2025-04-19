
class Photo {
      final int id;
      final String uri;
      final String name;
      final String path;
      final int size; // File size in bytes
      final int? timestamp; // Nullable timestamp
      final int width; // Width of the photo
      final int height; // Height of the photo

      Photo({
        required this.id,
        required this.uri,
        required this.name,
        required this.path,
        required this.size,
        this.timestamp,
        required this.width,
        required this.height,
      });

      // From JSON factory for converting JSON to Photo object
      factory Photo.fromJson(dynamic json) {
        return Photo(
          id: json['id'],
          uri: json['uri'],
          name: json['name'],
          path: json['path'],
          size: json['size'],
          timestamp: json['timestamp'],
          width: json['width'],
          height: json['height'],
        );
      }
}