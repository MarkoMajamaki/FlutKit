import 'package:flutter/material.dart';

///
/// Shell appbar. On desktop mode, show tabs and hide side menu button.
/// On other modes, show side menu button and hide tabs.
///
class TabShellAppBar extends StatefulWidget {
  final List<Widget> tabs;
  final Widget? logo;
  final double? contentMaxWidth;
  final int? initTabIndex;
  final Function(int) onTabTapped;
  final Function onMenuButtonTapped;
  final TabShellAppBarStyle? style;

  const TabShellAppBar({
    Key? key,
    required this.tabs,
    required this.onTabTapped,
    this.initTabIndex,
    this.contentMaxWidth,
    required this.onMenuButtonTapped,
    this.logo,
    this.style,
  }) : super(key: key);

  @override
  State<TabShellAppBar> createState() => _TabShellAppBarState();
}

class _TabShellAppBarState extends State<TabShellAppBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _menuIconAnimationController;
  late TabShellAppBarStyle _actualStyle;

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
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
    _tabController = TabController(length: widget.tabs.length, vsync: this);

    if (widget.initTabIndex != null) {
      _tabController.index = widget.initTabIndex!;
    }

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
    _tabController.dispose();
    _menuIconAnimationController.dispose();
    super.dispose();
  }

  ///
  /// Build content based on available size
  ///
  Widget _buildContent() {
    // TODO
    if (widget.contentMaxWidth == null ||
        MediaQuery.of(context).size.width > 750) {
      return _buildTabs();
    } else {
      return _buildMenuButton();
    }
  }

  ///
  /// Build all tabs aligned to right
  ///
  Widget _buildTabs() {
    return Align(
      alignment: Alignment.centerRight,
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: TabBar(
          controller: _tabController,
          indicator: _buildUnderlineIndicator(),
          onTap: (index) {
            widget.onTabTapped(index);
          },
          isScrollable: true,
          labelPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 12,
            top: 12,
          ),
          tabs: widget.tabs,
        ),
      ),
    );
  }

  ///
  /// Build underline indicator. If last tab is outlined style and selected,
  /// then hide underline indicator
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

///
/// TabShellAppBar style
///
class TabShellAppBarStyle extends ThemeExtension<TabShellAppBarStyle> {
  TabShellAppBarStyle({
    required this.lineIndicatorColor,
  });

  final Color lineIndicatorColor;

  @override
  ThemeExtension<TabShellAppBarStyle> copyWith({
    Color? lineIndicatorColor,
  }) {
    return TabShellAppBarStyle(
      lineIndicatorColor: lineIndicatorColor ?? this.lineIndicatorColor,
    );
  }

  @override
  ThemeExtension<TabShellAppBarStyle> lerp(
    ThemeExtension<TabShellAppBarStyle>? other,
    double t,
  ) {
    if (other is! TabShellAppBarStyle) {
      return this;
    }

    return TabShellAppBarStyle(
      lineIndicatorColor: lineIndicatorColor,
    );
  }
}
