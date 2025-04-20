import 'package:photo_gallary/app/domain/result.dart';

abstract class BaseUserCase<T, Params> {
  Future<Result<T>> call(Params params);
}