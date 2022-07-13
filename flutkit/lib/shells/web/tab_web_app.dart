import 'package:flutter/material.dart';

import 'tab_definition.dart';
import 'tab_shell_app_router_delegate.dart';
import 'tab_shell_route_information_parser.dart';

class TabWebApp extends StatelessWidget {
  const TabWebApp({
    Key? key,
    this.theme,
    required this.tabDefinitions,
    this.logo,
    this.bodyMaxWidth,
  }) : super(key: key);

  // App theme
  final ThemeData? theme;

  // Build tab button to appbar
  final List<TabDefinition> tabDefinitions;

  // Logo on top left
  final Widget? logo;

  // App body max width
  final double? bodyMaxWidth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerDelegate: TabShellAppRouterDelegate(tabDefinitions),
      routeInformationParser: TabShellRouteInformationParser(),
    );
  }
}
