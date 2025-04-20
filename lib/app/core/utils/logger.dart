
import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();
  late Logger _logger;

  factory Log() {
    return _instance;
  }

  Log._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2,
          // number of method calls to be displayed
          errorMethodCount: 8,
          // number of method calls if stacktrace is provided
          lineLength: 120,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: true,
          // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
      ),
    );
  }

  static void d(String message) {
    _instance._logger.d(message, time: DateTime.now());
  }

  static void e(String message, {StackTrace? stackTrace, String? name}) {
    _instance._logger.e(message, stackTrace: stackTrace, time: DateTime.now());
  }

  static void i(String message) {
    _instance._logger.i(message, time: DateTime.now());
  }

  static void w(String message) {
    _instance._logger.w(message, time: DateTime.now());
  }

  static void wtf(String message) {
    _instance._logger.wtf(message, time: DateTime.now());
  }

  static void v(String message) {
    _instance._logger.v(message, time: DateTime.now());
  }


}