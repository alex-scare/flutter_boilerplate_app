import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:template_app/core/navigation/app_navigation.dart';
import 'package:template_app/core/theme/theme.dart';
import 'package:template_app/features/app/global_error_handler.dart';
import 'package:template_app/features/app/global_loading_handler.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class App extends HookWidget {
  const App({super.key});
  static final log = DevLogger('root');

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        FlutterNativeSplash.remove();
        log.infoWithDelimiters('app started. splash removed');
        return null;
      },
      [],
    );

    return MaterialApp.router(
      title: 'Template app',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      locale: context.locale,
      builder: (context, child) =>
          GlobalErrorHandler(child: GlobalLoadingHandler(child: child!)),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: AppNavigation().router,
    );
  }
}
