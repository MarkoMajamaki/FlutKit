import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_screen.dart';
import 'submenu_screen.dart';
import 'test1_screen.dart';
import '../widgets/sidebar.dart';

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
        content: Test1Screen(),
        menu: MenuScreen(),
        submenu: SubMenuScreen(),
        subMenuWidth: 250,
        menuSpacing: 64,
        contentBehavior: ContentBehavior.Move,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
      );
    } else{
      return SideBar(
        content: Test1Screen(),
        menu: MenuScreen(),
        submenu: SubMenuScreen(),
        menuWidth: 230,
        subMenuWidth: 250,
        menuSpacing: 64,
        contentBehavior: ContentBehavior.Resize,
        menuOpenMode: MenuOpenMode.Floating,
        menuCloseMode: MenuCloseMode.Narrow,
        subMenuOpenMode: SubMenuOpenMode.Default,
        verticalSeparatorThickness: 1,
        verticalSeparatorColor: Colors.black12,
      );
    }
  }
}