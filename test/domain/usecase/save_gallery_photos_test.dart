import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:photo_gallary/app/domain/usecase/save_gallery_photos.dart';
import 'package:photo_gallary/app/domain/repository/gallery_repository.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

class MockGalleryRepository extends Mock implements GalleryRepository {}
class MockPermissionManager extends Mock implements PermissionManager {}
class FakePhoto extends Fake implements Photo {}

void main() {
  late SaveGalleryPhotos usecase;
  late MockGalleryRepository mockGalleryRepository;
  late MockPermissionManager mockPermissionManager;

  setUpAll(() {
    registerFallbackValue(FakePhoto());
  });

  setUp(() {
    mockGalleryRepository = MockGalleryRepository();
    mockPermissionManager = MockPermissionManager();
    usecase = SaveGalleryPhotos(
      mockGalleryRepository,
      mockPermissionManager,
    );
  });

  final tPhoto = Photo(
    id: '1', uri: 'uri1', name: 'name1', path: 'path1',
    size: 100, width: 50, height: 50, orientation: 0,
  );
  final savedPhoto = tPhoto.copyWith(name: 'saved');

  group('SaveGalleryPhotos UseCase', () {
    test('returns error when permission denied', () async {
      // Arrange: permission denied
      when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
          .thenAnswer((_) async => false);

      // Act
      final result = await usecase.call(tPhoto);

      // Assert
      result.when(
        onSuccess: (_) => fail('Expected an error, but got success'),
        onError: (error, _) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Permission denied'));
        },
      );
      // Verify repository never called
      verifyNever(() => mockGalleryRepository.savePhotos(any()));
    });

    test('returns saved photo when permission granted and save succeeds', () async {
      // Arrange: permission granted
      when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
          .thenAnswer((_) async => true);
      when(() => mockGalleryRepository.savePhotos(tPhoto))
          .thenAnswer((_) async => savedPhoto);

      // Act
      final result = await usecase.call(tPhoto);

      // Assert
      result.when(
        onSuccess: (photo) => expect(photo, savedPhoto),
        onError: (error, _) => fail('Expected success, but got error: $error'),
      );
      verify(() => mockGalleryRepository.savePhotos(tPhoto)).called(1);
    });

    test('returns error when repository throws exception', () async {
      // Arrange: permission granted but save fails
      when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
          .thenAnswer((_) async => true);
      when(() => mockGalleryRepository.savePhotos(any()))
          .thenThrow(Exception('Save failure'));

      // Act
      final result = await usecase.call(tPhoto);

      // Assert
      result.when(
        onSuccess: (_) => fail('Expected an error, but got success'),
        onError: (error, _) {
          expect(error.toString(), contains('Save failure'));
        },
      );
      verify(() => mockGalleryRepository.savePhotos(tPhoto)).called(1);
    });
  });
}