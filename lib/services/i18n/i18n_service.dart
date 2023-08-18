import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class I18nService {
  static final _log = DevLogger('i18n');
  static const String basePath = 'assets/translations';

  static Locale get defaultLocale => const Locale('en', 'US');

  static List<Locale> supportedLocales = [defaultLocale];

  static Future<void> init() async {
    _configureLogger();

    supportedLocales = await _loadAvailableLocales();
    await EasyLocalization.ensureInitialized();
  }

  static void _configureLogger() {
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

  static Future<List<Locale>> _loadAvailableLocales() async {
    final source =
        await rootBundle.loadString('assets/translations/source.csv');

    final localesStrings = source.split('\n').first.split(',').skip(1);
    final pattern = RegExp(r'^"[a-z]{2}-[A-Z]{2}"$');

    if (localesStrings.any((str) => !pattern.hasMatch(str))) {
      throw 'At least one of locales in source.csv has incorrect pattern';
    }

    return localesStrings.map((locale) {
      final [languageCode, countryCode] = locale.substring(1, 6).split('-');
      return Locale(languageCode, countryCode);
    }).toList();
  }
}
