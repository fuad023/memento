import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const MyAppBar({
    super.key,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return AppBar(
      title: Text(title),
      centerTitle: true,
      foregroundColor: Theme.of(context).colorScheme.primary,
      // elevation: 0.0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}