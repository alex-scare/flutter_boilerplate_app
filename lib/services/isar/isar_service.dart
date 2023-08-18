import 'dart:io';

import 'package:isar/isar.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';
import 'package:template_app/services/file_system/file_system_service.dart';

const List<CollectionSchema> _isarSchemas = [
  // place your schemas here
];

class IsarService {
  final _log = DevLogger('isar');
  static const _isarFileName = 'isar_db';
  static const isarDirName = 'isar';

  // singleton boilerplate
  static final IsarService _singleton = IsarService._internal();
  factory IsarService() => _singleton;
  IsarService._internal() {
    isar = _initIsar();
  }
  // end singleton boilerplate

  late Future<Isar> isar;

  Future<Isar> _initIsar([File? file]) async {
    final dir = await FileSystemService.getDocumentsDirectory();
    final isarDir = Directory('${dir.path}/$isarDirName');
    final isarFilePath = '${isarDir.path}/$_isarFileName.isar';

    if (file != null) {
      File(isarFilePath).writeAsBytesSync(file.readAsBytesSync());
    }

    if (!isarDir.existsSync()) {
      isarDir.createSync();
    }

    _log.info('service started');
    return Isar.openSync(
      _isarSchemas,
      directory: isarDir.path,
      name: _isarFileName,
    );
  }

  Future<void> shareBackupFile() async {
    final dir = await FileSystemService.getAppTemporaryDirectory();
    final file = File('${dir.path}/$_isarFileName.isar');

    if (file.existsSync()) {
      file.deleteSync();
    }

    final isar = await this.isar;
    await isar.copyToFile(file.path);

    await FileSystemService.shareFile(file);
    file.delete();
  }

  Future<void> restoreFromFile() async {
    final file = await FileSystemService.pickFile();

    if (file == null) return;

    await (await isar).close();
    isar = _initIsar(file);
  }
}
