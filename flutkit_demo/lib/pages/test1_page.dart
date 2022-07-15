import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

import 'test2_page.dart';

class Test1Page extends StatefulWidget {
  const Test1Page({Key? key}) : super(key: key);

  static String route = "test1page";

  @override
  State<Test1Page> createState() => _Test1PageState();
}

class _Test1PageState extends State<Test1Page> {
  final SideBarController _extraMenuController = SideBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AppBar content',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SideBar(
        controller: _extraMenuController,
        menuLocation: MenuLocation.right,
        menuWidth: 300,
        menu: Container(
          color: Colors.white,
          child: const Placeholder(),
        ),
        body: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  child: const Text('navigate'),
                  onPressed: () {
                    setState(() {
                      // Navigator.pushNamed(context, Test2Screen.route);
                      Navigator.of(context).pushNamed(Test2Page.route,
                          arguments: Test2ScreenArguments(
                              "Navigated from test1 page!"));
                      // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Test2Screen()));
                      // widget.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => Test2Screen()));
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('open menu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isMenuOpen = true;
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('close menu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isMenuOpen = false;
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('open submenu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isSubMenuOpen = true;
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('close submenu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isSubMenuOpen = false;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _extraMenuController.isMenuOpen =
                        !_extraMenuController.isMenuOpen;
                  },
                  child: const Text("Open close extra menu"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
