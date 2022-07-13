import 'package:flutkit/shells/web/tab_definition.dart';
import 'package:flutkit/shells/web/tab_shell_controller.dart';
import 'package:flutter/material.dart';

import '../../widgets/sidebar.dart';
import 'tab_shell_appbar.dart';
import 'tab_shell_router_delegate.dart';

class TabShell extends StatefulWidget {
  const TabShell({
    Key? key,
    required this.tabDefinitions,
    required this.controller,
    this.logo,
    this.bodyMaxWidth,
  }) : super(key: key);

  // Controller to change tabs
  final TabShellController controller;

  // Tab definitions
  final List<TabDefinition> tabDefinitions;

  // Logo on top left
  final Widget? logo;

  // App body max width
  final double? bodyMaxWidth;

  @override
  State<TabShell> createState() => _TabShellState();
}

class _TabShellState extends State<TabShell> with TickerProviderStateMixin {
  late TabShellRouterDelegate _tabShellRouterDelegate;
  late ChildBackButtonDispatcher _backButtonDispatcher;
  late SideBarController _sideBarController;

  @override
  void initState() {
    super.initState();
    _tabShellRouterDelegate = TabShellRouterDelegate(widget.controller);
    widget.controller.addListener(notifyListeners);
    _sideBarController = SideBarController();
  }

  @override
  void dispose() {
    widget.controller.removeListener(notifyListeners);
    _sideBarController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher!
        .createChildBackButtonDispatcher();
  }

  @override
  void didUpdateWidget(covariant TabShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tabShellRouterDelegate.tabShellController = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SideBar(
              controller: _sideBarController,
              body: _buildBody(),
              menu: Placeholder(),
              menuOpenMode: MenuOpenMode.Floating,
              duration: 500,
              menuLocation: MenuLocation.Right,
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Build AppBar with tabs, logo, and menu button
  ///
  Widget _buildAppBar() {
    List<Widget> appBarTabWidgets = List.empty();

    // Build appbar tabs
    for (int i = 0; i < widget.tabDefinitions.length; i++) {
      appBarTabWidgets.add(widget.tabDefinitions[i].buildAppBarWidget(context));
    }
    return TabShellAppBar(
      contentMaxWidth: widget.bodyMaxWidth,
      initTabIndex: 0,
      onTabTapped: (tabIndex) {
        widget.controller.changeTab(widget.tabDefinitions[tabIndex].route);
      },
      onMenuButtonTapped: () {
        _sideBarController.isMenuOpen = !_sideBarController.isMenuOpen;
      },
      tabs: appBarTabWidgets,
    );
  }

  ///
  /// Build body
  ///
  Widget _buildBody() {
    return Router(
      routerDelegate: _tabShellRouterDelegate,
      backButtonDispatcher: _backButtonDispatcher,
    );
  }

  void notifyListeners() {
    setState(() {});
  }
}
