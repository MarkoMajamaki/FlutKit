import 'package:flutter/material.dart';
import 'dart:math';

enum SlideBarModalBackgroundColor { Black, White, Transparent }
enum ContentBehavior { Move, Resize }
enum MenuOpenMode { Default, Floating }
enum MenuCloseMode { Default, Narrow }
enum SubMenuOpenMode { Default, Floating }

class SideBar extends StatefulWidget {
  final Widget content;
  final Widget menu;
  final Widget submenu;
  final SlideBarModalBackgroundColor modalBackgroundColor;
  final double modalBackgroundOpacity;
  final ContentBehavior contentBehavior;
  final MenuOpenMode menuOpenMode;
  final MenuCloseMode menuCloseMode;
  final SubMenuOpenMode subMenuOpenMode;
  final double menuWidth;
  final double subMenuWidth;
  final double menuNarrowWidth;
  final double menuSpacing;
  final int duration;
  final double elevation;
  final double verticalSeparatorThickness;
  final Color verticalSeparatorColor;

  SideBar({
    Key key,
    @required this.content,
    this.menu,
    this.submenu,
    this.modalBackgroundColor = SlideBarModalBackgroundColor.Black,
    this.modalBackgroundOpacity = 0.4,
    this.contentBehavior = ContentBehavior.Move,
    this.menuOpenMode = MenuOpenMode.Default,
    this.menuCloseMode = MenuCloseMode.Default,
    this.subMenuOpenMode = SubMenuOpenMode.Floating,
    this.menuWidth = double.infinity,
    this.menuNarrowWidth = 64,
    this.menuSpacing,
    this.subMenuWidth = double.infinity,
    this.duration = 300,
    this.elevation = 12,
    this.verticalSeparatorThickness,
    this.verticalSeparatorColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SideBarState();

  ///
  /// Get first SideBar ancestor state
  ///
  static _SideBarState of(BuildContext context) {
    return context.findAncestorStateOfType<_SideBarState>();
  }
}

///
/// SideBar state
///
class _SideBarState extends State<SideBar> with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool _isSubMenuOpen = false;

  double _screenWidth;

  DragUpdateDetails _panUpdateDetails;
  DragStartDetails _panStartDetails;

  AnimationController _menuAnimationController;
  Animation<double> _menuAnimation;

  AnimationController _subMenuAnimationController;
  Animation<double> _subMenuAnimation;

  // Is panning active
  bool get isPanning => _panStartDetails != null;

  // Menu right side current actual x coordinate
  double get actualMenuRight => getMenuOffset().dx + getActualMenuWidth();

  // Submenu right side current actual x coordinate
  double get actualSubMenuRight => getSubMenuOffset().dx + getActualSubMenuWidth();

  ///
  /// Init controllers
  ///
  @override
  void initState() {
    super.initState();

    _menuAnimationController = AnimationController(vsync: this)
    ..addListener(() {
      setState(() {
      });
    });

    _subMenuAnimationController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
        });
      });
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    _subMenuAnimationController.dispose();
    super.dispose();
  }

  ///
  /// Open menu with animation. Animate double from 0 -> 1 (close -> open) and
  /// do slide and width calculations based on that value.
  ///
  void isMenuOpen(bool isOpen) {
    if (widget.menu == null) {
      return;
    }
    _menuAnimationController.duration = Duration(milliseconds: widget.duration);
    double currentAnimationProcess = getMenuOpenPercent();
    _isMenuOpen = isOpen;

    _menuAnimationController.reset();

    if (isOpen) {
      _menuAnimation =
          Tween<double>(
              begin: currentAnimationProcess,
              end: 1)
              .animate(
              CurvedAnimation(
                parent: _menuAnimationController,
                curve: Curves.easeOutCubic,
              ));
      _menuAnimationController.forward();
    }
    else {
      _menuAnimation =
          Tween<double>(
              begin: currentAnimationProcess,
              end: 0)
              .animate(
              CurvedAnimation(
                parent: _menuAnimationController,
                curve: Curves.easeOutCubic,
              ));
      _menuAnimationController.forward();
    }
  }

  ///
  /// Open submenu with animation. Animate double from 0 -> 1 (close -> open) and
  /// do slide calculation based on that value.
  ///
  void isSubMenuOpen(bool isOpen) {
    if (widget.submenu == null) {
      return;
    }

    _subMenuAnimationController.duration = Duration(milliseconds: widget.duration);
    double currentAnimationProcess = getSubMenuOpenPercent();
    _isSubMenuOpen = isOpen;

    _subMenuAnimationController.reset();

    if (isOpen) {
      _subMenuAnimation =
          Tween<double>(
              begin: currentAnimationProcess,
              end: 1)
              .animate(CurvedAnimation(
              parent: _subMenuAnimationController,
                curve: Curves.easeOutCubic
          ));

      _subMenuAnimationController.forward();
    } else {
      _subMenuAnimation =
          Tween<double>(
              begin: currentAnimationProcess,
              end: 0)
              .animate(CurvedAnimation(
              parent: _subMenuAnimationController,
              curve: Curves.easeOutCubic
          ));

      _subMenuAnimationController.forward();
    }
  }

  ///
  /// Build
  ///
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    _screenWidth = deviceSize.width;

    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: getContentOffset(),
          child: SizedBox(
              width: getContentWidth(),
              child: widget.content),
        ),
        Visibility(
          visible: getIsModalOpened(),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _panUpdateDetails = details;
              });
            },
            onHorizontalDragStart: (details){
              handlePanStart(details);
            },
            onHorizontalDragEnd: (details) {
              handlePanEnd();
            },
            onTap: () {
              // Close submenu first
              if (_isSubMenuOpen){
                isSubMenuOpen(false);
              }
              else if (_isMenuOpen){
                isMenuOpen(false);
              }
            },
            child: Container(
              color: getModalBackgroundColor(widget.modalBackgroundColor),
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (getIsModalOpened()) {
              setState(() {
                _panUpdateDetails = details;
              });
            }
          },
          onHorizontalDragStart: (details){
            if (getIsModalOpened()) {
              handlePanStart(details);
            }
          },
          onHorizontalDragEnd: (details) {
            if (getIsModalOpened()) {
              handlePanEnd();
            }
          },
          child: SizedBox(
            width: getActualSubMenuWidth(),
            child: Transform.translate(
              offset: getSubMenuOffset(),
              child: Material(
                  elevation: getIsSubMenuModalOpened() ? widget.elevation : 0,
                  child: Container(
                      decoration: getVerticalLineDecorator(),
                      child: widget.submenu)),
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            if (getIsModalOpened()) {
              setState(() {
                _panUpdateDetails = details;
              });
            }
          },
          onHorizontalDragStart: (details){
            if (getIsModalOpened()) {
              handlePanStart(details);
            }
          },
          onHorizontalDragEnd: (details) {
            if (getIsModalOpened()) {
              handlePanEnd();
            }
          },
          child: SizedBox(
            width: getActualMenuWidth(),
            child: Transform.translate(
              offset: getMenuOffset(),
              child: Material(
                  elevation: getIsMenuModalOpened() && getIsSubMenuModalOpened() == false ? widget.elevation : 0,
                  child: Container(
                      decoration: getVerticalLineDecorator(),
                      child: widget.menu)),
            ),
          ),
        ),
      ],
    );
  }

  ///
  /// Check is modal background visible
  ///
  bool getIsModalOpened() {
    return getIsMenuModalOpened() || getIsSubMenuModalOpened();
  }

  ///
  /// Check is menu modally opened
  ///
  bool getIsMenuModalOpened() {
    double menuRight = actualMenuRight;

    bool isMenuOpening =
        (menuRight > 0 && widget.menuCloseMode == MenuCloseMode.Default) ||
        (menuRight > widget.menuNarrowWidth && widget.menuCloseMode == MenuCloseMode.Narrow);

    return (_isMenuOpen || isMenuOpening) &&
        (widget.contentBehavior == ContentBehavior.Move || widget.menuOpenMode == MenuOpenMode.Floating);
  }

  ///
  /// Check is submenu modally opened
  ///
  bool getIsSubMenuModalOpened() {
    double menuRight = actualMenuRight;
    double subMenuRight = actualSubMenuRight;
    bool isSubMenuOpening = subMenuRight > menuRight;

    return (_isSubMenuOpen || isSubMenuOpening) &&
        (widget.contentBehavior == ContentBehavior.Move || widget.subMenuOpenMode == SubMenuOpenMode.Floating ||
            (widget.menu != null && widget.menuOpenMode == MenuOpenMode.Floating));
  }

  ///
  /// Get modal background color
  ///
  Color getModalBackgroundColor(SlideBarModalBackgroundColor modalBackgroundColor) {
    double menuOffsetPercent = getIsMenuModalOpened() ? getMenuOpenPercent() : 0;
    double subMenuOffsetPercent = getIsSubMenuModalOpened() ? getSubMenuOpenPercent() : 0;
    double offsetPercent = max<double>(menuOffsetPercent, subMenuOffsetPercent);

    switch (modalBackgroundColor) {
      case SlideBarModalBackgroundColor.Black:
        return Colors.black.withOpacity(widget.modalBackgroundOpacity * offsetPercent);
      case SlideBarModalBackgroundColor.White:
        return Colors.white.withOpacity(widget.modalBackgroundOpacity * offsetPercent);
      case SlideBarModalBackgroundColor.Transparent:
      default:
        return Colors.transparent;
    }
  }

  ///
  /// Get how many percents menu is moved (or resized) from close to the open state
  ///
  double getMenuOpenPercent() {

    double menuStartToEndDistance;
    double menuStartToCurrentDistance;

    // Default
    if (widget.menuCloseMode == MenuCloseMode.Default) {
      double menuStart = -getActualMenuWidth();
      double menuEnd = 0;
      double menuCurrentX = getMenuOffset().dx;
      menuStartToEndDistance = (menuEnd - menuStart).abs();
      menuStartToCurrentDistance = (menuStart - menuCurrentX).abs();
    }
    // Narrow
    else {
      double menuStartWidth = widget.menuNarrowWidth;
      double menuEndWidth = getMenuMaxWidth();
      double menuCurrentWidth = getActualMenuWidth();
      menuStartToEndDistance = (menuEndWidth - menuStartWidth).abs();
      menuStartToCurrentDistance = (menuStartWidth - menuCurrentWidth).abs();
    }

    if (menuStartToEndDistance == 0) {
      return 0;
    } else {
      return menuStartToCurrentDistance / menuStartToEndDistance;
    }
  }

  ///
  /// Get how many percents submenu is moved from close state location to the open state location
  ///
  double getSubMenuOpenPercent() {
    double menuRight = actualMenuRight;
    double subMenuStart = menuRight - getActualSubMenuWidth();
    double subMenuEnd = menuRight;
    double subMenuCurrentX = getSubMenuOffset().dx;
    double subMenuStartToEndDistance = (subMenuEnd - subMenuStart).abs();
    double subMenuStartToCurrentXDistance = (subMenuStart - subMenuCurrentX).abs();

    if (subMenuStartToEndDistance == 0) {
        return 0;
    } else {
      return subMenuStartToCurrentXDistance / subMenuStartToEndDistance;
    }
  }

  ///
  /// Get content current offset based on menu and submenu offset and width
  ///
  Offset getContentOffset() {
    if (widget.subMenuOpenMode == SubMenuOpenMode.Default && widget.menuOpenMode == MenuOpenMode.Default && widget.submenu != null) {
      return Offset(actualSubMenuRight, 0);
    }
    else if (widget.menuOpenMode == MenuOpenMode.Default) {
      return Offset(actualMenuRight, 0);
    }
    else if (widget.menuCloseMode == MenuCloseMode.Narrow) {
      return Offset(widget.menuNarrowWidth, 0);
    }
    else {
      return Offset(0, 0);
    }
  }

  ///
  /// Get content current width. If content behavior is on 'Resize' mode, then width changes.
  ///
  double getContentWidth() {
    double width = _screenWidth;

    // If content is resizing
    if (widget.contentBehavior == ContentBehavior.Resize){
      // Content width is based on menu and submenu modes
      if (widget.subMenuOpenMode == SubMenuOpenMode.Default && widget.menuOpenMode == MenuOpenMode.Default) {
        width = _screenWidth - max<double>(actualMenuRight, actualSubMenuRight);
      } else if (widget.menuOpenMode == MenuOpenMode.Default) {
        width = _screenWidth - (getMenuOffset().dx + getActualMenuWidth());
      } else if (widget.menuCloseMode == MenuCloseMode.Narrow) {
        width = _screenWidth - widget.menuNarrowWidth;
      } else {
        width = double.infinity;
      }
    }
    // If content has same static width, and only offset changes.
    else if (widget.menu != null && widget.menuCloseMode == MenuCloseMode.Narrow) {
      width = _screenWidth - widget.menuNarrowWidth;
    }
    // Full width by default
    else {
      width = double.infinity; // full width
    }
    return width;
  }

  ///
  /// Get menu current offset
  ///
  Offset getMenuOffset() {

    if (widget.menu == null) {
      return Offset(0, 0);
    }

    double menuActualWidth = getActualMenuWidth();
    double fixedPanX = 0;
    if (_isSubMenuOpen == false && _panUpdateDetails != null && _panUpdateDetails.globalPosition.dx < menuActualWidth) {
      double fixedPanStart = _panStartDetails.globalPosition.dx > menuActualWidth ? menuActualWidth : _panStartDetails.globalPosition.dx;
      fixedPanX = _panUpdateDetails.globalPosition.dx - fixedPanStart;
    }

    if (widget.menuCloseMode == MenuCloseMode.Narrow) {
      // Menu offset is not changing if close mode is narrow (only width changes)
      return Offset(0, 0);
    }
    else if (_menuAnimation != null && _menuAnimation.value.isNaN == false) {
      double startX = -menuActualWidth;
      double endX = 0;
      return Offset(min<double>(0, (startX + (endX - startX) * _menuAnimation.value) + fixedPanX), 0);
    }
    else if (_isMenuOpen) {
      return Offset(0, 0);
    }
    else {
      return Offset(-menuActualWidth + fixedPanX, 0);
    }
  }

  ///
  /// Get menu current width
  ///
  double getActualMenuWidth() {
    if (widget.menu == null) {
      return 0;
    }
    // If menu close mode is 'Narrow' then menu width changes based on menu animation
    else if (widget.menuCloseMode == MenuCloseMode.Narrow) {
      double startWidth = widget.menuNarrowWidth;
      double endWidth = 0;
      if (widget.menuWidth.isFinite) {
        endWidth = widget.menuWidth;
      } else if (widget.menuSpacing != null ){
        endWidth = _screenWidth - widget.menuSpacing;
      } else {
        endWidth = _screenWidth;
      }
      double menuAnimationProcess = _menuAnimation != null ? _menuAnimation.value : _isMenuOpen ? 1 : 0;

      double fixedPanX = 0;
      if (_isSubMenuOpen == false &&
          _panUpdateDetails != null
          && (_panUpdateDetails.globalPosition.dx < widget.menuWidth
              || _panStartDetails.globalPosition.dx < widget.menuWidth && _panUpdateDetails.globalPosition.dx > widget.menuWidth)) {
        double fixedPanStart = _panStartDetails.globalPosition.dx > widget.menuWidth ? widget.menuWidth : _panStartDetails.globalPosition.dx;
        fixedPanX = _panUpdateDetails.globalPosition.dx - fixedPanStart;
      }
      double menuMaxWidth = widget.menuWidth.isInfinite ? _screenWidth - (widget.menuSpacing ?? 0) : widget.menuWidth;
      return max<double>(widget.menuNarrowWidth, min<double>(menuMaxWidth, startWidth + (endWidth - startWidth) * menuAnimationProcess + fixedPanX));
    }
    // If menu close mode is 'Default' then menu width is not changing
    else {
      if (widget.menuWidth.isFinite) {
        return widget.menuWidth;
      } else if (widget.menuSpacing != null ){
        return _screenWidth - widget.menuSpacing;
      } else {
        return _screenWidth;
      }
    }
  }

  ///
  /// Get menu max width
  ///
  double getMenuMaxWidth() {
    return widget.menuWidth.isInfinite ? _screenWidth - (widget.menuSpacing ?? 0) : widget.menuWidth;
  }

  ///
  /// Get submenu offset
  ///
  Offset getSubMenuOffset() {
    double menuRight = actualMenuRight;
    double subMenuRight = menuRight + getActualSubMenuWidth();

    double fixedPanX = 0;
    if (_panUpdateDetails != null && _panUpdateDetails.globalPosition.dx < subMenuRight) {
      double fixedPanStart = _panStartDetails.globalPosition.dx > subMenuRight ? subMenuRight : _panStartDetails.globalPosition.dx;
      fixedPanX = _panUpdateDetails.globalPosition.dx - fixedPanStart;
    }

    if (_subMenuAnimation != null && _subMenuAnimation.value.isNaN == false) {
      double startX = menuRight - getActualSubMenuWidth();
      double endX = menuRight;
      return Offset(min<double>(endX, max<double>(startX, startX + (endX - startX) * _subMenuAnimation.value + fixedPanX)), 0);
    }
    else if (_isSubMenuOpen) {
      return Offset(menuRight, 0);
    }
    else {
      return Offset(menuRight - getActualSubMenuWidth(), 0);
    }
  }

  ///
  /// Get submenu actual width
  ///
  double getActualSubMenuWidth() {
    if (widget.submenu == null){
      return 0;
    } else {
      return widget.subMenuWidth.isFinite ? widget.subMenuWidth : _screenWidth ?? 0;
    }
  }

  ///
  /// Handle pan end. Do open or close animations based on offsets
  ///
  void handlePanEnd() {
    if (_panUpdateDetails == null) {
      return;
    }
    double menuRight = actualMenuRight;
    double subMenuRight = actualSubMenuRight;
    double menuOpenPercent = getMenuOpenPercent();

    if (menuOpenPercent < 0.5 || (_panUpdateDetails.delta.dx.abs() > 10 && _panUpdateDetails.globalPosition.dx < menuRight)) {
      isMenuOpen(false);
    } else {
      isMenuOpen(true);
    }

    if (getSubMenuOpenPercent() < 0.5 || (_panUpdateDetails.delta.dx.abs() > 10 && _panUpdateDetails.globalPosition.dx < subMenuRight)){
      isSubMenuOpen(false);
    } else {
      isSubMenuOpen(true);
    }

    _panUpdateDetails = null;
    _panStartDetails = null;
  }

  ///
  /// Handle pan start. Init pan values.
  ///
  void handlePanStart(DragStartDetails details) {
    _panUpdateDetails = null;
    _panStartDetails = details;
  }

  ///
  /// Make vertical line to menu and submenu right side
  ///
  BoxDecoration getVerticalLineDecorator() {
    return BoxDecoration(
      border: Border(
          right: BorderSide(
            width: widget.verticalSeparatorColor == null || widget.verticalSeparatorThickness == null ? 0 : widget.verticalSeparatorThickness,
            color: widget.verticalSeparatorColor ?? Colors.transparent,
          ),
      ),
    );
  }
}