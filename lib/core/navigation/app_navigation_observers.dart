import 'package:flutter/cupertino.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';

class AppNavigationObserver extends NavigatorObserver {
  final _log = DevLogger('navigation');

  void logUpdate(String prefix, Route? toRoute, Route? fromRoute) {
    final newRouteName = toRoute?.settings.name ?? 'Unknown';
    final prevRouteName = fromRoute?.settings.name ?? 'Unknown';
    final stack = navigator!.widget.pages.map((route) => route.name).join(', ');
    final routeKey = navigator!.widget.key;
    final additionalInfo = 'stack: [$stack], key: $routeKey';

    _log.info('$prefix: $prevRouteName -> $newRouteName. $additionalInfo');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    logUpdate('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    logUpdate('pop', previousRoute, route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    logUpdate('remove', previousRoute, route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    logUpdate('replace', newRoute, oldRoute);
  }
}
