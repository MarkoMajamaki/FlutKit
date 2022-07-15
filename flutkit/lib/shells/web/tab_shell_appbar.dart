import 'package:flutkit/shells/web/tab_definition.dart';
import 'package:flutter/material.dart';

import 'tab_web_app_styles.dart';

///
/// Shell appbar. On desktop mode, show tabs and hide side menu button.
/// On other modes, show side menu button and hide tabs.
///
class TabShellAppBar extends StatefulWidget {
  const TabShellAppBar({
    Key? key,
    required this.tabs,
    required this.tabController,
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

  @override
  State<TabShellAppBar> createState() => _TabShellAppBarState();
}

class _TabShellAppBarState extends State<TabShellAppBar>
    with TickerProviderStateMixin {
  late AnimationController _menuIconAnimationController;
  late TabShellAppBarStyle _actualStyle;

  GlobalKey qweqweKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    /// Get actual style from theme context or giving style
    _actualStyle =
        widget.style ?? Theme.of(context).extension<TabShellAppBarStyle>()!;

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: widget.contentMaxWidth ?? double.infinity),
          child: Row(
            children: [
              if (widget.logo != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    if (MediaQuery.of(context).size.width > 860) {
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

    return Align(
      alignment: Alignment.centerRight,
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: TabBar(
          key: qweqweKey,
          controller: widget.tabController,
          indicator: _buildUnderlineIndicator(),
          labelColor: _actualStyle.selectedLabelColor,
          unselectedLabelColor: _actualStyle.unselectedLabelColor,
          isScrollable: true,
          labelPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          tabs: tabWidgets,
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
              color: isSelected ? _actualStyle.outlinedTabColor : Colors.white,
              border:
                  Border.all(width: 2, color: _actualStyle.outlinedTabColor),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  tabDefinition.text,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : _actualStyle.outlinedTabColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Tab(text: tabDefinition.text);
    }
  }

  ///
  /// Build underline indicator
  ///
  UnderlineTabIndicator _buildUnderlineIndicator() {
    return UnderlineTabIndicator(
      borderSide: BorderSide(
        width: 4,
        color: _actualStyle.lineIndicatorColor,
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
            _menuIconAnimationController.isCompleted
                ? _menuIconAnimationController.reverse()
                : _menuIconAnimationController.forward();
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _menuIconAnimationController,
          ),
        ),
      ),
    );
  }
}
