///
/// Tab shell route information
///
class TabShellRoutePath {
  late String _route;

  String get route => _route;

  String get path => "/$_route";
  set path(String tabName) {
    _route = tabName;
  }

  TabShellRoutePath(String route) {
    _route = route;
  }
}
