// Load csv file and wrap all values with "

import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';

final parser = ArgParser()
  ..addOption(
    'source',
    abbr: 's',
    mandatory: true,
  );

void main(List<String> args) {
  final arguments = parser.parse(args);

  updateCsv(arguments['source']);
}

void updateCsv(String filePath) {
  final File file = File(filePath);

  final String csv = file.readAsStringSync();

  List<List<String>> rows = const CsvToListConverter().convert(csv, eol: '\n');

  final newLines = rows.map((values) {
    final newValues = values.skip(1).map((value) => processValue(value));
    return [values[0], ...newValues].join(',');
  });

  file.writeAsStringSync(newLines.join('\n'));
}

String processValue(String value) {
  return wrapWithQuotes(value.trim());
}

String wrapWithQuotes(String value) {
  if (value.startsWith('"') && value.endsWith('"')) {
    return value;
  }
  return '"$value"';
}
