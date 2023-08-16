import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:template_app/shared/extensions/list.dart';

import 'models/locale_csv_entity.dart';
import 'services/locale_gcloud.dart';

final api = LocaleGoogleCloudService();

// ignore: avoid_print
void log(String string) => print(string);

final parser = ArgParser()
  ..addOption(
    'source',
    abbr: 's',
    mandatory: true,
  )
  ..addOption(
    'ignoreLinesWith',
    mandatory: false,
    defaultsTo: '!,common.time',
  )
  ..addOption(
    'g_cloud_app_name',
    mandatory: true,
  );

void main(args) async {
  final arguments = parser.parse(args);

  await api.init(arguments['g_cloud_app_name']);

  final csvFile = File(arguments['source']);
  final csv = await csvFile.readAsString();

  List<List<String>> rows = const CsvToListConverter().convert(csv, eol: '\n');
  final languages = rows.first.skip(2).toList();
  final content = rows.skip(1);

  final translated = await processEntities(
    languages,
    content
        .map((e) => LocaleCsvEntity.fromCsv(e.join(','), languages))
        .toList(),
    (arguments['ignoreLinesWith'] as String).split(','),
  );

  var file = File(arguments['source']);
  await file.writeAsString(toCsv(csv, translated.values.toList()));
}

Future<Map<String, LocaleCsvEntity>> processEntities(
  List<String> languages,
  List<LocaleCsvEntity> entities,
  List<String> ignoreWith,
) async {
  final Map<String, LocaleCsvEntity> result =
      entities.asMap().map((key, value) => MapEntry(value.key, value));

  Future<void> translateToLang(
    String lang,
  ) async {
    final list = result.values.toList();
    final withTranslations = await translateContent(list, lang, ignoreWith);

    for (var el in withTranslations) {
      if (el.getTranslation(lang) == null) continue;
      result[el.key]!.setTranslation(el.getTranslation(lang), lang);
    }
  }

  // translate for languages from csv header
  for (var lang in languages) {
    if (lang == 'en-US') continue;

    await translateToLang(lang);
  }

  return Future.value(result);
}

Future<List<LocaleCsvEntity>> translateContent(
  List<LocaleCsvEntity> list,
  String lang,
  List<String> ignoreWith,
) async {
  List<LocaleCsvEntity> needTranslate = list.where((entity) {
    if (ignoreWith
        .any((element) => entity.translations.keys.contains(element))) {
      return false;
    }
    return entity.getTranslation(lang) == null;
  }).toList();

  if (needTranslate.isEmpty) {
    log('$lang: nothing to translate');
    return [];
  }

  log(
    [
      '$lang: Started translation.',
      'Need to translate ${needTranslate.length} entities'
    ].join(' '),
  );

  // ignore: avoid_print
  print(needTranslate.map((e) => e.key));

  List<String> results = await api.chunkTranslationFromEn(
    needTranslate.map((e) => e.en).toList(),
    lang,
    limit: 10,
  );

  needTranslate.forEachWithIndex((e, index) {
    if (index >= results.length) return;

    e.setTranslation(results[index], lang);
  });

  return Future.value(needTranslate);
}

String toCsv(String source, List<LocaleCsvEntity> list) {
  final header = source.split('\n').first;
  return list.fold(header, (acc, cur) => [acc, cur.csv].join('\n'));
}
