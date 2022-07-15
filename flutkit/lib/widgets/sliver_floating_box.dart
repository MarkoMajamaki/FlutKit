import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// Sliver to add left floating sidebar to web page
///
class SliverFloatingBox extends SingleChildRenderObjectWidget {
  final double? pinnedToolBarHeight;

  const SliverFloatingBox({
    Widget? child,
    this.pinnedToolBarHeight,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RenderSliverFloatingBox createRenderObject(BuildContext context) =>
      RenderSliverFloatingBox(pinnedToolBarHeight: pinnedToolBarHeight);
}

class RenderSliverFloatingBox extends RenderSliverSingleBoxAdapter {
  final double? pinnedToolBarHeight;

  RenderSliverFloatingBox({
    RenderBox? child,
    this.pinnedToolBarHeight,
  }) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    double actualOverlap = pinnedToolBarHeight ?? constraints.overlap;

    child!.layout(
        constraints.asBoxConstraints(
            maxExtent: constraints.viewportMainAxisExtent - actualOverlap),
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
        max(0, constraints.remainingPaintExtent - actualOverlap);

    geometry = SliverGeometry(
      scrollExtent: 0,
      paintOrigin: constraints.overlap,
      paintExtent:
          min(childExtent, effectiveRemainingPaintExtent) - constraints.overlap,
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
