import 'package:flutkit/sidebar.dart';
import 'package:flutter/material.dart';

import '../routes.dart';
import 'menu_screen.dart';
import 'submenu_screen.dart';
import 'test1_screen.dart';

// Find better solution later!
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    // Is app running on mobile
    final bool useMobileLayout = MediaQuery.of(context).size.shortestSide < 600;

    if (useMobileLayout) {
      return SideBar(
        content: MaterialApp(
          navigatorKey: navigatorKey,
          initialRoute: Test1Screen.route,
          routes: getRoutes(),
        ),
        menu: MaterialApp(
          initialRoute: MenuScreen.route,
          routes: getRoutes(),
        ),
        submenu: MaterialApp(
          initialRoute: SubMenuScreen.route,
          routes: getRoutes(),
        ),
        subMenuWidth: 250,
        menuSpacing: 64,
        contentBehavior: ContentBehavior.Move,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
      );
    } else{
      return SideBar(
        content: MaterialApp(
          navigatorKey: navigatorKey,
          initialRoute: Test1Screen.route,
          routes: getRoutes(),
        ),
        menu: MaterialApp(
          initialRoute: MenuScreen.route,
          routes: getRoutes(),
        ),
        submenu: MaterialApp(
          initialRoute: SubMenuScreen.route,
          routes: getRoutes(),
        ),
        menuWidth: 230,
        menuNarrowWidth: 60,
        subMenuWidth: 250,
        contentBehavior: ContentBehavior.Resize,
        menuOpenMode: MenuOpenMode.Default,
        menuCloseMode: MenuCloseMode.Narrow,
        subMenuOpenMode: SubMenuOpenMode.Floating,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
      );
    }
  }
}