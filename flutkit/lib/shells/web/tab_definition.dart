import 'package:flutter/material.dart';

class TabDefinition {
  final String route;
  final Widget Function(BuildContext context) buildAppBarWidget;
  final Widget Function(BuildContext context)? buildSideBarWidget;

  TabDefinition({
    required this.route,
    required this.buildAppBarWidget,
    this.buildSideBarWidget,
  });
}
