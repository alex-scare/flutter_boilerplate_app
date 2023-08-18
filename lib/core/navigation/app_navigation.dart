import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/navigation/app_navigation_observers.dart';
import 'package:template_app/core/navigation/app_route.dart';
import 'package:template_app/core/navigation/tab_navigation_scaffold.dart';
import 'package:template_app/features/home/home_screen.dart';
import 'package:template_app/features/settings/settings_screen.dart';

enum RouteName {
  initial,
  home,
  settings,
  ;

  String get path => switch (this) {
        initial => '/',
        home => '/home',
        settings => '/settings',
      };
}

class AppNavigation {
  // singleton boilerplate
  static final AppNavigation _singleton = AppNavigation._internal();
  factory AppNavigation() => _singleton;
  AppNavigation._internal();
  // end singleton boilerplate

  GlobalKey<NavigatorState> tabRouteKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> globalRouteKey = GlobalKey<NavigatorState>();

  GoRouter? _router;
  GoRouter get router => _router ??= _createRouter();

  GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: globalRouteKey,
      observers: [AppNavigationObserver()],
      initialLocation: RouteName.initial.path,
      routes: [
        ...routes.map((route) => route.route(globalRouteKey)).toList(),
        ShellRoute(
          navigatorKey: tabRouteKey,
          observers: [AppNavigationObserver()],
          routes: tabRoutes.map((route) => route.route(tabRouteKey)).toList(),
          builder: (context, state, child) {
            return TabNavigationScaffold(
              location: state.uri.path,
              routes: tabRoutes,
              child: child,
            );
          },
        ),
      ],
    );
  }

  final List<AppRoute> routes = [
    AppRoute(
      name: RouteName.initial,
      path: RouteName.initial.path,
      redirectCheck: (_, __) => RouteName.home.path,
    ),
  ];

  final List<AppRoute> tabRoutes = [
    AppRoute(
      name: RouteName.home,
      path: RouteName.home.path,
      icon: Icons.home,
      transitionType: PageTransitionType.instant,
      builder: (_, __) => const HomeScreen(),
    ),
    AppRoute(
      name: RouteName.settings,
      path: RouteName.settings.path,
      icon: Icons.settings,
      transitionType: PageTransitionType.instant,
      builder: (_, __) => const SettingsScreen(),
    ),
  ];

  void showModal(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    required String name,
  }) {
    showModalBottomSheet(
      context: context,
      builder: builder,
      routeSettings: RouteSettings(name: name),
    );
  }

  void showFlexibleModal(
    BuildContext context, {
    required Widget Function(BuildContext, ScrollController) builder,
    List<double>? anchors,
    double? maxHeight,
    double? minHeight,
    double? initHeight,
    Color backgroundColor = Colors.transparent,
  }) {
    showFlexibleBottomSheet(
      context: context,
      useRootNavigator: true,
      initHeight: initHeight,
      anchors: anchors,
      maxHeight: maxHeight,
      minHeight: minHeight,
      bottomSheetColor: backgroundColor,
      builder: (context, scrollController, ___) {
        return builder(context, scrollController);
      },
    );
  }

  void closeModal(BuildContext context) {
    context.navigateBack();
  }
}

extension ContextNavigationExt on BuildContext {
  void navigateBack() {
    if (!Navigator.of(this).canPop()) return;

    Navigator.of(this).pop();
  }
}
