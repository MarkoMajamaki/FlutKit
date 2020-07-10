import 'package:flutkit/screens/menu_screen.dart';
import 'package:flutkit/screens/submenu_screen.dart';
import 'package:flutkit/screens/test1_screen.dart';
import 'package:flutkit/screens/test2_screen.dart';

getRoutes() {
  return {
    SubMenuScreen.route: (context) => SubMenuScreen(),
    MenuScreen.route: (context) => MenuScreen(),
    Test1Screen.route: (context) => Test1Screen(),
    Test2Screen.route: (context) => Test2Screen(),
  };
}