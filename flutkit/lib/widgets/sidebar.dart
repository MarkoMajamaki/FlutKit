import 'package:flutter/material.dart';
import 'dart:math';

enum SlideBarModalBackgroundColor { black, white, transparent }

enum BodyBehavior { move, resize }

enum MenuOpenMode { basic, floating }

enum MenuCloseMode { basic, narrow }

enum SubMenuOpenMode { basic, floating }

enum MenuLocation { left, right }

class SideBar extends StatefulWidget {
  final Widget body;
  final Widget? menu;
  final Widget? submenu;
  final SlideBarModalBackgroundColor modalBackgroundColor;
  final double modalBackgroundOpacity;
  final BodyBehavior bodyBehavior;
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
  final MenuLocation menuLocation;

  final SideBarController? controller;
  final Function(bool)? isMenuOpenChanged;
  final Function(bool)? isSubMenuOpenChanged;

  const SideBar(
      {Key? key,
      required this.body,
      this.controller,
      this.menu,
      this.submenu,
      this.modalBackgroundColor = SlideBarModalBackgroundColor.black,
      this.modalBackgroundOpacity = 0.4,
      this.bodyBehavior = BodyBehavior.move,
      this.menuOpenMode = MenuOpenMode.basic,
      this.menuCloseMode = MenuCloseMode.basic,
      this.subMenuOpenMode = SubMenuOpenMode.floating,
      this.menuWidth = double.infinity,
      this.menuNarrowWidth = 64,
      this.menuSpacing = 0,
      this.subMenuWidth = double.infinity,
      this.duration = 300,
      this.elevation = 12,
      this.verticalSeparatorThickness = 0,
      this.verticalSeparatorColor = Colors.black54,
      this.menuLocation = MenuLocation.left,
      this.isMenuOpenChanged,
      this.isSubMenuOpenChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SideBarState();

  ///
  /// Get first SideBar ancestor state
  ///
  static SideBarState of(BuildContext context) {
    SideBarState? state = context.findAncestorStateOfType<SideBarState>();

    if (state == null) {
      throw FlutterError(
          "SideBar operation requested with a context that does not include a SideBar as descendand.");
    }

    return state;
  }
}

///
/// SideBar state
///
class SideBarState extends State<SideBar> with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool _isSubMenuOpen = false;

  Size _availableSize = const Size(0, 0);

  DragUpdateDetails? _panUpdateDetails;
  DragStartDetails? _panStartDetails;

  late AnimationController _menuAnimationController;
  Animation<double>? _menuAnimation;

  late AnimationController _subMenuAnimationController;
  Animation<double>? _subMenuAnimation;

  // Is panning active
  bool get isPanning => _panStartDetails != null;

  // Menu right side current actual x coordinate
  double get actualMenuRight => getMenuX() + getActualMenuWidth();

  // Submenu right side current actual x coordinate
  double get actualSubMenuRight => getSubMenuX() + getActualSubMenuWidth();

  ///
  /// Init controllers
  ///
  @override
  void initState() {
    super.initState();

    _menuAnimationController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });

    _subMenuAnimationController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });

    if (widget.controller != null) {
      // Initialize values based on controller values
      isMenuOpen = widget.controller!.isMenuOpen;
      isSubMenuOpen = widget.controller!.isSubMenuOpen;

      // Start listen controller changes
      widget.controller!.addListener(() {
        isMenuOpen = widget.controller!.isMenuOpen;
        isSubMenuOpen = widget.controller!.isSubMenuOpen;
      });
    }
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    _subMenuAnimationController.dispose();

    super.dispose();
  }

  ///
  /// Is menu open
  ///
  bool get isMenuOpen => _isMenuOpen;

  ///
  /// Open or close menu with animation. Animate double from 0 -> 1 (close -> open) and
  /// do slide and width calculations based on that value.
  ///
  set isMenuOpen(bool isOpen) {
    // Update controller value
    if (widget.controller != null && widget.controller!.isMenuOpen != isOpen) {
      widget.controller!.isMenuOpen = isOpen;
    }

    if (widget.isMenuOpenChanged != null) {
      widget.isMenuOpenChanged!(isOpen);
    }

    if (widget.menu == null || (_isMenuOpen == isOpen && isPanning == false)) {
      return;
    }
    _menuAnimationController.duration = Duration(milliseconds: widget.duration);
    double currentAnimationProcess = getMenuOpenPercent();
    _isMenuOpen = isOpen;

    _menuAnimationController.reset();

    if (isOpen) {
      _menuAnimation = Tween<double>(begin: currentAnimationProcess, end: 1)
          .animate(CurvedAnimation(
        parent: _menuAnimationController,
        curve: Curves.easeOutCubic,
      ));
      _menuAnimationController.forward();
    } else {
      _menuAnimation = Tween<double>(begin: currentAnimationProcess, end: 0)
          .animate(CurvedAnimation(
        parent: _menuAnimationController,
        curve: Curves.easeOutCubic,
      ));
      _menuAnimationController.forward();
    }
  }

  ///
  /// Is sub menu open
  ///
  bool get isSubMenuOpen => _isSubMenuOpen;

  ///
  /// Open or close submenu with animation. Animate double from 0 -> 1 (close -> open) and
  /// do slide calculation based on that value.
  ///
  set isSubMenuOpen(bool isOpen) {
    // Update controller value
    if (widget.controller != null &&
        widget.controller!.isSubMenuOpen != isOpen) {
      widget.controller!.isSubMenuOpen = isOpen;
    }

    if (widget.isSubMenuOpenChanged != null) {
      widget.isSubMenuOpenChanged!(isOpen);
    }

    if (widget.submenu == null ||
        (_isSubMenuOpen == isOpen && isPanning == false)) {
      return;
    }

    _subMenuAnimationController.duration =
        Duration(milliseconds: widget.duration);
    double currentAnimationProcess = getSubMenuOpenPercent();
    _isSubMenuOpen = isOpen;

    _subMenuAnimationController.reset();

    if (isOpen) {
      _subMenuAnimation = Tween<double>(begin: currentAnimationProcess, end: 1)
          .animate(CurvedAnimation(
              parent: _subMenuAnimationController, curve: Curves.easeOutCubic));

      _subMenuAnimationController.forward();
    } else {
      _subMenuAnimation = Tween<double>(begin: currentAnimationProcess, end: 0)
          .animate(CurvedAnimation(
              parent: _subMenuAnimationController, curve: Curves.easeOutCubic));

      _subMenuAnimationController.forward();
    }
  }

  ///
  /// Build
  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        _availableSize = Size(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              width: getBodyWidth(),
              height: _availableSize.height,
              left: getBodyX(),
              child: widget.body,
            ),
            Visibility(
              visible: getIsModalOpened(),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _panUpdateDetails = details;
                  });
                },
                onHorizontalDragStart: (details) {
                  handlePanStart(details);
                },
                onHorizontalDragEnd: (details) {
                  handlePanEnd();
                },
                onTap: () {
                  // Close submenu first
                  if (_isSubMenuOpen) {
                    isSubMenuOpen = false;
                  } else if (_isMenuOpen) {
                    isMenuOpen = false;
                  }
                },
                child: Container(
                  color: getModalBackgroundColor(widget.modalBackgroundColor),
                ),
              ),
            ),
            Positioned(
              width: getActualSubMenuWidth(),
              height: _availableSize.height,
              left: getSubMenuX(),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (getIsModalOpened()) {
                    setState(() {
                      _panUpdateDetails = details;
                    });
                  }
                },
                onHorizontalDragStart: (details) {
                  if (getIsModalOpened()) {
                    handlePanStart(details);
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (getIsModalOpened()) {
                    handlePanEnd();
                  }
                },
                child: Material(
                  elevation: getIsSubMenuModalOpened() ? widget.elevation : 0,
                  child: Container(
                    decoration: getVerticalLineDecorator(),
                    child: widget.submenu,
                  ),
                ),
              ),
            ),
            Positioned(
              width: getActualMenuWidth(),
              height: _availableSize.height,
              left: getMenuX(),
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  if (getIsModalOpened()) {
                    setState(() {
                      _panUpdateDetails = details;
                    });
                  }
                },
                onHorizontalDragStart: (details) {
                  if (getIsModalOpened()) {
                    handlePanStart(details);
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (getIsModalOpened()) {
                    handlePanEnd();
                  }
                },
                child: Material(
                  elevation: getIsMenuModalOpened() &&
                          getIsSubMenuModalOpened() == false
                      ? widget.elevation
                      : 0,
                  child: Container(
                    decoration: getVerticalLineDecorator(),
                    child: widget.menu,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
    bool isMenuOpening = false;

    if (widget.menuLocation == MenuLocation.left) {
      isMenuOpening =
          (widget.menuCloseMode == MenuCloseMode.basic && menuRight > 0) ||
              (widget.menuCloseMode == MenuCloseMode.narrow &&
                  menuRight > widget.menuNarrowWidth);
    } else {
      double menuX = getMenuX();
      isMenuOpening = (widget.menuCloseMode == MenuCloseMode.basic &&
              menuX < _availableSize.width) ||
          (widget.menuCloseMode == MenuCloseMode.narrow &&
              menuX < _availableSize.width - widget.menuNarrowWidth);
    }

    return (_isMenuOpen || isMenuOpening) &&
        (widget.bodyBehavior == BodyBehavior.move ||
            widget.menuOpenMode == MenuOpenMode.floating);
  }

  ///
  /// Check is submenu modally opened
  ///
  bool getIsSubMenuModalOpened() {
    bool isSubMenuOpening = false;

    if (widget.menuLocation == MenuLocation.left) {
      double menuRight = actualMenuRight;
      double subMenuRight = actualSubMenuRight;
      isSubMenuOpening = subMenuRight > menuRight;
    } else {
      isSubMenuOpening = getSubMenuX() < _availableSize.width - getMenuX();
    }

    return (_isSubMenuOpen || isSubMenuOpening) &&
        (widget.bodyBehavior == BodyBehavior.move ||
            widget.subMenuOpenMode == SubMenuOpenMode.floating ||
            (widget.menu != null &&
                widget.menuOpenMode == MenuOpenMode.floating));
  }

  ///
  /// Get modal background color
  ///
  Color getModalBackgroundColor(
      SlideBarModalBackgroundColor modalBackgroundColor) {
    double menuOffsetPercent =
        getIsMenuModalOpened() ? getMenuOpenPercent() : 0;
    double subMenuOffsetPercent =
        getIsSubMenuModalOpened() ? getSubMenuOpenPercent() : 0;
    double offsetPercent = max<double>(menuOffsetPercent, subMenuOffsetPercent);

    switch (modalBackgroundColor) {
      case SlideBarModalBackgroundColor.black:
        return Colors.black
            .withOpacity(widget.modalBackgroundOpacity * offsetPercent);
      case SlideBarModalBackgroundColor.white:
        return Colors.white
            .withOpacity(widget.modalBackgroundOpacity * offsetPercent);
      case SlideBarModalBackgroundColor.transparent:
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

    // Default when menu is on left
    if (widget.menuCloseMode == MenuCloseMode.basic &&
        widget.menuLocation == MenuLocation.left) {
      double menuStart = -getActualMenuWidth();
      double menuEnd = 0;
      double menuCurrentX = getMenuX();
      menuStartToEndDistance = (menuEnd - menuStart).abs();
      menuStartToCurrentDistance = (menuStart - menuCurrentX).abs();
      // Default when menu is on right
    } else if (widget.menuCloseMode == MenuCloseMode.basic &&
        widget.menuLocation == MenuLocation.right) {
      double menuStart = _availableSize.width;
      double menuEnd = _availableSize.width - getActualMenuWidth();
      double menuCurrentX = getMenuX();
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
    double subMenuStart = 0;
    double subMenuEnd = 0;

    if (widget.menuLocation == MenuLocation.left) {
      subMenuStart = menuRight - getActualSubMenuWidth();
      subMenuEnd = menuRight;
    } else {
      subMenuStart = getMenuX();
      subMenuEnd = getMenuX() - getActualSubMenuWidth();
    }

    double subMenuCurrentX = getSubMenuX();
    double subMenuStartToEndDistance = (subMenuEnd - subMenuStart).abs();
    double subMenuStartToCurrentXDistance =
        (subMenuStart - subMenuCurrentX).abs();

    if (subMenuStartToEndDistance == 0) {
      return 0;
    } else {
      return subMenuStartToCurrentXDistance / subMenuStartToEndDistance;
    }
  }

  ///
  /// Get body current offset based on menu and submenu offset and width
  ///
  double getBodyX() {
    if (widget.menuLocation == MenuLocation.left) {
      if (widget.subMenuOpenMode == SubMenuOpenMode.basic &&
          widget.menuOpenMode == MenuOpenMode.basic &&
          widget.submenu != null) {
        return actualSubMenuRight;
      } else if (widget.menuOpenMode == MenuOpenMode.basic) {
        return actualMenuRight;
      } else if (widget.menuCloseMode == MenuCloseMode.narrow) {
        return widget.menuNarrowWidth;
      } else {
        return 0;
      }
    } else {
      if (widget.subMenuOpenMode == SubMenuOpenMode.basic &&
          widget.menuOpenMode == MenuOpenMode.basic &&
          widget.submenu != null) {
        return actualSubMenuRight - getActualSubMenuWidth() - getBodyWidth();
      } else if (widget.menuOpenMode == MenuOpenMode.basic) {
        return getMenuX() - getBodyWidth();
      } else if (widget.menuCloseMode == MenuCloseMode.narrow) {
        return 0;
      } else {
        return 0;
      }
    }
  }

  ///
  /// Get body current width. If body behavior is on 'Resize' mode, then width changes.
  ///
  double getBodyWidth() {
    double width = 0;

    // If body is resizing
    if (widget.bodyBehavior == BodyBehavior.resize) {
      // body width is based on menu and submenu modes
      if (widget.subMenuOpenMode == SubMenuOpenMode.basic &&
          widget.menuOpenMode == MenuOpenMode.basic) {
        if (widget.menuLocation == MenuLocation.left) {
          width = _availableSize.width -
              max<double>(actualMenuRight, actualSubMenuRight);
        } else {
          width = _availableSize.width -
              (_availableSize.width - max<double>(getMenuX(), getSubMenuX()));
        }
      } else if (widget.menuOpenMode == MenuOpenMode.basic) {
        if (widget.menuLocation == MenuLocation.left) {
          width = _availableSize.width - (getMenuX() + getActualMenuWidth());
        } else {
          width = _availableSize.width - (_availableSize.width - getMenuX());
        }
      } else if (widget.menuCloseMode == MenuCloseMode.narrow) {
        width = _availableSize.width - widget.menuNarrowWidth;
      } else {
        width = _availableSize.width;
      }
    }
    // If body has same static width, and only offset changes.
    else if (widget.menu != null &&
        widget.menuCloseMode == MenuCloseMode.narrow) {
      width = _availableSize.width - widget.menuNarrowWidth;
    }
    // Full width by default
    else {
      width = _availableSize.width; // full width
    }

    return width;
  }

  ///
  /// Get menu current offset
  ///
  double getMenuX() {
    if (widget.menu == null) {
      return 0;
    }

    double menuActualWidth = getActualMenuWidth();
    double fixedPanX = 0;

    if (widget.menuLocation == MenuLocation.left) {
      if (_isSubMenuOpen == false &&
          _panUpdateDetails != null &&
          _panStartDetails != null &&
          _panUpdateDetails!.globalPosition.dx < menuActualWidth) {
        double fixedPanStart = _panStartDetails!.globalPosition.dx;
        if (_panStartDetails!.globalPosition.dx > menuActualWidth) {
          fixedPanStart = menuActualWidth;
        }

        fixedPanX = _panUpdateDetails!.globalPosition.dx - fixedPanStart;
      }

      if (widget.menuCloseMode == MenuCloseMode.narrow) {
        // Menu offset is not changing if close mode is narrow (only width changes)
        return 0;
      } else if (_menuAnimation != null &&
          _menuAnimation!.value.isNaN == false) {
        double startX = -menuActualWidth;
        double endX = 0;
        return min<double>(
            0, (startX + (endX - startX) * _menuAnimation!.value) + fixedPanX);
      } else if (_isMenuOpen) {
        return 0;
      } else {
        return -menuActualWidth + fixedPanX;
      }
    } else {
      if (_isSubMenuOpen == false &&
          _panUpdateDetails != null &&
          _panStartDetails != null &&
          _panUpdateDetails!.globalPosition.dx >
              _availableSize.width - menuActualWidth) {
        // If pan starte inside menu
        double fixedPanStart = 0;
        if (_panStartDetails!.globalPosition.dx >
            _availableSize.width - menuActualWidth) {
          fixedPanStart = _panStartDetails!.globalPosition.dx -
              (_availableSize.width - menuActualWidth);
        }

        fixedPanX = _panUpdateDetails!.globalPosition.dx -
            (_availableSize.width - menuActualWidth) -
            fixedPanStart;
      }

      if (widget.menuCloseMode == MenuCloseMode.narrow) {
        // Menu offset is not changing if close mode is narrow (only width changes)
        return _availableSize.width - menuActualWidth;
      } else if (_menuAnimation != null &&
          _menuAnimation!.value.isNaN == false) {
        double startX = _availableSize.width;
        double endX = _availableSize.width - menuActualWidth;
        return max<double>(_availableSize.width - menuActualWidth,
            (startX + (endX - startX) * _menuAnimation!.value) + fixedPanX);
      } else if (_isMenuOpen) {
        return _availableSize.width - menuActualWidth;
      } else {
        return _availableSize.width + fixedPanX;
      }
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
    else if (widget.menuCloseMode == MenuCloseMode.narrow) {
      double startWidth = widget.menuNarrowWidth;
      double endWidth = 0;
      if (widget.menuWidth.isFinite) {
        endWidth = widget.menuWidth;
      } else if (widget.menuSpacing != 0) {
        endWidth = _availableSize.width - widget.menuSpacing;
      } else {
        endWidth = _availableSize.width;
      }
      double menuAnimationProcess = 0;
      if (_menuAnimation != null) {
        menuAnimationProcess = _menuAnimation!.value;
      } else if (_isMenuOpen) {
        menuAnimationProcess = 1;
      }

      // Change menu width to narrow if panned
      double fixedPanX = 0;
      if (_isSubMenuOpen == false &&
          _panUpdateDetails != null &&
          _panStartDetails != null) {
        // Fix pan if pan is started from inside menu
        double fixedPanStart = 0;
        double globalX = _panUpdateDetails!.globalPosition.dx;
        double startX = _panStartDetails!.globalPosition.dx;

        if (widget.menuLocation == MenuLocation.left &&
            globalX < widget.menuWidth) {
          if (startX > widget.menuWidth) {
            fixedPanStart = widget.menuWidth;
          } else {
            fixedPanStart = startX;
          }
          fixedPanX = globalX - fixedPanStart;
        } else if (widget.menuLocation == MenuLocation.right &&
            globalX > _availableSize.width - widget.menuWidth) {
          double fixedPanStart = 0;
          if (startX > _availableSize.width - widget.menuWidth) {
            fixedPanStart = startX - (_availableSize.width - widget.menuWidth);
          }

          fixedPanX = globalX -
              (_availableSize.width - widget.menuWidth) -
              fixedPanStart;
          fixedPanX = -fixedPanX;
        }
      }

      double menuMaxWidth = widget.menuWidth.isInfinite
          ? _availableSize.width - widget.menuSpacing
          : widget.menuWidth;
      double width = startWidth +
          (endWidth - startWidth) * menuAnimationProcess +
          fixedPanX;
      width = min<double>(menuMaxWidth, width);
      width = max<double>(widget.menuNarrowWidth, width);
      return width;
    }
    // If menu close mode is 'Default' then menu width is not changing
    else {
      if (widget.menuWidth.isFinite) {
        return widget.menuWidth;
      } else if (widget.menuSpacing != 0) {
        return _availableSize.width - widget.menuSpacing;
      } else {
        return _availableSize.width;
      }
    }
  }

  ///
  /// Get menu max width
  ///
  double getMenuMaxWidth() {
    return widget.menuWidth.isInfinite
        ? _availableSize.width - widget.menuSpacing
        : widget.menuWidth;
  }

  ///
  /// Get submenu offset
  ///
  double getSubMenuX() {
    double menuRight = actualMenuRight;
    double menuWidth = getActualMenuWidth();
    double subMenuWidth = getActualSubMenuWidth();
    double subMenuRight = 0;

    if (widget.menuLocation == MenuLocation.left) {
      subMenuRight = menuRight + subMenuWidth;
    } else {
      subMenuRight = menuRight - menuWidth;
    }

    double fixedPanX = 0;

    // Menu on left
    if (widget.menuLocation == MenuLocation.left) {
      if (_subMenuAnimation != null &&
          _subMenuAnimation!.value.isNaN == false) {
        if (_panUpdateDetails != null &&
            _panStartDetails != null &&
            _panUpdateDetails!.globalPosition.dx < subMenuRight) {
          double fixedPanStart = 0;
          if (_panStartDetails!.globalPosition.dx < subMenuRight) {
            fixedPanStart = subMenuRight - _panUpdateDetails!.globalPosition.dx;
          }
          fixedPanX = subMenuRight -
              _panUpdateDetails!.globalPosition.dx -
              fixedPanStart;
        }

        double startX = menuRight - subMenuWidth;
        double endX = menuRight;

        double offsetX =
            startX + (endX - startX) * _subMenuAnimation!.value - fixedPanX;
        offsetX = max<double>(startX, offsetX);
        offsetX = min<double>(endX, offsetX);
        return offsetX;
      } else if (_isSubMenuOpen) {
        return menuRight;
      } else {
        return menuRight - subMenuWidth;
      }
    }
    // Menu on right
    else {
      double menuX = getMenuX();

      if (_panUpdateDetails != null &&
          _panStartDetails != null &&
          _panUpdateDetails!.globalPosition.dx > subMenuRight - subMenuWidth) {
        // If pan started inside submenu
        double fixedPanStart = 0;
        if (_panStartDetails!.globalPosition.dx >
            menuRight - menuWidth - subMenuWidth) {
          fixedPanStart = _panStartDetails!.globalPosition.dx -
              (menuRight - menuWidth - subMenuWidth);
        }

        fixedPanX = _panUpdateDetails!.globalPosition.dx -
            (menuRight - menuWidth - subMenuWidth) -
            fixedPanStart;
      }

      if (_subMenuAnimation != null &&
          _subMenuAnimation!.value.isNaN == false) {
        double startX = menuX;
        double endX = startX - subMenuWidth;
        double offsetX =
            startX + (endX - startX) * _subMenuAnimation!.value + fixedPanX;
        offsetX = max<double>(endX, offsetX);
        offsetX = min<double>(startX, offsetX);
        return offsetX;
      } else if (_isSubMenuOpen) {
        return menuX - subMenuWidth;
      } else {
        return menuX;
      }
    }
  }

  ///
  /// Get submenu actual width
  ///
  double getActualSubMenuWidth() {
    if (widget.submenu == null) {
      return 0;
    } else {
      return widget.subMenuWidth.isFinite
          ? widget.subMenuWidth
          : _availableSize.width;
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

    if (menuOpenPercent < 0.5 ||
        (_panUpdateDetails!.delta.dx.abs() > 10 &&
            _panUpdateDetails!.globalPosition.dx < menuRight)) {
      isMenuOpen = false;
    } else {
      isMenuOpen = true;
    }

    if (getSubMenuOpenPercent() < 0.5 ||
        (_panUpdateDetails!.delta.dx.abs() > 10 &&
            _panUpdateDetails!.globalPosition.dx < subMenuRight)) {
      isSubMenuOpen = false;
    } else {
      isSubMenuOpen = true;
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
    double actualBorderWidth = widget.verticalSeparatorThickness;
    if (widget.verticalSeparatorColor == Colors.transparent ||
        widget.verticalSeparatorThickness == 0) {
      actualBorderWidth = 0;
    }

    BorderSide borderSide = BorderSide(
      width: actualBorderWidth,
      color: widget.verticalSeparatorColor,
    );

    if (widget.menuLocation == MenuLocation.left) {
      return BoxDecoration(
        border: Border(
          right: borderSide,
        ),
      );
    } else {
      return BoxDecoration(
        border: Border(
          left: borderSide,
        ),
      );
    }
  }
}

///
/// SideBar controller
///
class SideBarController extends ChangeNotifier {
  bool _isSubMenuOpen = false;
  bool _isMenuOpen = false;

  bool get isSubMenuOpen => _isSubMenuOpen;
  set isSubMenuOpen(bool isOpen) {
    _isSubMenuOpen = isOpen;
    notifyListeners();
  }

  bool get isMenuOpen => _isMenuOpen;
  set isMenuOpen(bool isOpen) {
    _isMenuOpen = isOpen;
    notifyListeners();
  }
}
