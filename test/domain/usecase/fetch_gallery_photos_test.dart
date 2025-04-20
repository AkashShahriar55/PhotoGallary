import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:photo_gallary/app/domain/usecase/fetch_gallery_photos.dart';
import 'package:photo_gallary/app/domain/repository/gallery_repository.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/domain/result.dart';

class MockGalleryRepository extends Mock implements GalleryRepository {}
class MockPermissionManager extends Mock implements PermissionManager {}

void main() {
  late FetchGalleryPhotos usecase;
  late MockGalleryRepository mockGalleryRepository;
  late MockPermissionManager mockPermissionManager;

  setUp(() {
    mockGalleryRepository = MockGalleryRepository();
    mockPermissionManager = MockPermissionManager();
    usecase = FetchGalleryPhotos(
      mockGalleryRepository,
      mockPermissionManager,
    );
  });

  group('FetchGalleryPhotos UseCase', () {
    final tPhotos = [
      Photo(
        id: '1', uri: 'uri1', name: 'name1', path: 'path1',
        size: 100, width: 50, height: 50, orientation: 0,
      ),
    ];

    test('returns error when permission is denied', () async {
      // Arrange: permission denied
      when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
          .thenAnswer((_) async => false);

      // Act
      final result = await usecase.call();

      // Assert
      result.when(
        onSuccess: (_) => fail('Expected an error, but got success'),
        onError: (error, _) {
          expect(error, isA<Exception>());
          expect(error.toString(), 'Exception: Permission denied');
        },
      );

      // Verify that repository was never called
      verifyNever(() => mockGalleryRepository.fetchPhotos());
    });

    test('returns photos when permission granted and fetch succeeds', () async {
      // Arrange: permission granted
      when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
          .thenAnswer((_) async => true);
      when(() => mockGalleryRepository.fetchPhotos())
          .thenAnswer((_) async => tPhotos);

      // Act
      final result = await usecase.call();

      // Assert
      result.when(
        onSuccess: (photos) => expect(photos, tPhotos),
        onError: (error, _) => fail('Expected success, but got error: $error'),
      );

      verify(() => mockGalleryRepository.fetchPhotos()).called(1);
    });

    test('returns error when repository throws an exception', () async {
      // Arrange: permission granted but repository throws
      when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
          .thenAnswer((_) async => true);
      when(() => mockGalleryRepository.fetchPhotos())
          .thenThrow(Exception('Boom'));

      // Act
      final result = await usecase.call();

      // Assert
      result.when(
        onSuccess: (_) => fail('Expected an error, but got success'),
        onError: (error, _) {
          expect(error.toString(), contains('Boom'));
        },
      );
      verify(() => mockGalleryRepository.fetchPhotos()).called(1);
    });
  });
}