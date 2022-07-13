import 'package:flutter/material.dart';

class TabShellController extends ChangeNotifier {
  String tabName = "";

  TabShellController([String? initialTabName]) {
    tabName = initialTabName ?? "";
  }

  void changeTab(String tabName) {
    tabName = tabName;
    notifyListeners();
  }
}
