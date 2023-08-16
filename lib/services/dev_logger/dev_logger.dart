import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:template_app/services/file_system/file_system_service.dart';
import 'package:template_app/services/shared_preferences/shared_preferences.dart';

class AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class DevLogger {
  static const int _loggerGroupMinLength = 20;
  static var loggerEnabled = false;
  static final Future<Logger> _loggerFuture = _initLogger();
  final String group;

  DevLogger(this.group);

  static const String logFilePath = '/logs.txt';

  static Future<File> getFile() async {
    final dir = await FileSystemService.getDocumentsDirectory();
    final file = File('${dir.path}$logFilePath');
    if (!file.existsSync()) {
      file.createSync();
    }
    if (file.readAsLinesSync().length > 3000) {
      file.writeAsStringSync('');
    }
    return file;
  }

  static Future clearLogsFile() async {
    final file = await getFile();
    file.writeAsStringSync('');
  }

  static bool setLogEnabled(bool value) {
    loggerEnabled = value;
    SharedPreferencesService().setLoggerEnabled(value);

    return loggerEnabled;
  }

  Future<void> empty({lines = 1}) async {
    final logger = await _loggerFuture;
    if (!DevLogger.loggerEnabled) return;

    final message = '\n' * lines;
    logger.i(message, null, StackTrace.empty);
  }

  Future<void> infoWithDelimiters(String message) async {
    final logger = await _loggerFuture;
    if (!loggerEnabled) return;

    final date = DateTime.now().toIso8601String();
    final suffix = '-' * 10;
    final messageString = '$suffix$message$suffix'.padRight(70, '-');

    logger.i('$date $_groupName $messageString', null, StackTrace.empty);
  }

  Future<void> debug(String message) async {
    if (kDebugMode == false) return;

    final logger = await _loggerFuture;
    logger.d(_createMessage(message), null, StackTrace.empty);
  }

  Future<void> info(String message) async {
    final logger = await _loggerFuture;
    if (!DevLogger.loggerEnabled) return;

    logger.i(_createMessage(message), null, StackTrace.empty);
  }

  Future<void> warning(
    String message, [
    dynamic error,
    StackTrace stack = StackTrace.empty,
  ]) async {
    final logger = await _loggerFuture;
    if (!loggerEnabled) return;

    logger.w(_createMessage(message), error, stack);
  }

  Future<void> error(
    String message, [
    dynamic error,
    StackTrace stack = StackTrace.empty,
  ]) async {
    final logger = await _loggerFuture;
    if (!loggerEnabled) return;

    logger.e(_createMessage(message), error, stack);
  }

  Future<void> wtf(
    String message, [
    dynamic error,
    StackTrace stack = StackTrace.empty,
  ]) async {
    final logger = await _loggerFuture;
    if (!loggerEnabled) return;

    logger.wtf(_createMessage(message), error, stack);
  }

  static void _logFilePath(File file) {
    String link = 'file://${file.absolute.path}';
    String message = 'Logs file path (click to open file): $link';
    debugPrint(message);
  }

  static Future<Logger> _initLogger() async {
    final file = await getFile();
    _logFilePath(file);

    loggerEnabled = await SharedPreferencesService().isLoggerEnabled;

    return Logger(
      printer: PrettyPrinter(
        colors: false,
        printTime: false,
        noBoxingByDefault: true,
        printEmojis: true,
      ),
      filter: AppLogFilter(),
      output: MultiOutput(
        [
          FileOutput(file: file),
          kDebugMode ? ConsoleOutput() : null,
        ],
      ),
    );
  }

  String get _groupName {
    return group.length > _loggerGroupMinLength
        ? group
        : group.padRight(_loggerGroupMinLength, '.');
  }

  String _createMessage(String message) {
    final date = DateTime.now().toIso8601String();

    return '$date $_groupName $message';
  }
}
