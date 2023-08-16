import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:template_app/services/i18n/i18n_service.dart';

class GlobalI18nHandler extends StatelessWidget {
  const GlobalI18nHandler({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: I18nService().supportedLocales,
      fallbackLocale: I18nService().defaultLocale,
      path: I18nService().basePath,
      child: child,
    );
  }
}
