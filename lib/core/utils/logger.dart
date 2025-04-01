import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A utility class for consistent logging across the app.
/// Uses both print statements for immediate terminal visibility
/// and developer.log for more detailed debugging information.
class Logger {
  /// Log an informational message
  /// 
  /// [tag] identifies the source/category of the log
  /// [message] is the actual log message
  static void info(String tag, String message) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] 💡 [$tag] $message');
    developer.log(
      message,
      name: tag,
      time: DateTime.now(),
    );
  }

  /// Log an error message
  /// 
  /// [tag] identifies the source/category of the log
  /// [message] is the error message
  /// [error] optional error object for additional details
  static void error(String tag, String message, [dynamic error]) {
    final timestamp = DateTime.now().toIso8601String();
    final errorMsg = '$message${error != null ? '\nError: $error' : ''}';
    debugPrint('[$timestamp] ❌ [$tag] $errorMsg');
    developer.log(
      errorMsg,
      name: tag,
      time: DateTime.now(),
      level: 1000, // Error level
    );
  }
}
