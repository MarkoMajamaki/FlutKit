import 'package:flutkit/flutkit.dart';
import 'package:flutkit_demo/pages/home_page.dart';
import 'package:flutkit_demo/pages/layout_page.dart';
import 'package:flutter/material.dart';

import 'pages/menu_page.dart';
import 'pages/sliver_page.dart';
import 'pages/test1_page.dart';
import 'pages/test2_page.dart';

void main() {
  runApp(const MyWebApp());
}

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutScreen(),
    );
  }
}
*/
class MyWebApp extends StatefulWidget {
  const MyWebApp({Key? key}) : super(key: key);

  @override
  State<MyWebApp> createState() => _MyWebAppState();
}

class _MyWebAppState extends State<MyWebApp> with TickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    TabDefinition(
      route: Test1Page.route,
      text: "Test1",
      buildPage: (context) => const Test1Page(),
    ),
    TabDefinition(
      route: Test2Page.route,
      text: "Test2",
      buildPage: (context) => const Test2Page(),
    ),
    TabDefinition(
      route: LayoutPage.route,
      text: "LayoutPage",
      buildPage: (context) => const LayoutPage(),
    ),
    TabDefinition(
      route: MenuPage.route,
      text: "MenuPage",
      buildPage: (context) => const Test2Page(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabWebApp(
      tabController: _tabController,
      theme: getTheme(),
      bodyMaxWidth: 1200,
      tabs: tabs,
      logo: const SizedBox(
        height: 50,
        width: 100,
        child: Placeholder(),
      ),
    );
  }
}

ThemeData getTheme() {
  return ThemeData(
    primaryColor: Colors.green,
    extensions: <ThemeExtension<dynamic>>{
      TabShellAppBarStyle(
        lineIndicatorColor: Colors.green,
        selectedLabelColor: Colors.green,
        unselectedLabelColor: Colors.black,
        outlinedTabColor: Colors.green,
      ),
    },
  );
}
