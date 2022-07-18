import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {Key? key,
      this.mobileBody,
      this.tabletBody,
      this.desktopBody,
      this.mobileMaxWidth = 800,
      this.tabletMaxWidth = 1000})
      : super(key: key);

  final Widget? mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;

  final double mobileMaxWidth;
  final double tabletMaxWidth;

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

            if (originalWidth < widget.mobileMaxWidth &&
                widget.mobileBody != null) {
              layoutType = ResponsiveLayoutTypes.mobile;
              return widget.mobileBody!;
            } else if (originalWidth < widget.tabletMaxWidth &&
                widget.tabletBody != null) {
              layoutType = ResponsiveLayoutTypes.tablet;
              return widget.tabletBody!;
            } else if (widget.desktopBody != null) {
              layoutType = ResponsiveLayoutTypes.deskotp;
              return widget.desktopBody!;
            } else if (widget.desktopBody != null ||
                widget.tabletBody != null ||
                widget.mobileBody != null) {
              return widget.desktopBody ??
                  widget.tabletBody ??
                  widget.mobileBody!;
            } else {
              throw Exception();
            }
          }),
        );
      },
    );
  }
}

enum ResponsiveLayoutTypes {
  mobile,
  tablet,
  deskotp,
}
