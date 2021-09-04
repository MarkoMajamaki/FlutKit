import 'package:flutkit/flutkit.dart';
import 'package:flutkit_demo/screens/controller_screen.dart';
import 'package:flutkit_demo/screens/layout_screen.dart';
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
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: Test1Screen.route,
          routes: getRoutes(),
        ),
        menu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: MenuScreen.route,
          routes: getRoutes(),
        ),
        submenu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SubMenuScreen.route,
          routes: getRoutes(),
        ),
        subMenuWidth: 250,
        menuSpacing: 64,
        bodyBehavior: BodyBehavior.Move,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
      );
    } else {
      return SideBar(
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: Test1Screen.route,
          routes: getRoutes(),
        ),
        menu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: MenuScreen.route,
          routes: getRoutes(),
        ),
        submenu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SubMenuScreen.route,
          routes: getRoutes(),
        ),
        menuWidth: 230,
        menuNarrowWidth: 60,
        subMenuWidth: 250,
        bodyBehavior: BodyBehavior.Resize,
        menuOpenMode: MenuOpenMode.Default,
        menuCloseMode: MenuCloseMode.Narrow,
        subMenuOpenMode: SubMenuOpenMode.Floating,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
        menuLocation: MenuLocation.Left,
      );
    }
  }
}
