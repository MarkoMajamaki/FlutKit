import 'package:flutter/widgets.dart';

import 'tab_shell_controller.dart';
import 'tab_shell_page.dart';
import 'tab_shell_router_path.dart';

class TabShellRouterDelegate extends RouterDelegate<TabShellRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TabShellRoutePath> {
  ///
  /// Create delegate with navigation controller which contains state of current
  /// page.
  ///
  TabShellRouterDelegate(this.tabShellController) {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  // Tab navigation controller to listen
  TabShellController tabShellController;

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
        TabShellPage(child: _getView(tabShellController.tabName)),
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
  Widget _getView(String viewName) {
    /*
    switch (viewName.toLowerCase()) {
      case ContactPage.route:
        return const ContactPage();
      case ProductsPage.route:
        return const ProductsPage();
      case BeekeeperPage.route:
        return const BeekeeperPage();
      case PollinationPage.route:
        return const PollinationPage();
      case UnknownPage.route:
        return const UnknownPage();
      case "/":
      case HomePage.route:
      default:
        return const HomePage();
    }
    */
    return Placeholder();
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
