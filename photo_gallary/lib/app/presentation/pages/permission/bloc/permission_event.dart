import 'package:photo_gallary/app/core/utils/permission_manager.dart';

sealed class PermissionEvent{}

final class PhotoPermissionRequest extends PermissionEvent {}

