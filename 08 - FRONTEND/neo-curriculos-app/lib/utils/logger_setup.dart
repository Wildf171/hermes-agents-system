import 'package:logger/logger.dart';

/// Setup logger configuration
void setupLogger() {
  Logger.level = Level.debug;
}

/// Get logger instance
Logger getLogger() {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}

/// Simple logger for screens
final appLogger = Logger(
  printer: SimplePrinter(printTime: true),
);
