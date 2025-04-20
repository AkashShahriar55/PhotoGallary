import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:photo_gallary/app/data/repository/gallery_repository_impl.dart';
import 'package:photo_gallary/app/data/datasources/photo_datasource.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

class MockPhotoDataSource extends Mock implements PhotoDataSource {}

void main() {
  late GalleryRepositoryImpl repository;
  late MockPhotoDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPhotoDataSource();
    repository = GalleryRepositoryImpl(mockDataSource);
  });

  group('fetchPhotos', () {
    final tPhotos = [
      Photo(id: '1', uri: 'uri1', name: 'name1', path: 'path1', size: 100, width: 50, height: 50, orientation: 0),
      Photo(id: '2', uri: 'uri2', name: 'name2', path: 'path2', size: 200, width: 60, height: 80, orientation: 1),
    ];

    test('should return list of photos when data source returns non-null', () async {
      // Arrange
      when(() => mockDataSource.fetchPhotos())
          .thenAnswer((_) async => tPhotos);
      // Act
      final result = await repository.fetchPhotos();
      // Assert
      expect(result, equals(tPhotos));
      verify(() => mockDataSource.fetchPhotos()).called(1);
    });

    test('should return empty list when data source returns null', () async {
      // Arrange
      when(() => mockDataSource.fetchPhotos())
          .thenAnswer((_) async => null);
      // Act
      final result = await repository.fetchPhotos();
      // Assert
      expect(result, isEmpty);
      verify(() => mockDataSource.fetchPhotos()).called(1);
    });
  });

  group('savePhotos', () {
    final tPhoto = Photo(
      id: '10', uri: 'uri10', name: 'name10', path: 'path10', size: 500, width: 100, height: 100, orientation: 0,
    );

    test('should return photo when data source returns photo', () async {
      // Arrange
      when(() => mockDataSource.savePhoto(tPhoto))
          .thenAnswer((_) async => tPhoto);
      // Act
      final result = await repository.savePhotos(tPhoto);
      // Assert
      expect(result, equals(tPhoto));
      verify(() => mockDataSource.savePhoto(tPhoto)).called(1);
    });

    test('should return null when data source returns null', () async {
      // Arrange
      when(() => mockDataSource.savePhoto(tPhoto))
          .thenAnswer((_) async => null);
      // Act
      final result = await repository.savePhotos(tPhoto);
      // Assert
      expect(result, isNull);
      verify(() => mockDataSource.savePhoto(tPhoto)).called(1);
    });
  });
}