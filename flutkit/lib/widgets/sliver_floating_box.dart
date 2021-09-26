import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// Sliver to add left floating sidebar to web page
///
class SliverFloatingBox extends SingleChildRenderObjectWidget {
  SliverFloatingBox({
    Widget? child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RenderSliverFloatingBox createRenderObject(BuildContext context) =>
      RenderSliverFloatingBox();
}

class RenderSliverFloatingBox extends RenderSliverSingleBoxAdapter {
  RenderSliverFloatingBox({
    RenderBox? child,
  }) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    child!.layout(
        this.constraints.asBoxConstraints(
            maxExtent: constraints.remainingPaintExtent - constraints.overlap),
        parentUsesSize: true);

    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = constraints.remainingPaintExtent;
        break;
    }

    final double effectiveRemainingPaintExtent =
        max(0, constraints.remainingPaintExtent - constraints.overlap);

    geometry = SliverGeometry(
      scrollExtent: 0,
      paintOrigin: constraints.overlap,
      paintExtent: min(childExtent, effectiveRemainingPaintExtent),
      layoutExtent: 0,
      maxPaintExtent: childExtent,
      maxScrollObstructionExtent: childExtent,
      hasVisualOverflow: false,
    );
  }

  @override
  double childMainAxisPosition(covariant RenderBox child) {
    return 0;
  }
}
