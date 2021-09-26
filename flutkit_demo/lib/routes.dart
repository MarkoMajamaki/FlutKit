import 'package:flutkit_demo/screens/controller_screen.dart';
import 'package:flutkit_demo/screens/layout_screen.dart';
import 'package:flutkit_demo/screens/sliver_screen.dart';

import 'screens/menu_screen.dart';
import 'screens/submenu_screen.dart';
import 'screens/test1_screen.dart';
import 'screens/test2_screen.dart';

getRoutes() {
  return {
    SubMenuScreen.route: (context) => SubMenuScreen(),
    MenuScreen.route: (context) => MenuScreen(),
    Test1Screen.route: (context) => Test1Screen(),
    Test2Screen.route: (context) => Test2Screen(),
    LayoutScreen.route: (context) => LayoutScreen(),
    ControllerScreen.route: (context) => ControllerScreen(),
    SliverScreen.route: (context) => SliverScreen(),
  };
}
