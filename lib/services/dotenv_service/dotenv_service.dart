import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class DotenvService {
  static final _log = DevLogger('dotenv');

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');

    if (!dotenv.isEveryDefined(DotenvVariable.keys)) {
      _log.wtf('Missing required environment variables');
      // if you see this error, you need to create a .env file and fill it with the required variables
      throw Exception('Missing required environment variables');
    }
  }

  static String get(DotenvVariable variable) {
    return dotenv.get(variable.name, fallback: '');
  }
}

enum DotenvVariable {
  // JUST AN EXAMPLE
  openAiApiToken,
  ;

  String get key => switch (this) {
        openAiApiToken => 'OPEN_AI_API_TOKEN',
      };

  static List<String> get keys =>
      DotenvVariable.values.map((e) => e.key).toList();
}
