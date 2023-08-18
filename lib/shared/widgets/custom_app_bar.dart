import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
  });

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
