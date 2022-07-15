import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

import '../routes.dart';
import 'menu_page.dart';
import 'sliver_page.dart';
import 'submenu_page.dart';

// Find better solution later!
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Is app running on mobile
    final bool useMobileLayout = MediaQuery.of(context).size.shortestSide < 600;

    if (useMobileLayout) {
      return SideBar(
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: SliverPage.route,
          routes: getRoutes(),
        ),
        menu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: MenuPage.route,
          routes: getRoutes(),
        ),
        submenu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SubMenuPage.route,
          routes: getRoutes(),
        ),
        subMenuWidth: 250,
        menuSpacing: 64,
        bodyBehavior: BodyBehavior.move,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
      );
    } else {
      return SideBar(
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: SliverPage.route,
          routes: getRoutes(),
        ),
        menu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: MenuPage.route,
          routes: getRoutes(),
        ),
        submenu: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SubMenuPage.route,
          routes: getRoutes(),
        ),
        menuWidth: 230,
        menuNarrowWidth: 60,
        subMenuWidth: 250,
        bodyBehavior: BodyBehavior.resize,
        menuOpenMode: MenuOpenMode.basic,
        menuCloseMode: MenuCloseMode.narrow,
        subMenuOpenMode: SubMenuOpenMode.floating,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
        menuLocation: MenuLocation.left,
      );
    }
  }
}
