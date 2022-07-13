import 'package:flutter/material.dart';

import 'tab_shell_router_path.dart';

class TabShellRouteInformationParser
    extends RouteInformationParser<TabShellRoutePath> {
  ///
  /// Convert URL into an app location
  ///
  @override
  Future<TabShellRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    return TabShellRoutePath(uri.pathSegments.first);
  }

  ///
  /// Convert route location into URL
  ///
  @override
  RouteInformation restoreRouteInformation(TabShellRoutePath configuration) {
    return RouteInformation(location: configuration.path);
  }
}
