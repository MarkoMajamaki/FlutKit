import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'dart:math';
import 'dart:core';

enum WrapOrientation { Vertical, Horizontal }

///
/// Layout children vertical or horizontal and start new line if not enought space
///
class WrapLayout extends MultiChildRenderObjectWidget {
  final double columnWidth;
  final double columnMinWidth;
  final double columnMaxWidth;
  final int columnsCount;
  final int maxColumnsCount;
  final double columnSpacing;
  final double rowSpacing;
  final WrapOrientation orientation;

  WrapLayout(
      {Key key,
      double columnWidth,
      double columnMaxWidth,
      double columnMinWidth,
      int columnsCount,
      int maxColumnsCount,
      double columnSpacing,
      double rowSpacing,
      WrapOrientation orientation,
      List<Widget> children = const []})
      : this.columnWidth = columnWidth,
        this.columnMaxWidth = columnMaxWidth,
        this.columnMinWidth = columnMinWidth,
        this.columnsCount = columnsCount,
        this.maxColumnsCount = maxColumnsCount,
        this.columnSpacing = columnSpacing,
        this.rowSpacing = rowSpacing,
        this.orientation = orientation ?? WrapOrientation.Horizontal,
        super(key: key, children: children);

  ///
  /// Create render object to render widgets
  ///
  @override
  RenderWrapLayout createRenderObject(BuildContext context) {
    return RenderWrapLayout(
        columnWidth: columnWidth,
        columnMaxWidth: columnMaxWidth,
        columnMinWidth: columnMinWidth,
        columnsCount: columnsCount,
        maxColumnsCount: maxColumnsCount,
        columnSpacing: columnSpacing,
        rowSpacing: rowSpacing,
        orientation: orientation);
  }

  ///
  /// Take existing render object and update values inside it
  ///
  @override
  void updateRenderObject(BuildContext context, RenderWrapLayout renderObject) {
    renderObject
      ..columnWidth = columnWidth
      ..columnMaxWidth = columnMaxWidth
      ..columnMinWidth = columnMinWidth
      ..columnsCount = columnsCount
      ..maxColumnsCount = maxColumnsCount
      ..columnSpacing = columnSpacing
      ..rowSpacing = rowSpacing
      ..orientation = orientation;
  }
}

///
/// Implements wrap layout algorithm
///
class RenderWrapLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, WrapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, WrapParentData> {
  double _actualColumnWidth = 0;
  int _actualColumnCount = 0;

  RenderWrapLayout({
    double columnWidth,
    double columnMaxWidth,
    double columnMinWidth,
    int columnsCount,
    int maxColumnsCount,
    double columnSpacing,
    double rowSpacing,
    WrapOrientation orientation = WrapOrientation.Horizontal,
  })  : _columnWidth = columnWidth,
        _columnMaxWidth = columnMaxWidth,
        _columnMinWidth = columnMinWidth,
        _columnsCount = columnsCount,
        _maxColumnsCount = maxColumnsCount,
        _columnSpacing = columnSpacing,
        _rowSpacing = rowSpacing,
        _orientation = orientation;

  ///
  /// Properties
  ///

  double get columnWidth => _columnWidth;
  double _columnWidth;
  set columnWidth(double value) {
    _columnWidth = value;
    markNeedsLayout();
  }

  double get columnMaxWidth => _columnMaxWidth;
  double _columnMaxWidth;
  set columnMaxWidth(double value) {
    _columnMaxWidth = value;
    markNeedsLayout();
  }

  double get columnMinWidth => _columnMinWidth;
  double _columnMinWidth;
  set columnMinWidth(double value) {
    _columnMinWidth = value;
    markNeedsLayout();
  }

  int get columnsCount => _columnsCount;
  int _columnsCount;
  set columnsCount(int value) {
    _columnsCount = value;
    markNeedsLayout();
  }

  int get maxColumnsCount => _maxColumnsCount;
  int _maxColumnsCount;
  set maxColumnsCount(int value) {
    _maxColumnsCount = value;
    markNeedsLayout();
  }

  double get columnSpacing => _columnSpacing;
  double _columnSpacing;
  set columnSpacing(double value) {
    _columnSpacing = value;
    markNeedsLayout();
  }

  double get rowSpacing => _rowSpacing;
  double _rowSpacing;
  set rowSpacing(double value) {
    _rowSpacing = value;
    markNeedsLayout();
  }

  WrapOrientation get orientation => _orientation;
  WrapOrientation _orientation;
  set orientation(WrapOrientation value) {
    _orientation = value;
    markNeedsLayout();
  }

  ///
  /// Check wheter the data type used by the child conforms to the setupParentData
  /// in the RenderBox. If it does not conform to the data type, create and
  /// replace it again
  ///
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! WrapParentData)
      child.parentData = WrapParentData();
  }

  ///
  /// Dimension
  ///

  @override
  double computeMinIntrinsicWidth(double height) {
    List<Rect> childrenLocations = _layoutChildren();
    double width = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      width = max(width, childrenLocations.elementAt(i).right);
    }

    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    List<Rect> childrenLocations = _layoutChildren();
    double width = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      width = max(width, childrenLocations.elementAt(i).right);
    }
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    List<Rect> childrenLocations = _layoutChildren();
    double height = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      height = max(height, childrenLocations.elementAt(i).bottom);
    }
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    List<Rect> childrenLocations = _layoutChildren();
    double height = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      height = max(height, childrenLocations.elementAt(i).bottom);
    }
    return height;
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  ///
  /// Do layout
  ///
  @override
  void performLayout() {
    List<Rect> childrenLocations = _layoutChildren();

    double height = 0;
    double width = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      height = max(height, childrenLocations.elementAt(i).bottom);
      width = max(width, childrenLocations.elementAt(i).right);
    }

    this.size = Size(width, height);
  }

  ///
  /// Do painting
  ///
  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  ///
  /// Layout children
  ///
  List<Rect> _layoutChildren() {
    if (_orientation == WrapOrientation.Horizontal) {
      return _layoutChildrenHorizontally();
    } else {
      return _layoutChildrenVertical();
    }
  }

  ///
  /// Layout and calculate children locations when wrapped horizontally. Return
  /// children locations
  ///
  List<Rect> _layoutChildrenHorizontally() {
    _calculateColumns(constraints.maxWidth);

    // Children locations
    List<Rect> locations = List<Rect>();

    final double actualColumnSpacing = _columnSpacing ?? 0;
    final double actualRowSpacing = _rowSpacing ?? 0;
    final double actualColumnMaxWidth = _columnMaxWidth ?? double.maxFinite;
    final double actualColumnMinWidth = _columnMinWidth ?? 0;

    if (_columnWidth == null &&
        actualColumnMinWidth == 0 &&
        actualColumnMaxWidth == double.maxFinite &&
        _columnsCount == null) {
      ///
      /// If no columns
      ///

      double horizontalOffset = 0;
      double verticalOffset = 0;
      double currentRowHeight = 0;

      var child = firstChild;
      while (child != null) {
        WrapParentData childParentData = child.parentData as WrapParentData;

        child.layout(constraints, parentUsesSize: true);
        final bool newRow =
            horizontalOffset + child.size.width > constraints.maxWidth;

        if (newRow || childParentData.fillRow || childParentData.rowStart) {
          verticalOffset += currentRowHeight;
          horizontalOffset = 0;
          currentRowHeight = 0;
        }

        Rect location;
        if (childParentData.fillRow) {
          location = Rect.fromLTWH(horizontalOffset, verticalOffset,
              constraints.maxWidth, child.size.height);
        } else if (childParentData.rowEnd) {
          location = Rect.fromLTWH(horizontalOffset, verticalOffset,
              constraints.maxWidth - horizontalOffset, child.size.height);
        } else {
          location = Rect.fromLTWH(horizontalOffset, verticalOffset,
              child.size.width, child.size.height);
        }

        childParentData.offset = Offset(location.left, location.top);

        locations.add(location);

        horizontalOffset += child.size.width + actualColumnSpacing;

        // Update current row height
        if (currentRowHeight < child.size.height + actualRowSpacing) {
          currentRowHeight = child.size.height + actualRowSpacing;
        }

        if (childParentData.fillRow || childParentData.rowEnd) {
          verticalOffset += currentRowHeight;
          horizontalOffset = 0;
          currentRowHeight = 0;
        }

        child = childParentData.nextSibling;
      }
    } else {
      ///
      /// If columns
      ///

      double currentColumnIndex = 0;
      double currentRowHeight = 0;
      double verticalOffset = 0;

      var child = firstChild;
      while (child != null) {
        WrapParentData childParentData = child.parentData as WrapParentData;

        bool newRow = currentColumnIndex +
                (childParentData.columnSpan > 1
                    ? childParentData.columnSpan
                    : 1) >
            _actualColumnCount;

        // If there is no enought free columns on the right or children is filled to whole row, go to new row
        if (newRow || childParentData.fillRow || childParentData.rowStart) {
          verticalOffset += currentRowHeight;
          currentColumnIndex = 0;
          currentRowHeight = 0;
        }

        double childAvailableWidth = 0;
        if (childParentData.fillRow &&
            constraints.widthConstraints().maxWidth.isFinite) {
          childAvailableWidth = constraints.maxWidth;
        } else {
          // Add column span to available width
          childAvailableWidth = _actualColumnWidth *
              (childParentData.columnSpan == 0
                  ? 1
                  : childParentData.columnSpan);

          if (currentColumnIndex + childParentData.columnSpan >
              _actualColumnCount) {
            childAvailableWidth += actualColumnSpacing;
          } else {
            int widthInColumns =
                childParentData.columnSpan > 1 ? childParentData.columnSpan : 1;

            if (childParentData.nextSibling != null) {
              WrapParentData nextChildParentData =
                  childParentData.nextSibling.parentData as WrapParentData;

              // If not last child, then add available span between columns to child available width
              int nextChildWidthInColumns = nextChildParentData.columnSpan > 1
                  ? nextChildParentData.columnSpan
                  : 1;

              // IS next child going to new row
              if (nextChildParentData.fillRow ||
                  currentColumnIndex +
                          widthInColumns +
                          nextChildWidthInColumns >=
                      _actualColumnCount ||
                  childParentData.rowEnd ||
                  nextChildParentData.rowStart) {
                childAvailableWidth +=
                    actualColumnSpacing * max(0, widthInColumns - 1);
              }
            } else {
              // If last child and has span, then add all space between columns to child available width
              childAvailableWidth +=
                  actualColumnSpacing * max(0, widthInColumns - 1);
            }
          }
        }

        double horizontalOffset =
            currentColumnIndex * (_actualColumnWidth + actualColumnSpacing);

        // If row is ending, then take all available width (ignore column spanning)
        if (childParentData.rowEnd) {
          childAvailableWidth = constraints.maxWidth - horizontalOffset;
        } else {
          // Prevent child to spanned out of the available width when column span is used and column has static width
          childAvailableWidth =
              min(childAvailableWidth, constraints.maxWidth - horizontalOffset);

          child.layout(
              BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: childAvailableWidth,
                  maxHeight: constraints.maxHeight),
              parentUsesSize: true);

          // Update current row height
          if (currentRowHeight < child.size.height + actualRowSpacing) {
            currentRowHeight = child.size.height + actualRowSpacing;
          }

          Rect location = Rect.fromLTWH(horizontalOffset, verticalOffset,
              childAvailableWidth, child.size.height);

          locations.add(location);

          childParentData.offset = Offset(location.left, location.top);

          // Increase column counter
          currentColumnIndex +=
              childParentData.columnSpan > 1 ? childParentData.columnSpan : 1;

          if (childParentData.fillRow || childParentData.rowEnd) {
            verticalOffset += currentRowHeight;
            currentColumnIndex = 0;
            currentRowHeight = 0;
          }
        }
        child = childParentData.nextSibling;
      }
    }

    return locations;
  }

  ///
  /// Layout children vertical
  ///
  List<Rect> _layoutChildrenVertical() {
    _calculateColumns(constraints.maxWidth);

    // Children locations
    List<Rect> locations = List<Rect>();

    int nextWholeRowChildIndex = _getNextWholeRowChildIndex(0);
    int groupChildrenCount = nextWholeRowChildIndex;

    int minChildrenInOneColumn =
        (groupChildrenCount / _actualColumnCount).floor();
    int childrenCountLeftToFirstColumns =
        groupChildrenCount - (minChildrenInOneColumn * _actualColumnCount);
    double yOffset = 0;

    int groupColumn = 0;
    int groupColumnIndex = 0;

    List<double> columnHeights = List<double>();

    // final double actualColumnSpacing = ;
    final double actualRowSpacing = _rowSpacing ?? 0;

    var child = firstChild;
    for (int i = 0; i < childCount; i++) {
      WrapParentData childParentData = child.parentData as WrapParentData;
      double actualColumnSpacing = groupColumn > 0 ? _columnSpacing ?? 0 : 0;

      if (i == nextWholeRowChildIndex) {
        if (columnHeights.length > 0) {
          yOffset += columnHeights.reduce(max);
          columnHeights.clear();

          nextWholeRowChildIndex = _getNextWholeRowChildIndex(i + 1);
          groupChildrenCount = i + 1 - nextWholeRowChildIndex;

          minChildrenInOneColumn =
              (groupChildrenCount / _actualColumnCount).floor();

          childrenCountLeftToFirstColumns = groupChildrenCount -
              (minChildrenInOneColumn * _actualColumnCount);

          groupColumn = 0;
          groupColumnIndex = 0;

          child.layout(
              BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight),
              parentUsesSize: true);

          Rect location = Rect.fromLTWH(
              0, yOffset, constraints.maxWidth, child.size.height);

          childParentData.offset = Offset(location.left, location.top);

          locations.add(location);

          yOffset += child.size.height + actualRowSpacing;
        }
      } else {
        double columnYOffset =
            columnHeights.length > groupColumn ? columnHeights[groupColumn] : 0;

        double childAvailableWidth =
            min(_actualColumnWidth, constraints.maxWidth);

        child.layout(
            BoxConstraints(
                minWidth: 0,
                minHeight: 0,
                maxWidth: childAvailableWidth,
                maxHeight: constraints.maxHeight),
            parentUsesSize: true);

        Rect location = Rect.fromLTWH(
            groupColumn * (_actualColumnWidth + actualColumnSpacing),
            yOffset + columnYOffset,
            childAvailableWidth,
            child.size.height);

        childParentData.offset = Offset(location.left, location.top);

        locations.add(location);

        if (columnHeights.length <= groupColumn) {
          columnHeights.add(location.height + actualRowSpacing);
          groupColumnIndex = 0;
        } else {
          columnHeights[groupColumn] =
              columnHeights[groupColumn] + location.height + actualRowSpacing;
          groupColumnIndex++;
        }

        if (groupColumnIndex >=
            (minChildrenInOneColumn - 1) +
                (childrenCountLeftToFirstColumns > 0 ? 1 : 0)) {
          groupColumn++;
          childrenCountLeftToFirstColumns--;
        }
      }

      child = childParentData.nextSibling;
    }

    return locations;
  }

  ///
  /// Calculate columns actual width and count
  ///
  void _calculateColumns(double availableWidth) {
    final double actualColumnSpacing = _columnSpacing ?? 0;
    final double actualColumnMaxWidth = _columnMaxWidth ?? double.maxFinite;
    final double actualColumnMinWidth = _columnMinWidth ?? 0;
    final int actualMaxColumnsCount = _maxColumnsCount ?? 100000;

    if (_columnsCount != null) {
      _actualColumnCount = _columnsCount;
      double columnWidthCandidate =
          ((availableWidth + actualColumnSpacing) / _actualColumnCount) -
              actualColumnSpacing;
      _actualColumnWidth =
          max(0, min(columnWidthCandidate, actualColumnMaxWidth));
    } else if (_columnWidth == null) {
      int columnCountCandidate = 0;
      if (_columnMinWidth != null) {
        columnCountCandidate = ((availableWidth - actualColumnSpacing) /
                (max(1, actualColumnMinWidth) + actualColumnSpacing))
            .floor();
      } else if (actualColumnMaxWidth < double.maxFinite) {
        columnCountCandidate = ((availableWidth + actualColumnSpacing) /
                (max(1, actualColumnMaxWidth) + actualColumnSpacing))
            .ceil();
      } else if (_columnMinWidth == null && _columnMaxWidth == null) {
        _actualColumnCount = -1;
        _actualColumnWidth = -1;
      }

      _actualColumnCount =
          max(1, min(columnCountCandidate, actualMaxColumnsCount));

      double columnWidthCandidate =
          ((availableWidth + actualColumnSpacing) / _actualColumnCount) -
              actualColumnSpacing;

      _actualColumnWidth =
          max(0, min(columnWidthCandidate, actualColumnMaxWidth));
    } else {
      _actualColumnCount = max(
          1,
          min(
                  actualMaxColumnsCount,
                  (availableWidth + actualColumnSpacing) /
                      (_columnWidth + actualColumnSpacing))
              .floor());
      _actualColumnWidth = _columnWidth;
    }
  }

  ///
  /// Get next child which fill whole row
  ///
  int _getNextWholeRowChildIndex(int startIndex) {
    var child = firstChild;

    for (int i = 0; i < startIndex; i++) {
      WrapParentData childParentData = child.parentData as WrapParentData;
      child = childParentData.nextSibling;
    }

    for (int i = startIndex; i < childCount; i++) {
      WrapParentData childParentData = child.parentData as WrapParentData;

      if (childParentData.fillRow) {
        return i;
      }

      child = childParentData.nextSibling;
    }

    return childCount;
  }
}

///
/// WrapLayout parent data containing placement properties
///
class WrapParentData extends ContainerBoxParentData<RenderBox> {
  bool rowStart;
  bool rowEnd;
  int columnSpan;
  bool fillRow;

  WrapParentData(
      {this.rowStart = false,
      this.rowEnd = false,
      this.columnSpan = 1,
      this.fillRow = false});
}

///
/// Widget placement properties in WrapLayout
///
class WrapLayoutPlacement extends ParentDataWidget<WrapParentData> {
  final bool rowStart;
  final bool rowEnd;
  final int columnSpan;
  final bool fillRow;

  const WrapLayoutPlacement({
    Key key,
    @required child,
    rowStart = false,
    rowEnd = false,
    columnSpan = 1,
    fillRow = false,
  })  : this.columnSpan = columnSpan ?? 1,
        this.rowStart = rowStart ?? false,
        this.rowEnd = rowEnd ?? false,
        this.fillRow = fillRow ?? false,
        super(key: key, child: child);

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is WrapParentData);

    final parentData = renderObject.parentData as WrapParentData;
    bool needsLayout = false;

    if (parentData.columnSpan != columnSpan) {
      parentData.columnSpan = columnSpan;
      needsLayout = true;
    }

    if (parentData.rowStart != rowStart) {
      parentData.rowStart = rowStart;
      needsLayout = true;
    }

    if (parentData.rowEnd != rowEnd) {
      parentData.rowEnd = rowEnd;
      needsLayout = true;
    }

    if (parentData.fillRow != fillRow) {
      parentData.fillRow = fillRow;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => WrapLayout;
}

///
/// Widget extension for WrapLayout placement
///
extension WrapLayoutPlacementExtension on Widget {
  WrapLayoutPlacement withWrapPlacement(
      {Key key,
      rowStart = false,
      rowEnd = false,
      columnSpan = 1,
      fillRow = false}) {
    return WrapLayoutPlacement(
      key: key,
      columnSpan: columnSpan,
      rowStart: rowStart,
      rowEnd: rowEnd,
      fillRow: fillRow,
      child: this,
    );
  }
}
