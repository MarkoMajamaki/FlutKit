import 'package:flutkit/flutkit.dart';
import 'package:flutkit/shells/web/tab_shell.dart';
import 'package:flutter/material.dart';

///
/// Shell appbar. On desktop mode, show tabs and hide side menu button.
/// On other modes, show side menu button and hide tabs.
///
class TabShellAppBar extends StatefulWidget {
  const TabShellAppBar({
    Key? key,
    required this.tabs,
    required this.tabController,
    required this.sideBarController,
    this.contentMaxWidth,
    required this.onMenuButtonTapped,
    this.logo,
    this.style,
  }) : super(key: key);

  final List<TabDefinition> tabs;
  final TabController tabController;
  final Widget? logo;
  final double? contentMaxWidth;
  final Function onMenuButtonTapped;
  final TabShellAppBarStyle? style;
  final SideBarController sideBarController;

  @override
  State<TabShellAppBar> createState() => _TabShellAppBarState();
}

class _TabShellAppBarState extends State<TabShellAppBar>
    with TickerProviderStateMixin, MaterialStateMixin {
  late AnimationController _menuIconAnimationController;

  GlobalKey qweqweKey = GlobalKey();

  late Color _lineIndicatorColor;
  late Color _selectedLabelColor;
  late Color _unselectedLabelColor;
  late Color _outlinedTabColor;
  late TextStyle _labelStyle;
  late TextStyle _outlinedLabelStyle;

  @override
  Widget build(BuildContext context) {
    final TabShellAppBarStyle? widgetStyle = widget.style;
    final TabShellAppBarStyle? themeStyle =
        TabShellAppBarStyle.maybeOf(context);
    final TabShellAppBarStyle defaultStyle = _defaultStyle();

    // Get effective value from widget, inherited or from default theme
    T? effectiveValue<T>(T? Function(TabShellAppBarStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    _lineIndicatorColor = effectiveValue((style) => style?.lineIndicatorColor)!;
    _selectedLabelColor = effectiveValue((style) => style?.selectedLabelColor)!;
    _unselectedLabelColor =
        effectiveValue((style) => style?.unselectedLabelColor)!;
    _outlinedTabColor = effectiveValue((style) => style?.outlinedTabColor)!;
    _labelStyle = effectiveValue((style) => style?.labelStyle)!;
    _outlinedLabelStyle = effectiveValue((style) => style?.outlinedLabelStyle)!;

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: widget.contentMaxWidth ?? double.infinity),
          child: Row(
            children: [
              if (widget.logo != null)
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 16),
                  child: widget.logo,
                ),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  ///
  /// Init widget state
  ///
  @override
  void initState() {
    _menuIconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    // Sync sidebar controller state with menu icon
    widget.sideBarController.addListener(() {
      if (widget.sideBarController.isMenuOpen &&
          _menuIconAnimationController.status != AnimationStatus.forward) {
        _menuIconAnimationController.forward();
      } else if (_menuIconAnimationController.status !=
          AnimationStatus.reverse) {
        _menuIconAnimationController.reverse();
      }
    });

    super.initState();
  }

  ///
  /// Release resources
  ///
  @override
  void dispose() {
    _menuIconAnimationController.dispose();
    super.dispose();
  }

  ///
  /// Build content based on available size
  ///
  Widget _buildContent() {
    if (MediaQuery.of(context).size.width > 950) {
      return _buildTabs();
    } else {
      return _buildMenuButton();
    }
  }

  ///
  /// Build all tabs aligned to right
  ///
  Widget _buildTabs() {
    List<Widget> tabWidgets = List.empty(growable: true);

    // Build appbar tabs
    for (int i = 0; i < widget.tabs.length; i++) {
      tabWidgets
          .add(_buildTab(widget.tabs[i], widget.tabController.index == i));
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: TabBar(
            controller: widget.tabController,
            indicator: _buildUnderlineIndicator(),
            labelColor: _selectedLabelColor,
            unselectedLabelColor: _unselectedLabelColor,
            isScrollable: true,
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tabs: tabWidgets,
          ),
        ),
      ),
    );
  }

  ///
  /// Build single tab based on definition
  ///
  Widget _buildTab(TabDefinition tabDefinition, bool isSelected) {
    if (tabDefinition.style == TabStyles.outlined) {
      return Tab(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: isSelected ? _outlinedTabColor : Colors.white,
              border: Border.all(width: 2, color: _outlinedTabColor),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  tabDefinition.text,
                  style: _outlinedLabelStyle.copyWith(
                      color: isSelected ? Colors.white : _outlinedTabColor),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Tab(
        child: Text(
          tabDefinition.text,
          style: _labelStyle.copyWith(
              color: isSelected ? _selectedLabelColor : _unselectedLabelColor),
        ),
      );
    }
  }

  ///
  /// Build underline indicator
  ///
  UnderlineTabIndicator _buildUnderlineIndicator() {
    return UnderlineTabIndicator(
      borderSide: BorderSide(
        width: 4,
        color: _lineIndicatorColor,
      ),
      insets: const EdgeInsets.only(left: 16, right: 16),
    );
  }

  ///
  /// Build menu button
  ///
  Widget _buildMenuButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 20, bottom: 16),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            widget.onMenuButtonTapped();
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _menuIconAnimationController,
          ),
        ),
      ),
    );
  }

  TabShellAppBarStyle _defaultStyle() {
    return TabShellAppBarStyle(
      lineIndicatorColor: Theme.of(context).primaryColor,
      selectedLabelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.black,
      outlinedTabColor: Theme.of(context).primaryColor,
      outlinedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelStyle: const TextStyle(color: Colors.black),
    );
  }
}
