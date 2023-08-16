import 'package:csv/csv.dart';

const converterToCsv = ListToCsvConverter();
const converterToList = CsvToListConverter();

class LocaleCsvEntity {
  final String key;
  final String en;
  final Map<String, String> translations;

  LocaleCsvEntity({
    required this.key,
    required String en,
    required this.translations,
  }) : en = en.trim();

  factory LocaleCsvEntity.fromCsv(String csv, List<String> languages) {
    List<List<String>> rows = converterToList.convert(csv, eol: '\n');

    final values = rows[0]..addAll(List.filled(13 - rows[0].length, ''));
    final translations =
        languages.asMap().map((key, value) => MapEntry(value, values[key + 2]));

    return LocaleCsvEntity(
      key: values[0],
      en: values[1],
      translations: translations,
    );
  }

  String get csv {
    final values = [key, en, ...translations.values];
    return converterToCsv.convertSingleRow(StringBuffer(), values) ?? '';
  }

  String get csvEn {
    return [key, en, ...translations.values].join(',');
  }

  String? getTranslation(String lang) {
    final res = translations[lang];
    return res == null || res.isEmpty ? null : res;
  }

  void setTranslation(String? text, String lang) {
    final preparedValue = addPlaceholders(text ?? '');

    translations[lang] = preparedValue;
  }

  dynamic removePlaceholders(String value) {
    return Injection.replaceToValues(value);
  }

  dynamic addPlaceholders(String value) {
    return Injection.replaceToCsv(value);
  }
}

class Injection {
  final String injection;
  final String replacer;

  Injection(this.injection, this.replacer);

  static Injection get lang => Injection('{lang}', '#1#');
  static Injection get min => Injection('{min}', '#2#');
  static Injection get max => Injection('{max}', '#3#');
  static Injection get value => Injection('{value}', '#4#');

  static List<Injection> get injections => [lang, min];

  static String replaceToCsv(String value) => injections.fold(
        value,
        (acc, cur) => acc.replaceAll(cur.replacer, cur.injection),
      );

  static String replaceToValues(String value) => injections.fold(
        value,
        (acc, cur) => acc.replaceAll(cur.injection, cur.replacer),
      );
}
