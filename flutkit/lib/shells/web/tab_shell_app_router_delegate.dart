import 'package:flutter/material.dart';

import 'tab_definition.dart';
import 'tab_shell.dart';
import 'tab_shell_controller.dart';
import 'tab_shell_router_path.dart';

class TabShellAppRouterDelegate extends RouterDelegate<TabShellRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TabShellRoutePath> {
  ///
  /// Create delegate with navigation controller which contains state of current
  /// page.
  ///
  TabShellAppRouterDelegate(this.tabDefinitions) {
    _tabShellController = TabShellController(tabDefinitions.first.route);
    _tabShellController.addListener(notifyListeners);

    _navigatorKey = GlobalKey<NavigatorState>();
  }

  // Tab definitions
  final List<TabDefinition> tabDefinitions;

  // Navigation controller to listen
  late final TabShellController _tabShellController;

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
      TabShellRoutePath(_tabShellController.tabName);

  ///
  /// Dispose listeneres
  ///
  @override
  void dispose() {
    _tabShellController.removeListener(notifyListeners);
    super.dispose();
  }

  ///
  /// Build navigator
  ///
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
            child: TabShell(
          tabDefinitions: tabDefinitions,
          controller: _tabShellController,
        )),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        notifyListeners();
        return true;
      },
    );
  }

  ///
  /// Convert navigation state into app state
  ///
  /// This is where all your logic should take place: verifying that the user
  /// can access what he/she is trying to access, redirecting if needed.
  ///
  @override
  Future<void> setNewRoutePath(TabShellRoutePath configuration) async {
    _tabShellController.tabName = configuration.tabName;
  }
}
