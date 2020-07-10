import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MenuModel extends ChangeNotifier {
  final List<Object> items = [
    MenuItemModel("Item1", "Subtitle 1"),
    MenuItemModel("Item2", "Subtitle 2"),
    MenuItemModel("Item3", "Subtitle 3"),
    MenuItemModel("Item4", "Subtitle 4"),
    SeparatorModel(""),
    MenuItemModel("Item1", "Subtitle 1"),
    MenuItemModel("Item2", "Subtitle 2"),
    MenuItemModel("Item3", "Subtitle 3"),
    SeparatorModel("Separator"),
    MenuItemModel("Item1", "Subtitle 1"),
    MenuItemModel("Item2", "Subtitle 2"),
    MenuItemModel("Item3", "Subtitle 3"),
  ];
}

class MenuItemModel {
  String title;
  String subTitle;

  MenuItemModel(this.title, this.subTitle);

  void doSomething(){
  }
}

class SeparatorModel {
  String title;
  SeparatorModel(this.title);
}