import 'package:flutkit/shells/web/tab_definition.dart';
import 'package:flutter/material.dart';

import 'tab_shell_page.dart';
import 'tab_shell_router_path.dart';

class TabShellBodyRouterDelegate extends RouterDelegate<TabShellRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TabShellRoutePath> {
  ///
  /// Create delegate with navigation controller which contains state of current
  /// page.
  ///
  TabShellBodyRouterDelegate(this.tabController, this.tabs) {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  // Tab navigation controller to listen
  TabController tabController;

  // Tabs definitions
  final List<TabDefinition> tabs;

  late final GlobalKey<NavigatorState> _navigatorKey;

  // Key used to retrieve current navigator
  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  ///
  /// Build navigator
  ///
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        TabShellPage(child: _getTabViewBody(tabController.index, context)),
      ],
      onPopPage: (route, result) {
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  ///
  /// Get view by name
  ///
  Widget _getTabViewBody(int tabIndex, BuildContext context) {
    return tabs.elementAt(tabIndex).buildPage(context);
  }

  ///
  /// This is not required for inner router delegate because it does not
  /// parse route
  ///
  @override
  Future<void> setNewRoutePath(TabShellRoutePath configuration) async {
    assert(true);
  }
}
