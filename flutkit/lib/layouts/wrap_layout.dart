import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'dart:math';
import 'dart:core';

enum WrapOrientation { vertical, horizontal }

///
/// Layout children vertical or horizontal and start new line if not enought space
///
class WrapLayout extends MultiChildRenderObjectWidget {
  final double? columnWidth;
  final double columnMinWidth;
  final double columnMaxWidth;
  final int? columnsCount;
  final int? maxColumnsCount;
  final double columnSpacing;
  final double rowSpacing;
  final WrapOrientation orientation;

  WrapLayout({
    Key? key,
    this.columnWidth,
    this.columnMaxWidth = double.maxFinite,
    this.columnMinWidth = 0,
    this.columnsCount,
    this.maxColumnsCount,
    this.columnSpacing = 0,
    this.rowSpacing = 0,
    this.orientation = WrapOrientation.horizontal,
    children,
  }) : super(key: key, children: children);

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
    double? columnWidth,
    double columnMaxWidth = double.maxFinite,
    double columnMinWidth = 0,
    int? columnsCount,
    int? maxColumnsCount,
    double columnSpacing = 0,
    double rowSpacing = 0,
    WrapOrientation orientation = WrapOrientation.horizontal,
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

  double? get columnWidth => _columnWidth;
  double? _columnWidth;
  set columnWidth(double? value) {
    if (_columnWidth == value) return;
    _columnWidth = value;
    markNeedsLayout();
  }

  double get columnMaxWidth => _columnMaxWidth;
  double _columnMaxWidth = double.maxFinite;
  set columnMaxWidth(double value) {
    if (_columnMaxWidth == value) return;
    _columnMaxWidth = value;
    markNeedsLayout();
  }

  double get columnMinWidth => _columnMinWidth;
  double _columnMinWidth = 0;
  set columnMinWidth(double value) {
    if (_columnMinWidth == value) return;
    _columnMinWidth = value;
    markNeedsLayout();
  }

  int? get columnsCount => _columnsCount;
  int? _columnsCount;
  set columnsCount(int? value) {
    if (_columnsCount == value) return;
    _columnsCount = value;
    markNeedsLayout();
  }

  int? get maxColumnsCount => _maxColumnsCount;
  int? _maxColumnsCount;
  set maxColumnsCount(int? value) {
    if (_maxColumnsCount == value) return;
    _maxColumnsCount = value;
    markNeedsLayout();
  }

  double get columnSpacing => _columnSpacing;
  double _columnSpacing = 0;
  set columnSpacing(double value) {
    if (_columnSpacing == value) return;
    _columnSpacing = value;
    markNeedsLayout();
  }

  double get rowSpacing => _rowSpacing;
  double _rowSpacing = 0;
  set rowSpacing(double value) {
    if (_rowSpacing == value) return;
    _rowSpacing = value;
    markNeedsLayout();
  }

  WrapOrientation get orientation => _orientation;
  WrapOrientation _orientation = WrapOrientation.horizontal;
  set orientation(WrapOrientation value) {
    if (_orientation == value) return;
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
    if (child.parentData is! WrapParentData) {
      child.parentData = WrapParentData();
    }
  }

  ///
  /// Dimension
  ///

  @override
  double computeMinIntrinsicWidth(double height) {
    List<Rect> childrenLocations = _layoutChildren(double.infinity, height);
    double width = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      width = max(width, childrenLocations.elementAt(i).right);
    }

    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    List<Rect> childrenLocations = _layoutChildren(double.infinity, height);
    double width = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      width = max(width, childrenLocations.elementAt(i).right);
    }
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    List<Rect> childrenLocations = _layoutChildren(width, double.infinity);
    double height = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      height = max(height, childrenLocations.elementAt(i).bottom);
    }
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    List<Rect> childrenLocations = _layoutChildren(width, double.infinity);
    double height = 0;
    for (int i = 0; i < childrenLocations.length; i++) {
      height = max(height, childrenLocations.elementAt(i).bottom);
    }
    return height;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  ///
  /// Do layout
  ///
  @override
  void performLayout() {
    List<Rect> childrenLocations = _layoutChildren(
      constraints.maxWidth,
      constraints.maxHeight,
    );

    double height = 0;
    double width = 0;

    var child = firstChild;

    for (int i = 0; i < childrenLocations.length; i++) {
      height = max(height, childrenLocations.elementAt(i).bottom);
      width = max(width, childrenLocations.elementAt(i).right);

      // Do actual layout
      child!.layout(
        BoxConstraints(
          maxWidth: childrenLocations.elementAt(i).width,
          maxHeight: childrenLocations.elementAt(i).height,
          minWidth: 0,
          minHeight: 0,
        ),
        parentUsesSize: true,
      );

      WrapParentData childParentData = child.parentData as WrapParentData;
      child = childParentData.nextSibling;
    }

    size = Size(width, height);
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
  List<Rect> _layoutChildren(double maxWidth, double maxHeight) {
    if (_orientation == WrapOrientation.horizontal) {
      return _layoutChildrenHorizontally(maxWidth);
    } else {
      return _layoutChildrenVertical(maxWidth);
    }
  }

  ///
  /// Layout and calculate children locations when wrapped horizontally. Return
  /// children locations
  ///
  List<Rect> _layoutChildrenHorizontally(double maxWidth) {
    _calculateColumns(maxWidth);

    // Children locations
    List<Rect> locations = [];

    if (_columnWidth == null &&
        _columnMinWidth == 0 &&
        _columnMaxWidth == double.maxFinite &&
        _columnsCount == null) {
      ///
      /// If no columns
      ///

      double xOffset = 0;
      double yOffset = 0;
      double currentRowHeight = 0;

      var child = firstChild;
      while (child != null) {
        WrapParentData childParentData = child.parentData as WrapParentData;

        // Do dry layout measurements
        Size childSize = child.getDryLayout(
          BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: double.infinity,
            minWidth: 0,
            minHeight: 0,
          ),
        );

        final bool newRow = xOffset + childSize.width > maxWidth;

        if (newRow || childParentData.fillRow || childParentData.rowStart) {
          yOffset += currentRowHeight;
          xOffset = 0;
          currentRowHeight = 0;
        }

        Rect location;
        if (childParentData.fillRow) {
          location =
              Rect.fromLTWH(xOffset, yOffset, maxWidth, childSize.height);
        } else if (childParentData.rowEnd) {
          location = Rect.fromLTWH(
              xOffset, yOffset, maxWidth - xOffset, childSize.height);
        } else {
          location = Rect.fromLTWH(
              xOffset, yOffset, childSize.width, childSize.height);
        }

        childParentData.offset = Offset(location.left, location.top);

        locations.add(location);

        xOffset += childSize.width + _columnSpacing;

        // Update current row height
        if (currentRowHeight < childSize.height + _rowSpacing) {
          currentRowHeight = childSize.height + _rowSpacing;
        }

        if (childParentData.fillRow || childParentData.rowEnd) {
          yOffset += currentRowHeight;
          xOffset = 0;
          currentRowHeight = 0;
        }

        child = childParentData.nextSibling;
      }
    } else {
      ///
      /// If columns
      ///

      double columnIndex = 0;
      double currentRowHeight = 0;
      double yOffset = 0;

      var child = firstChild;
      while (child != null) {
        WrapParentData childParentData = child.parentData as WrapParentData;

        int childColumnSpan = 1;
        if (childParentData.columnSpan > 1) {
          childColumnSpan = childParentData.columnSpan;
        }

        bool newRow = columnIndex + childColumnSpan > _actualColumnCount;

        // If there is no enought free columns on the right or children is filled to whole row, go to new row
        if (newRow || childParentData.fillRow || childParentData.rowStart) {
          yOffset += currentRowHeight;
          columnIndex = 0;
          currentRowHeight = 0;
        }

        double childAvailableWidth = 0;
        if (childParentData.fillRow && maxWidth.isFinite) {
          childAvailableWidth = maxWidth;
        } else {
          // Add column span to available width
          childAvailableWidth = _actualColumnWidth * childColumnSpan;

          if (columnIndex + childParentData.columnSpan > _actualColumnCount) {
            childAvailableWidth += _columnSpacing;
          } else {
            int widthInColumns = childColumnSpan;

            if (childParentData.nextSibling != null &&
                childParentData.nextSibling!.parentData != null) {
              WrapParentData nextChildParentData =
                  childParentData.nextSibling!.parentData as WrapParentData;

              // If not last child, then add available span between columns to child available width
              int nextChildWidthInColumns = 1;
              if (nextChildParentData.columnSpan > 1) {
                nextChildWidthInColumns = nextChildParentData.columnSpan;
              }

              // Is next child going to new row
              if (nextChildParentData.fillRow ||
                  columnIndex + widthInColumns + nextChildWidthInColumns >=
                      _actualColumnCount ||
                  childParentData.rowEnd ||
                  nextChildParentData.rowStart) {
                childAvailableWidth +=
                    _columnSpacing * max(0, widthInColumns - 1);
              }
            } else {
              // If last child and has span, then add all space between columns to child available width
              childAvailableWidth +=
                  _columnSpacing * max(0, widthInColumns - 1);
            }
          }
        }

        double xOffset = columnIndex * (_actualColumnWidth + _columnSpacing);

        // If row is ending, then take all available width (ignore column spanning)
        if (childParentData.rowEnd) {
          childAvailableWidth = maxWidth - xOffset;
        } else {
          // Prevent child to spanned out of the available width when column span is used and column has static width
          childAvailableWidth = min(childAvailableWidth, maxWidth - xOffset);
        }

        // Do dry layout measurements
        Size childSize = child.getDryLayout(
          BoxConstraints(
              minWidth: 0,
              minHeight: 0,
              maxWidth: childAvailableWidth,
              maxHeight: double.infinity),
        );

        // Update current row height
        if (currentRowHeight < childSize.height + _rowSpacing) {
          currentRowHeight = childSize.height + _rowSpacing;
        }

        Rect location = Rect.fromLTWH(
            xOffset, yOffset, childAvailableWidth, childSize.height);

        locations.add(location);

        childParentData.offset = Offset(location.left, location.top);

        // Increase column counter
        columnIndex +=
            childParentData.columnSpan > 1 ? childParentData.columnSpan : 1;

        if (childParentData.fillRow || childParentData.rowEnd) {
          yOffset += currentRowHeight;
          columnIndex = 0;
          currentRowHeight = 0;
        }

        child = childParentData.nextSibling;
      }
    }

    return locations;
  }

  ///
  /// Layout children vertical
  ///
  List<Rect> _layoutChildrenVertical(double maxWidth) {
    _calculateColumns(maxWidth);

    // Children locations
    List<Rect> locations = [];

    int nextWholeRowChildIndex = _getNextWholeRowChildIndex(0);
    int groupChildrenCount = nextWholeRowChildIndex;

    int minChildrenInOneColumn =
        (groupChildrenCount / _actualColumnCount).floor();
    int childrenCountLeftToFirstColumns =
        groupChildrenCount - (minChildrenInOneColumn * _actualColumnCount);
    double yOffset = 0;

    int groupColumn = 0;
    int groupColumnIndex = 0;

    List<double> columnHeights = [];

    // final double actualColumnSpacing = ;
    final double actualRowSpacing = _rowSpacing;

    var child = firstChild;
    for (int i = 0; i < childCount; i++) {
      WrapParentData childParentData = child!.parentData as WrapParentData;
      double actualColumnSpacing = groupColumn > 0 ? _columnSpacing : 0;

      if (i == nextWholeRowChildIndex) {
        if (columnHeights.isNotEmpty) {
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

          // Do dry layout measurements
          Size childSize = child.getDryLayout(
            BoxConstraints(
              minWidth: 0,
              minHeight: 0,
              maxWidth: maxWidth,
              maxHeight: double.infinity,
            ),
          );

          Rect location = Rect.fromLTWH(0, yOffset, maxWidth, childSize.height);

          childParentData.offset = Offset(location.left, location.top);

          locations.add(location);

          yOffset += childSize.height + actualRowSpacing;
        }
      } else {
        double columnYOffset =
            columnHeights.length > groupColumn ? columnHeights[groupColumn] : 0;

        double childAvailableWidth = min(_actualColumnWidth, maxWidth);

        Size childSize = child.getDryLayout(
          BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: childAvailableWidth,
            maxHeight: double.infinity,
          ),
        );

        Rect location = Rect.fromLTWH(
            groupColumn * (_actualColumnWidth + actualColumnSpacing),
            yOffset + columnYOffset,
            childAvailableWidth,
            childSize.height);

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
    final int actualMaxColumnsCount = _maxColumnsCount ?? 100000;

    if (_columnsCount != null) {
      _actualColumnCount = _columnsCount!;
      double columnWidthCandidate =
          ((availableWidth + _columnSpacing) / _actualColumnCount) -
              _columnSpacing;
      _actualColumnWidth = max(0, min(columnWidthCandidate, _columnMaxWidth));
    } else if (_columnWidth == null) {
      int columnCountCandidate = 0;
      if (_columnMinWidth != 0) {
        columnCountCandidate = ((availableWidth - _columnSpacing) /
                (max(1, _columnMinWidth) + _columnSpacing))
            .floor();
      } else if (_columnMaxWidth < double.maxFinite) {
        columnCountCandidate = ((availableWidth + _columnSpacing) /
                (max(1, _columnMaxWidth) + _columnSpacing))
            .ceil();
      } else if (_columnMinWidth == 0 && _columnMaxWidth == double.maxFinite) {
        _actualColumnCount = -1;
        _actualColumnWidth = -1;
      }

      _actualColumnCount =
          max(1, min(columnCountCandidate, actualMaxColumnsCount));

      double columnWidthCandidate =
          ((availableWidth + _columnSpacing) / _actualColumnCount) -
              _columnSpacing;

      _actualColumnWidth = max(0, min(columnWidthCandidate, _columnMaxWidth));
    } else {
      _actualColumnCount = max(
          1,
          min(
                  actualMaxColumnsCount,
                  (availableWidth + _columnSpacing) /
                      (_columnWidth ?? 0 + _columnSpacing))
              .floor());
      _actualColumnWidth = _columnWidth ?? 0;
    }
  }

  ///
  /// Get next child which fill whole row
  ///
  int _getNextWholeRowChildIndex(int startIndex) {
    var child = firstChild;

    for (int i = 0; i < startIndex; i++) {
      WrapParentData childParentData = child!.parentData as WrapParentData;
      child = childParentData.nextSibling;
    }

    for (int i = startIndex; i < childCount; i++) {
      WrapParentData childParentData = child!.parentData as WrapParentData;

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
    Key? key,
    @required child,
    rowStart = false,
    rowEnd = false,
    columnSpan = 1,
    fillRow = false,
  })  : columnSpan = columnSpan ?? 1,
        rowStart = rowStart ?? false,
        rowEnd = rowEnd ?? false,
        fillRow = fillRow ?? false,
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
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent != null && targetParent is RenderObject) {
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
      {Key? key,
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
