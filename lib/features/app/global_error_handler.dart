import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:template_app/core/navigation/app_navigation.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class GlobalErrorHandler extends StatefulWidget {
  const GlobalErrorHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GlobalErrorHandler> createState() => _GlobalErrorHandlerState();
}

class _GlobalErrorHandlerState extends State<GlobalErrorHandler> {
  static final _log = DevLogger('GLOBAL_ERROR');

  @override
  void initState() {
    super.initState();

    FlutterError.onError = (error) {
      final routeState = AppNavigation().globalRouteKey.currentState;
      final page = routeState?.widget.pages.last.name ?? '';
      final message = 'flutter error! Lib: "${error.library}". Screen: "$page"';
      _log.wtf(message, error.exception, error.stack ?? StackTrace.empty);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      final routeState = AppNavigation().globalRouteKey.currentState;
      final page = routeState?.widget.pages.last.name ?? '';
      final message = 'platform error! Screen: "$page"';
      _log.wtf(message, error, stack);

      return true;
    };
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
