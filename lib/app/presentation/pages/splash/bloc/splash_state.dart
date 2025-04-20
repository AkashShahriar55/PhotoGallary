sealed class SplashState{
  const SplashState();
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashInitializationInProgress extends SplashState {
  const SplashInitializationInProgress();
}

final class SplashInitializationSuccess extends SplashState {
  const SplashInitializationSuccess({required this.isPermissionGranted});
  final bool isPermissionGranted;
}

final class SplashInitializationFailure extends SplashState {
  const SplashInitializationFailure({required this.exception});
  final Exception exception;
}
