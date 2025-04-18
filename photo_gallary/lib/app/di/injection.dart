

import 'package:get_it/get_it.dart';
import 'package:photo_gallary/app/core/utils/permission_manager.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerLazySingleton<PermissionManager>(() => PermissionHandlerManager());
}