import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:photo_gallary/app/domain/result.dart';
import 'package:photo_gallary/app/domain/usecase/fetch_gallery_photos.dart';
import 'package:photo_gallary/app/domain/usecase/save_gallery_photos.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_event.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_state.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

// Create mocks for the use cases
class MockFetchGalleryPhotos extends Mock implements FetchGalleryPhotos {}

class MockSaveGalleryPhotos extends Mock implements SaveGalleryPhotos {}

void main() {
  late GalleryBloc galleryBloc;
  late MockFetchGalleryPhotos mockFetchGalleryPhotos;
  late MockSaveGalleryPhotos mockSaveGalleryPhotos;

  setUp(() {
    mockFetchGalleryPhotos = MockFetchGalleryPhotos();
    mockSaveGalleryPhotos = MockSaveGalleryPhotos();
    galleryBloc = GalleryBloc(mockFetchGalleryPhotos, mockSaveGalleryPhotos);
  });

  final mockPhotos = [
    Photo(id: '1', uri: 'uri1', name: 'photo1', path: 'path1', size: 100, width: 200, height: 300, orientation: 1),
    Photo(id: '2', uri: 'uri2', name: 'photo2', path: 'path2', size: 200, width: 200, height: 300, orientation: 1),
  ];

  group('GalleryBloc Tests', () {
    blocTest<GalleryBloc, GalleryState>(
      'emits [loading, success] when FetchPhotos event succeeds',
      build: () {
        when(mockFetchGalleryPhotos())
            .thenAnswer((_) async => Result.ok(mockPhotos));
        return galleryBloc;
      },
      act: (bloc) => bloc.add(FetchPhotos()),
      expect: () => [
        GalleryState(isPhotoLoading: true), // Loading state
        GalleryState(isPhotoLoading: false, photos: mockPhotos), // Loaded state
      ],
      verify: (_) {
        verify(mockFetchGalleryPhotos()).called(1);
      },
    );

    blocTest<GalleryBloc, GalleryState>(
      'emits [loading, error] when FetchPhotos event fails',
      build: () {
        when(mockFetchGalleryPhotos())
            .thenAnswer((_) async => Result.error(Exception('Error fetching photos')));
        return galleryBloc;
      },
      act: (bloc) => bloc.add(FetchPhotos()),
      expect: () => [
        GalleryState(isPhotoLoading: true), // Loading state
        GalleryState(isPhotoLoading: false, errorMessage: 'Error fetching photos'), // Error state
      ],
      verify: (_) {
        verify(mockFetchGalleryPhotos()).called(1);
      },
    );

    blocTest<GalleryBloc, GalleryState>(
      'emits [downloading, success] when DownloadPhotos event succeeds',
      build: () {
        when(mockSaveGalleryPhotos(mockPhotos[0]))
            .thenAnswer((_) async => Result.ok(mockPhotos[0]));
        return galleryBloc;
      },
      act: (bloc) => bloc.add(DownloadPhotos([mockPhotos[0].id])),
      expect: () => [
        GalleryState(isPhotoLoading: false, status: DownloadStatus.downloading), // Downloading
        GalleryState(isPhotoLoading: false, status: DownloadStatus.success, photos: [mockPhotos[0]]), // Success
      ],
      verify: (_) {
        verify(mockSaveGalleryPhotos(mockPhotos[0])).called(1);
      },
    );

    blocTest<GalleryBloc, GalleryState>(
      'emits [downloading, error] when DownloadPhotos event fails',
      build: () {
        when(mockSaveGalleryPhotos(mockPhotos[0]))
            .thenAnswer((_) async => Result.error(Exception('Error downloading photo')));
        return galleryBloc;
      },
      act: (bloc) => bloc.add(DownloadPhotos([mockPhotos[0].id])),
      expect: () => [
        GalleryState(isPhotoLoading: false, status: DownloadStatus.downloading), // Downloading
        GalleryState(isPhotoLoading: false, status: DownloadStatus.error, errorMessage: 'Error downloading photo'), // Error
      ],
      verify: (_) {
        verify(mockSaveGalleryPhotos(mockPhotos[0])).called(1);
      },
    );
  });

  tearDown(() {
    galleryBloc.close();
  });
}
