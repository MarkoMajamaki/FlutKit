import 'package:flutkit/shells/web/tab_definition.dart';
import 'package:flutkit/shells/web/tab_shell_sidebarmenu.dart';
import 'package:flutter/material.dart';

import '../../widgets/sidebar.dart';
import 'tab_shell_sidebarmenu.dart';
import 'tab_shell_appbar.dart';
import 'tab_shell_body_router_delegate.dart';

class TabShell extends StatefulWidget {
  const TabShell({
    Key? key,
    required this.tabs,
    required this.tabController,
    this.logo,
    this.bodyMaxWidth,
  }) : super(key: key);

  // Controller to change tabs
  final TabController tabController;

  // Tab definitions
  final List<TabDefinition> tabs;

  // Logo on top left
  final Widget? logo;

  // App body max width
  final double? bodyMaxWidth;

  @override
  State<TabShell> createState() => _TabShellState();
}

class _TabShellState extends State<TabShell> with TickerProviderStateMixin {
  final SideBarController _sideBarController = SideBarController();

  late TabShellBodyRouterDelegate _tabShellRouterDelegate;
  late ChildBackButtonDispatcher _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    _tabShellRouterDelegate =
        TabShellBodyRouterDelegate(widget.tabController, widget.tabs);
  }

  @override
  void dispose() {
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
    _tabShellRouterDelegate.tabController = widget.tabController;
  }

  ///
  /// Build widget
  ///
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
              menu: TabShellSideBarMenu(
                tabs: widget.tabs,
                tabController: widget.tabController,
              ),
              menuOpenMode: MenuOpenMode.floating,
              duration: 500,
              menuLocation: MenuLocation.right,
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
    return TabShellAppBar(
      contentMaxWidth: widget.bodyMaxWidth,
      tabController: widget.tabController,
      sideBarController: _sideBarController,
      onMenuButtonTapped: () {
        _sideBarController.isMenuOpen = !_sideBarController.isMenuOpen;
      },
      tabs: widget.tabs,
      logo: widget.logo,
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
}
