import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class I18nService {
  static final _log = DevLogger('i18n');

  static final I18nService _singleton = I18nService._internal();
  factory I18nService() => _singleton;
  I18nService._internal() {
    _initCustomLogger();
  }

  void _initCustomLogger() {
    EasyLocalization.logger.printer = (
      Object object, {
      name,
      StackTrace? stackTrace,
      level,
    }) {
      switch (level.toString()) {
        case 'LevelMessages.error':
          _log.error(object.toString(), null, stackTrace ?? StackTrace.empty);
          return;
        case 'LevelMessages.warning':
          _log.warning(object.toString(), null, stackTrace ?? StackTrace.empty);
          return;
        case 'LevelMessages.info':
          // _log.info(object.toString());
          return;
        case 'LevelMessages.debug':
          // _log.debug(object.toString());
          return;
        default:
          return;
      }
    };
  }

  static const (String, String) _en = ('en', 'US');
  // static const (String, String) _ru = ('ru', 'RU');
  // static const (String, String) _de = ('de', 'DE');

  static const (String, String) defaultLocaleString = _en;

  static const List<(String, String)> supportedLocaleStrings = [
    _en,
  ];

  String basePath = 'assets/translations';

  Locale get defaultLocale =>
      Locale(defaultLocaleString.$1, defaultLocaleString.$2);
  List<Locale> get supportedLocales =>
      supportedLocaleStrings.map((e) => Locale(e.$1, e.$2)).toList();
}
