import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_event.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_state.dart';
import 'package:photo_gallary/app/domain/usecase/fetch_gallery_photos.dart';
import 'package:photo_gallary/app/domain/usecase/save_gallery_photos.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/domain/result.dart';



// 1. Mock classes
class MockFetchGalleryPhotos extends Mock implements FetchGalleryPhotos {}
class MockSaveGalleryPhotos  extends Mock implements SaveGalleryPhotos {}

// 2. Fake photo for mocktail argument matching
class FakePhoto extends Fake implements Photo {}


void main() {
  // Register the fake so mocktail knows how to handle Photo args
  setUpAll(() {
    registerFallbackValue(FakePhoto());
  });

  late MockFetchGalleryPhotos mockFetchGalleryPhotos;
  late MockSaveGalleryPhotos  mockSaveGalleryPhotos;
  late GalleryBloc galleryBloc;

  setUp(() {
    mockFetchGalleryPhotos = MockFetchGalleryPhotos();
    mockSaveGalleryPhotos  = MockSaveGalleryPhotos();
    galleryBloc = GalleryBloc(
      mockFetchGalleryPhotos,
      mockSaveGalleryPhotos,
    );
  });

  group('GalleryBloc FetchPhotos', () {
    final tPhotos = [
      Photo(
        id: '1',
        uri: 'uri1',
        name: 'name1',
        path: 'path1',
        size: 100,
        width: 50,
        height: 50,
        orientation: 0,
      ),
    ];

    blocTest<GalleryBloc, GalleryState>(
      'emits [loading, success] when fetch succeeds',
      build: () {
        // Stub the use case to return our tPhotos
        when(() => mockFetchGalleryPhotos()).thenAnswer((_) async => Result.ok(tPhotos));
        return GalleryBloc(
          mockFetchGalleryPhotos,
          mockSaveGalleryPhotos,
        );
      },
      // No extra event needed; the constructor already fires FetchPhotos()
      act: (bloc) => bloc.add(const FetchPhotos()),
      expect: () => [
        // 1) loading: errorMessage cleared
        predicate<GalleryState>(
              (state) =>
          state.isPhotoLoading == true &&
              state.errorMessage == null &&
              state.photos.isEmpty,
          'loading state',
        ),
        // 2) success: loading false and photos populated
        predicate<GalleryState>(
              (state) =>
          state.isPhotoLoading == false &&
              state.errorMessage == null &&
              state.photos == tPhotos,
          'success state with photos',
        ),
      ],
    );
  });

  group('GalleryBloc FetchPhotos error', () {
    final exception = Exception('oops');

    blocTest<GalleryBloc, GalleryState>(
      'emits [loading, error] when fetch fails',
      build: () {
        when(() => mockFetchGalleryPhotos.call())
            .thenAnswer((_) async => Result.error(exception));
        return GalleryBloc(
          mockFetchGalleryPhotos,
          mockSaveGalleryPhotos,
        );
      },
      act: (bloc) => bloc.add(const FetchPhotos()),
      expect: () => [
        // loading state
        predicate<GalleryState>(
              (s) => s.isPhotoLoading == true && s.errorMessage == null,
          'loading',
        ),
        // error state
        predicate<GalleryState>(
              (s) =>
          s.isPhotoLoading == false &&
              s.errorMessage == exception.toString() &&
              s.photos.isEmpty,
          'error with message',
        ),
      ],
    );
  });



}
