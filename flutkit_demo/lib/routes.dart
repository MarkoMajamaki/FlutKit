import 'pages/controller_page.dart';
import 'pages/layout_page.dart';
import 'pages/menu_page.dart';
import 'pages/sliver_page.dart';
import 'pages/submenu_page.dart';
import 'pages/test1_page.dart';
import 'pages/test2_page.dart';

getRoutes() {
  return {
    SubMenuPage.route: (context) => const SubMenuPage(),
    MenuPage.route: (context) => const MenuPage(),
    Test1Page.route: (context) => const Test1Page(),
    Test2Page.route: (context) => const Test2Page(),
    LayoutPage.route: (context) => const LayoutPage(),
    ControllerPage.route: (context) => const ControllerPage(),
    SliverPage.route: (context) => const SliverPage(),
  };
}
