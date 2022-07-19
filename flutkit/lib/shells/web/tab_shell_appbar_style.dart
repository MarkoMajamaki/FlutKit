import 'package:flutter/material.dart';

///
/// TabShellAppBar style
///
class TabShellAppBarStyle extends ThemeExtension<TabShellAppBarStyle> {
  TabShellAppBarStyle({
    this.lineIndicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.outlinedTabColor,
    this.labelStyle,
    this.outlinedLabelStyle,
  });

  final Color? lineIndicatorColor;
  final Color? selectedLabelColor;
  final Color? unselectedLabelColor;
  final Color? outlinedTabColor;
  final TextStyle? labelStyle;
  final TextStyle? outlinedLabelStyle;

  @override
  ThemeExtension<TabShellAppBarStyle> copyWith({
    Color? lineIndicatorColor,
    Color? selectedLabelColor,
    Color? unselectedLabelColor,
    Color? outlinedTabColor,
    TextStyle? labelStyle,
    TextStyle? outlinedLabelStyle,
  }) {
    return TabShellAppBarStyle(
      lineIndicatorColor: lineIndicatorColor ?? this.lineIndicatorColor,
      selectedLabelColor: selectedLabelColor ?? this.selectedLabelColor,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      outlinedTabColor: outlinedTabColor ?? this.outlinedTabColor,
      labelStyle: labelStyle ?? this.labelStyle,
      outlinedLabelStyle: outlinedLabelStyle ?? this.outlinedLabelStyle,
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
      labelStyle: labelStyle,
      outlinedLabelStyle: outlinedLabelStyle,
    );
  }

  static TabShellAppBarStyle? maybeOf(BuildContext context) {
    if (Theme.of(context).extensions.containsKey(TabShellAppBarStyle) ==
        false) {
      return null;
    }
    return Theme.of(context).extension<TabShellAppBarStyle>();
  }

  static TabShellAppBarStyle of(BuildContext context) {
    return Theme.of(context).extension<TabShellAppBarStyle>()!;
  }
}
