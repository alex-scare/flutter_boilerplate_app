import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';

final parser = ArgParser()
  ..addOption(
    'source',
    abbr: 's',
    mandatory: true,
  )
  ..addOption(
    'outputDir',
    abbr: 'o',
    mandatory: true,
  );

void main(List<String> args) {
  final arguments = parser.parse(args);

  createJsons(arguments['source'], arguments['outputDir']);
}

void createJsons(String source, String outputDir) {
  // Read the CSV file into memory
  String csv = File(source).readAsStringSync();

  // Parse the CSV into a list of rows
  List<List<String>> rows = const CsvToListConverter().convert(csv, eol: '\n');

  // Extract the header row and locale directories
  List<String> header = rows[0];
  List<String> localeFiles = header.sublist(1);

  // Iterate over other rows to create a map of JSON keys and values for each locale
  Map<String, Map<String, String>> localeMap = {};
  for (int i = 1; i < rows.length; i++) {
    List<String> row = rows[i];

    String key = row[0];
    for (int j = 1; j < row.length; j++) {
      String value = row[j];

      String directory = localeFiles[j - 1];
      Map<String, String> localeValues = localeMap[directory] ?? {};
      localeValues[key] = value.replaceAll('\\n', '\n');
      localeMap[directory] = localeValues;
    }
  }

  // Create a JSON file for each directory with its values
  for (String localeFile in localeFiles) {
    Map<String, String> localeValues = localeMap[localeFile] ?? {};

    final fileName = '$outputDir/$localeFile.json';
    final file = File(fileName);
    file.writeAsStringSync(jsonEncode(unFlattenJson(localeValues)));

    // ignore: avoid_print
    print('$localeFile conversion complete.');
  }
}

// Function to transform a map of flattened JSON keys and values back into a nested JSON object
Map<dynamic, dynamic> unFlattenJson(Map<String, String> flattenedMap) {
  Map<dynamic, dynamic> nestedJson = {};
  flattenedMap.forEach((key, value) {
    List<String> keyParts = key.split('.');
    Map<dynamic, dynamic> currentJson = nestedJson;
    for (int i = 0; i < keyParts.length - 1; i++) {
      String part = keyParts[i];
      currentJson = currentJson[part] ??= {};
    }
    currentJson[keyParts.last] = value;
  });
  return nestedJson;
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

void generateKeysForFile(String path, StringBuffer buffer) {
  final json = loadJson(path);

  for (final sectionKey in json.keys) {
    final section = json[sectionKey] as Map<String, dynamic>;

    for (final key in section.keys) {
      buffer.writeln(
        '  static const $sectionKey${key.camelCase} = \'$sectionKey:$key\';',
      );
    }
  }
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
      String part = parts[i];
      if (i > 0) {
        result += part.substring(0, 1).toUpperCase() + part.substring(1);
      } else {
        result += part;
      }
    }

    return result;
  }
}
