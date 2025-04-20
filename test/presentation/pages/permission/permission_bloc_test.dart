import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/permission/bloc/permission_state.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';

class MockPermissionManager extends Mock implements PermissionManager {}

void main() {
  late MockPermissionManager mockPermissionManager;

  setUp(() {
    mockPermissionManager = MockPermissionManager();
  });

  group('PermissionBloc', () {
    blocTest<PermissionBloc, PermissionState>(
      'emits [inProgress, success(true)] when permission granted',
      setUp: () {
        when(
              () => mockPermissionManager.checkAndRequestPhotoPermission(
            any(),
            shouldAddImage: any(named: 'shouldAddImage'),
          ),
        ).thenAnswer((_) async => true);
      },
      build: () => PermissionBloc(mockPermissionManager),
      expect: () => [
        isA<PermissionRequestInProgress>(),
        isA<PermissionRequestSuccess>()
            .having((s) => s.isPermissionGranted, 'isPermissionGranted', true),
      ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [inProgress, success(false)] when permission denied',
      setUp: () {
        when(
              () => mockPermissionManager.checkAndRequestPhotoPermission(
            any(),
            shouldAddImage: any(named: 'shouldAddImage'),
          ),
        ).thenAnswer((_) async => false);
      },
      build: () => PermissionBloc(mockPermissionManager),
      expect: () => [
        isA<PermissionRequestInProgress>(),
        isA<PermissionRequestSuccess>()
            .having((s) => s.isPermissionGranted, 'isPermissionGranted', false),
      ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits an error when permissionManager throws',
      setUp: () {
        when(
              () => mockPermissionManager.checkAndRequestPhotoPermission(
            any(),
            shouldAddImage: any(named: 'shouldAddImage'),
          ),
        ).thenThrow(Exception('oops'));
      },
      build: () => PermissionBloc(mockPermissionManager),
      errors: () => [isA<Exception>()],
    );
  });
}