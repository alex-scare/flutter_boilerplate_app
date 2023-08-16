import 'dart:io';

import 'package:isar/isar.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';
import 'package:template_app/services/file_system/file_system_service.dart';

const List<CollectionSchema> _isarSchemas = [
  // place your schemas here
];

class IsarService {
  static const isarDirName = 'isar';
  final _log = DevLogger('isar');

  // singleton boilerplate
  static final IsarService _singleton = IsarService._internal();
  factory IsarService() => _singleton;
  IsarService._internal() {
    isar = _initIsar();
  }
  // end singleton boilerplate

  late Future<Isar> isar;

  Future<Isar> _initIsar() async {
    final dir = await FileSystemService.getDocumentsDirectory();
    final isarDir = Directory('${dir.path}/$isarDirName');

    if (!isarDir.existsSync()) {
      isarDir.createSync();
    }

    _log.info('service started');
    return Isar.openSync(_isarSchemas, directory: isarDir.path);
  }
}
