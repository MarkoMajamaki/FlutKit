import 'package:flutter/material.dart';

///
/// TabShellAppBar style
///
class TabShellAppBarStyle extends ThemeExtension<TabShellAppBarStyle> {
  TabShellAppBarStyle({
    required this.lineIndicatorColor,
    required this.selectedLabelColor,
    required this.unselectedLabelColor,
    required this.outlinedTabColor,
  });

  final Color lineIndicatorColor;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final Color outlinedTabColor;

  @override
  ThemeExtension<TabShellAppBarStyle> copyWith({
    Color? lineIndicatorColor,
    Color? selectedLabelColor,
    Color? unselectedLabelColor,
    Color? outlinedTabColor,
  }) {
    return TabShellAppBarStyle(
      lineIndicatorColor: lineIndicatorColor ?? this.lineIndicatorColor,
      selectedLabelColor: selectedLabelColor ?? this.selectedLabelColor,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      outlinedTabColor: outlinedTabColor ?? this.outlinedTabColor,
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
      selectedLabelColor: selectedLabelColor,
      unselectedLabelColor: unselectedLabelColor,
      outlinedTabColor: outlinedTabColor,
    );
  }
}
