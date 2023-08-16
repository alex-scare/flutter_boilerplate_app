import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';
import 'package:template_app/services/file_system/file_system_service.dart';

final _log = DevLogger('isar');
const isarDirName = 'isar';

const List<CollectionSchema> _isarSchemas = [
  // place your schemas here
];

final FutureProvider<Isar> isarPod = FutureProvider((ref) async {
  final dir = await FileSystemService.getDocumentsDirectory();
  final isarDir = Directory('${dir.path}/$isarDirName');

  if (!isarDir.existsSync()) {
    isarDir.createSync();
  }

  final isar = Isar.openSync(_isarSchemas, directory: isarDir.path);

  _log.info('service started');
  return isar;
});
