import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class FileSystemService {
  static final _log = DevLogger('FileSystemService');

  static Directory? _appSupportDirectory;
  static Directory? _appDocumentsDirectory;
  static Directory? _appTemporaryDirectory;

  static Future<Directory> getSupportDirectory() async {
    return _appSupportDirectory ??= await getApplicationSupportDirectory();
  }

  static Future<Directory> getDocumentsDirectory() async {
    return _appDocumentsDirectory ??= await getApplicationDocumentsDirectory();
  }

  static Future<Directory> getAppTemporaryDirectory() async {
    return _appTemporaryDirectory ??= await getTemporaryDirectory();
  }

  static Future<void> shareFile(File file) async {
    try {
      final String fileName = file.path.split('/').last;

      ShareResult shareResult;
      final files = <XFile>[];
      files.add(XFile(file.path, name: fileName));

      shareResult = await Share.shareXFiles(files);
      if (shareResult.status == ShareResultStatus.unavailable) {
        _log.error(
          'download error: file not found $fileName',
          null,
          StackTrace.current,
        );
      }
    } on PlatformException catch (e, stack) {
      _log.error('platform error: file download error', e, stack);
    }
  }

  static Future<File?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        return file;
      }
    } on PlatformException catch (e, stack) {
      _log.error('platform error: file pick error', e, stack);
    }
    return null;
  }
}
