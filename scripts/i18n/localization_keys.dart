import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

final parser = ArgParser()
  ..addOption(
    'source',
    abbr: 's',
    mandatory: true,
  )
  ..addOption(
    'output',
    abbr: 'o',
    mandatory: true,
  )
  ..addOption(
    'name',
    abbr: 'n',
    mandatory: false,
    defaultsTo: 'LocaleKey',
  )
  ..addOption(
    'omitPostfixSymbol',
    mandatory: false,
    defaultsTo: '!',
  )
  ..addOption(
    'ignoreKeysWithPostfixes',
    mandatory: false,
    defaultsTo: '.one,.other,.two,.few,.many',
  );

void main(List<String> args) {
  final arguments = parser.parse(args);

  generateKeys(
    arguments['source'],
    arguments['output'],
    className: arguments['name'],
    omitPostfixSymbol: arguments['omitPostfixSymbol'],
    ignorePostfixes: arguments['ignoreKeysWithPostfixes'].split(','),
  );
}

Map<String, dynamic> loadJson(String path) {
  final file = File(path);
  final contents = file.readAsStringSync();
  final json = jsonDecode(contents);
  if (json is Map<String, dynamic>) {
    return json;
  } else {
    throw FormatException('Invalid JSON in file: $path');
  }
}

void generateKeys(
  String jsonPath,
  String outputPath, {
  required String className,
  required String omitPostfixSymbol,
  required List<String> ignorePostfixes,
}) {
  final json = loadJson(jsonPath);
  final extractedKeys = extractKeys(
    json,
    omitPostfixSymbol: omitPostfixSymbol,
    ignorePostfixes: ignorePostfixes,
  );
  final generatedClass = generateClass(extractedKeys, className);

  writeFile(generatedClass, outputPath);
}

void writeFile(String content, String outputPath) {
  final file = File(outputPath);

  String output = content;
  file.writeAsStringSync(output);
}

Set<String> extractKeys(
  Map<String, dynamic> json, {
  String prefix = '',
  required List<String> ignorePostfixes,
  required String omitPostfixSymbol,
}) {
  final keys = <String>{};
  json.forEach((key, value) {
    final fullKey = prefix.isNotEmpty ? '$prefix.$key' : key;
    if (value is Map<String, dynamic>) {
      keys.addAll(
        extractKeys(
          value,
          prefix: fullKey,
          omitPostfixSymbol: omitPostfixSymbol,
          ignorePostfixes: ignorePostfixes,
        ),
      );
    } else {
      if (ignorePostfixes.any((element) => fullKey.endsWith(element))) {
        return;
      }

      final value = fullKey.contains(omitPostfixSymbol)
          ? fullKey.substring(0, fullKey.indexOf(omitPostfixSymbol))
          : fullKey;
      keys.add(value);
    }
  });
  return keys;
}

String generateClass(Set<String> keys, String className) {
  final buffer = StringBuffer();

  buffer.writeln('class $className {');
  buffer.writeln('  const $className();');
  for (final key in keys) {
    final fieldName = key.replaceAll(RegExp(r'[^\w]+'), '_').toCamelCase();
    buffer.writeln('  static const $fieldName = \'$key\';');
  }
  buffer.writeln('}');

  return buffer.toString();
}

extension StringExtension on String {
  String get camelCase => splitMapJoin(
        RegExp(r'(?:^|_)(.)'),
        onMatch: (Match match) => match.group(1)!.toUpperCase(),
        onNonMatch: (String nonMatch) => '',
      );

  String toCamelCase() {
    List<String> parts = split('_');
    String result = '';

    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];

      if (i > 0) {
        result += part.substring(0, 1).toUpperCase() + part.substring(1);
      } else {
        result += part;
      }
    }

    return result;
  }
}
