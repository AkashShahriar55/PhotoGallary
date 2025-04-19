
class Photo {
      final String id;
      final String uri;
      final String name;
      final String path;
      final int size; // File size in bytes
      final int width; // Width of the photo
      final int height; // Height of the photo
      final int orientation;

      Photo({
        required this.id,
        required this.uri,
        required this.name,
        required this.path,
        required this.size,
        required this.width,
        required this.height,
        required this.orientation ,
      });

      // From JSON factory for converting JSON to Photo object
      factory Photo.fromJson(dynamic json) {
        return Photo(
          id: json['id'].toString(),
          uri: json['uri'],
          name: json['name'],
          path: json['path'],
          size: json['size'],
          width: json['width'],
          height: json['height'],
          orientation: json['orientation'],
        );
      }

      Photo copyWith({
        String? id,
        String? uri,
        String? name,
        String? path,
        int? size,
        int? width,
        int? height,
        int? orientation,
      }) {
        return Photo(
          id: id ?? this.id,
          uri: uri ?? this.uri,
          name: name ?? this.name,
          path: path ?? this.path,
          size: size ?? this.size,
          width: width ?? this.width,
          height: height ?? this.height,
          orientation: orientation ?? this.orientation,
        );
      }


}