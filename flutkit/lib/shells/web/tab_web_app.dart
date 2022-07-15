import 'package:flutter/material.dart';

import 'tab_definition.dart';
import 'tab_shell_app_router_delegate.dart';
import 'tab_shell_route_information_parser.dart';

class TabWebApp extends StatelessWidget {
  const TabWebApp({
    Key? key,
    required this.tabs,
    required this.tabController,
    this.bodyMaxWidth,
    this.theme,
    this.logo,
  }) : super(key: key);

  // App theme
  final ThemeData? theme;

  // Build tab button to appbar
  final List<TabDefinition> tabs;

  // Logo on top left
  final Widget? logo;

  // App body max width
  final double? bodyMaxWidth;

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerDelegate: TabShellAppRouterDelegate(
        tabs: tabs,
        logo: logo,
        tabController: tabController,
      ),
      routeInformationParser: TabShellRouteInformationParser(),
    );
  }
}
