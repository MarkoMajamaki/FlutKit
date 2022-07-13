///
/// Tab shell route information
///
class TabShellRoutePath {
  late String _tabName;

  String get tabName => _tabName;

  String get path => "/$_tabName";
  set path(String tabName) {
    _tabName = tabName;
  }

  TabShellRoutePath(String tabName) {
    _tabName = tabName;
  }
}
