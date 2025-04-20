import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/splash/bloc/splash_state.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';

class MockPermissionManager extends Mock implements PermissionManager {}

void main() {
  late MockPermissionManager mockPermissionManager;

  setUp(() {
    mockPermissionManager = MockPermissionManager();
  });

  group('SplashBloc', () {
    blocTest<SplashBloc, SplashState>(
      'emits [SplashInitializationSuccess(true)] when permission granted',
      build: () {
        when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
            .thenAnswer((_) async => true);
        return SplashBloc(mockPermissionManager);
      },
      wait: const Duration(seconds: 3), // wait for the built-in delay
      expect: () => <Matcher>[
        isA<SplashInitializationSuccess>()
            .having((s) => s.isPermissionGranted, 'isPermissionGranted', true),
      ],
    );

    blocTest<SplashBloc, SplashState>(
      'emits [SplashInitializationSuccess(false)] when permission denied',
      build: () {
        when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
            .thenAnswer((_) async => false);
        return SplashBloc(mockPermissionManager);
      },
      wait: const Duration(seconds: 3),
      expect: () => <Matcher>[
        isA<SplashInitializationSuccess>()
            .having((s) => s.isPermissionGranted, 'isPermissionGranted', false),
      ],
    );

    blocTest<SplashBloc, SplashState>(
      'throws when permissionManager throws',
      build: () {
        when(() => mockPermissionManager.checkAndRequestPhotoPermission(false))
            .thenThrow(Exception('oops'));
        return SplashBloc(mockPermissionManager);
      },
      wait: const Duration(seconds: 3),
      errors: () => [isA<Exception>()],
    );
  });
}