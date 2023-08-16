import 'dart:io';

import 'package:googleapis/translate/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

// ignore: avoid_print
void log(String string) => print(string);

const googleKeyFilePath = 'google_api_key.json';

class LocaleGoogleCloudService {
  late String projectName;
  late TranslateApi _translateApi;
  bool initiated = false;

  Future<void> init(String projectName) async {
    this.projectName = projectName;

    final json = await File(googleKeyFilePath).readAsString();
    final accountCredentials = ServiceAccountCredentials.fromJson(json);

    AuthClient client = await clientViaServiceAccount(accountCredentials, [
      TranslateApi.cloudTranslationScope,
    ]);

    _translateApi = TranslateApi(client);
    initiated = true;
  }

  Future<List<String?>> basicTranslate(
    List<String> content, {
    required String targetLang,
    required String sourceLang,
  }) async {
    final request = TranslateTextRequest(
      contents: content,
      sourceLanguageCode: sourceLang,
      targetLanguageCode: targetLang,
    );

    try {
      final res = await _translateApi.projects.locations
          .translateText(request, 'projects/$projectName/locations/global');

      return Future.value(
        res.translations?.map((e) => e.translatedText).toList() ?? [],
      );
    } catch (e) {
      log(
        [
          'Error translation from $sourceLang to $targetLang:',
          'content: $content',
          'error: $e'
        ].join('\n\n'),
      );
      return []..fillRange(0, content.length);
    }
  }

  Future<List<String?>> translateFromEn(
    List<String> texts, {
    required String target,
  }) async {
    return await basicTranslate(
      texts,
      targetLang: target,
      sourceLang: 'en',
    );
  }

  Future<List<String>> chunkTranslationFromEn(
    List<String> content,
    String lang, {
    int limit = 128,
  }) async {
    final List<String> allTranslations = [];

    log('$lang: started translation ${content.length} items');

    for (var currentOffset = 0;
        currentOffset < content.length;
        currentOffset += limit) {
      final portionToTranslate =
          content.skip(currentOffset).take(limit).toList();

      try {
        final translations = await translateFromEn(
          portionToTranslate,
          target: lang,
        );

        allTranslations.addAll(translations.cast());
        log('$lang: translated ${allTranslations.length} items');
      } catch (e) {
        currentOffset = content.length;
      }
    }

    log('$lang: finished. translated ${allTranslations.length}');

    return Future.value(allTranslations);
  }
}
