import 'package:flutter/material.dart';

class TabShellPage extends Page {
  final Widget child;

  TabShellPage({
    required this.child,
  }) : super(key: ValueKey(child));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: Duration.zero,
      pageBuilder: (_, anime1, anime2) => child,
    );
  }
}
