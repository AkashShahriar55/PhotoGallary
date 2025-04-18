
import 'package:logger/logger.dart';

class Log {
  // Singleton instance
  static final Log _instance = Log._internal();

  final _logger = Logger();
  factory Log() {
    return _instance;
  }

  Log._internal();

  void d(String message) {
    _logger.d(message, time: DateTime.now());
  }

  void e(String message, {StackTrace? stackTrace, String? name}) {
    _logger.e(message, stackTrace: stackTrace, time: DateTime.now());
  }

  void i(String message) {
    _logger.i(message, time: DateTime.now());
  }

  void w(String message) {
    _logger.w(message, time: DateTime.now());
  }

  void wtf(String message) {
    _logger.wtf(message, time: DateTime.now());
  }

  void v(String message) {
    _logger.v(message, time: DateTime.now());
  }


}