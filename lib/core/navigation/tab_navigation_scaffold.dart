import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/navigation/app_route.dart';
import 'package:template_app/core/theme/theme.dart';

class TabNavigationScaffold extends HookWidget {
  const TabNavigationScaffold({
    Key? key,
    required this.child,
    required this.location,
    required this.routes,
  }) : super(key: key);

  final Widget child;
  final String location;
  final List<AppRoute> routes;

  @override
  Widget build(BuildContext context) {
    var currentIndex = useState(
      routes.indexWhere((element) => element.path == location),
    );

    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: context.colors.background,
        border: Border(
          top: BorderSide(color: context.colors.onBackground, width: 3),
        ),
        iconSize: 24,
        currentIndex: currentIndex.value,
        onTap: (int index) {
          final route = routes[index];

          currentIndex.value = index;
          context.goNamed(route.name.name);
        },
        items: routes
            .map(
              (route) => _comicStyleTab(
                context,
                route.tab,
                route == routes[currentIndex.value],
              ),
            )
            .toList(),
      ),
      body: child,
    );
  }

  BottomNavigationBarItem _comicStyleTab(
    BuildContext context,
    BottomNavigationBarItem tab,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
        child: tab.icon,
      ),
      label: tab.label,
    );
  }
}

extension TabRoute on AppRoute {
  BottomNavigationBarItem get tab {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 30.0),
      label: label ?? '',
    );
  }
}
