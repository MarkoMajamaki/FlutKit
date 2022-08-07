import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {Key? key,
      mobileBody,
      tabletBody,
      desktopBody,
      mobileMaxWidth = 800.0,
      tabletMaxWidth = 1000.0})
      : _mobileBody = mobileBody,
        _tabletBody = tabletBody,
        _desktopBody = desktopBody,
        _mobileMaxWidth = mobileMaxWidth,
        _tabletMaxWidth = tabletMaxWidth,
        super(key: key);

  final Widget? Function()? _mobileBody;
  final Widget? Function()? _tabletBody;
  final Widget? Function()? _desktopBody;

  final double _mobileMaxWidth;
  final double _tabletMaxWidth;

  @override
  State<ResponsiveLayout> createState() => ResponsiveLayoutState();

  ///
  /// Get first ResponsiveLayout ancestor state
  ///
  static ResponsiveLayoutState of(BuildContext context) {
    ResponsiveLayoutState? state =
        context.findAncestorStateOfType<ResponsiveLayoutState>();

    if (state == null) {
      throw FlutterError(
          "SideBar operation requested with a context that does not include a SideBar as descendand.");
    }

    return state;
  }
}

class ResponsiveLayoutState extends State<ResponsiveLayout> {
  ///
  /// Current layout type
  ///
  late ResponsiveLayoutTypes layoutType;

  ///
  /// Build correct body based on constraints
  ///
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: ((context, constraints) {
            // Fixed with based on orientation
            double originalWidth = constraints.maxWidth;

            if (orientation == Orientation.landscape) {
              originalWidth = constraints.maxHeight;
            }

            return _buildBody(originalWidth);
          }),
        );
      },
    );
  }

  ///
  /// Build body based on width
  ///
  Widget _buildBody(double originalWidth) {
    if (originalWidth < widget._mobileMaxWidth && widget._mobileBody != null) {
      layoutType = ResponsiveLayoutTypes.mobile;
      return widget._mobileBody!()!;
    } else if (originalWidth < widget._tabletMaxWidth &&
        widget._tabletBody != null) {
      layoutType = ResponsiveLayoutTypes.tablet;
      return widget._tabletBody!()!;
    } else if (widget._desktopBody != null) {
      layoutType = ResponsiveLayoutTypes.deskotp;
      return widget._desktopBody!()!;
    } else if (widget._desktopBody != null ||
        widget._tabletBody != null ||
        widget._mobileBody != null) {
      if (widget._desktopBody != null) {
        return widget._desktopBody!()!;
      } else if (widget._tabletBody != null) {
        return widget._tabletBody!()!;
      } else {
        return widget._mobileBody!()!;
      }
    } else {
      throw Exception();
    }
  }
}

enum ResponsiveLayoutTypes {
  mobile,
  tablet,
  deskotp,
}
