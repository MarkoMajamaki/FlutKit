import 'package:flutter/material.dart';

class TabDefinition {
  final String route;
  final String text;
  final TabStyles style;
  final Widget Function(BuildContext context) buildPage;

  TabDefinition({
    this.style = TabStyles.text,
    required this.route,
    required this.text,
    required this.buildPage,
  });
}

enum TabStyles { text, outlined }
