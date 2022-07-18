import 'package:flutter/material.dart';

import 'tab_definition.dart';
import 'tab_shell.dart';
import 'tab_shell_router_path.dart';

class TabShellAppRouterDelegate extends RouterDelegate<TabShellRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TabShellRoutePath> {
  ///
  /// Create delegate with navigation controller which contains state of current
  /// page.
  ///
  TabShellAppRouterDelegate({
    required this.tabs,
    required this.tabController,
    this.appBarMaxWidth,
    this.logo,
  }) {
    _navigatorKey = GlobalKey<NavigatorState>();

    // Listen tab changes to update url with route information parser
    tabController.addListener(notifyListeners);
  }

  // Tab definitions
  final List<TabDefinition> tabs;

  // Logo on top left
  final Widget? logo;

  // Tab controller
  final TabController tabController;

  // AppBar max width
  final double? appBarMaxWidth;

  // Key used to retrieve current navigator
  late final GlobalKey<NavigatorState> _navigatorKey;

  ///
  /// Get key which is used to retrieve current navigator
  ///
  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  ///
  /// Change app state into navigation state. After this, routeInformationParser.
  /// restoreRouteInformation is called with this new navigation state.
  ///
  @override
  TabShellRoutePath get currentConfiguration =>
      TabShellRoutePath(tabs.elementAt(tabController.index).route);

  ///
  /// Dispose listeneres
  ///
  @override
  void dispose() {
    tabController.removeListener(notifyListeners);
    super.dispose();
  }

  ///
  /// Build navigator
  ///
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        MaterialPage(
          child: TabShell(
            tabs: tabs,
            tabController: tabController,
            logo: logo,
            appBarMaxWidth: appBarMaxWidth,
          ),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        notifyListeners();
        return true;
      },
    );
  }

  ///
  /// Convert navigation state into app state.
  ///
  /// This is where all your logic should take place: verifying that the user
  /// can access what he/she is trying to access, redirecting if needed.
  ///
  @override
  Future<void> setNewRoutePath(TabShellRoutePath configuration) async {
    for (int i = 0; i < tabs.length; i++) {
      TabDefinition tabDefinition = tabs.elementAt(i);
      if (tabDefinition.route == configuration.route) {
        tabController.index = i;
        return;
      }
    }
    tabController.index = 0;
  }
}
