import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

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
class MyWebApp extends StatelessWidget {
  const MyWebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabWebApp(
      bodyMaxWidth: 1200,
      tabDefinitions: [
        TabDefinition(
          route: "tab_route",
          buildAppBarWidget: (context) {
            return Tab(
              child: Text("Tab 1"),
            );
          },
        ),
        TabDefinition(
          route: "tab_route",
          buildAppBarWidget: (context) {
            return Tab(
              child: Text("Tab 2"),
            );
          },
        ),
        TabDefinition(
          route: "tab_route",
          buildAppBarWidget: (context) {
            return Tab(
              child: Text("Tab 3"),
            );
          },
        ),
      ],
      logo: SizedBox(
        height: 50,
        width: 100,
        child: Placeholder(),
      ),
    );
  }
}
