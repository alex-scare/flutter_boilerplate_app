import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/navigation/app_navigation.dart';

enum PageTransitionType {
  instant,
  cupertino,
  ;
}

class AppRoute {
  final RouteName name;
  final String path;
  final Widget Function(BuildContext, GoRouterState)? builder;
  final String? Function(BuildContext, GoRouterState)? redirectCheck;
  final PageTransitionType transitionType;

  /// Only for tab routes
  final String? label;

  /// Only for tab routes
  final IconData? icon;

  /// Only for tab routes
  final List<AppRoute> children;

  AppRoute({
    required this.name,
    required this.path,
    this.builder,
    this.redirectCheck,
    this.transitionType = PageTransitionType.cupertino,
    this.label,
    this.icon,
    this.children = const [],
  });

  GoRoute route(GlobalKey<NavigatorState>? key) => GoRoute(
        parentNavigatorKey: key,
        path: path,
        builder: builder,
        name: name.name,
        pageBuilder: _pageBuilder,
        routes: children.map((route) => route.route(key)).toList(),
        redirect: (context, state) {
          if (redirectCheck != null) {
            return redirectCheck?.call(context, state);
          }

          return null;
        },
      );

  Page Function(BuildContext, GoRouterState)? get _pageBuilder {
    return switch (transitionType) {
      PageTransitionType.cupertino => null,
      PageTransitionType.instant => (context, state) {
          return InstantTransitionPage(child: builder!(context, state));
        },
    };
  }
}

class InstantTransitionPage extends Page {
  final Widget child;

  InstantTransitionPage({required this.child}) : super(key: ValueKey(child));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return child;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return child;
      },
    );
  }
}
