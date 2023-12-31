import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:template_app/core/theme/theme.dart';
import 'package:template_app/features/app/app.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';
import 'package:template_app/services/dotenv_service/dotenv_service.dart';
import 'package:template_app/services/i18n/global_i18n_handler.dart';
import 'package:template_app/services/i18n/i18n_service.dart';

final log = DevLogger('root');

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  log.empty();
  log.infoWithDelimiters('app starting');

  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyleLight);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DotenvService.load();
  await I18nService.init();

  runApp(const ProviderScope(child: GlobalI18nHandler(child: App())));
}
