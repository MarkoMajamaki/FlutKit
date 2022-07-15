import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {Key? key,
      required this.mobileBody,
      required this.tabletBody,
      required this.desktopBody,
      required this.mobileMaxWidth,
      required this.tabletMaxWidth})
      : super(key: key);

  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

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

            if (originalWidth < widget.mobileMaxWidth) {
              layoutType = ResponsiveLayoutTypes.mobile;
              return widget.mobileBody;
            } else if (originalWidth < widget.tabletMaxWidth) {
              layoutType = ResponsiveLayoutTypes.tablet;
              return widget.tabletBody;
            } else {
              layoutType = ResponsiveLayoutTypes.deskotp;
              return widget.desktopBody;
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
