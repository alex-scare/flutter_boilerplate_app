import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template_app/core/theme/text_theme.dart';

class AppTheme {
  static const pageTransition = PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  );

  static FlexScheme schemeColor = FlexScheme.aquaBlue;

  static const overlayStyleLight = SystemUiOverlayStyle.light;

  static final light = FlexThemeData.light(
    scheme: FlexScheme.ebonyClay,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useM2StyleDividerInM3: true,
      defaultRadius: 4.0,
      inputDecoratorIsFilled: false,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      segmentedButtonSchemeColor: SchemeColor.primaryContainer,
      segmentedButtonRadius: 8.0,
    ),
    textTheme: textTheme,
    pageTransitionsTheme: pageTransition,
  );
}

extension AppThemeHelper on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get texts => theme.textTheme;
}
