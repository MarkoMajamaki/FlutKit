import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

import 'test1_page.dart';

class Test2Page extends StatefulWidget {
  const Test2Page({Key? key}) : super(key: key);

  static String route = "test2page";

  @override
  State<Test2Page> createState() => _Test2PageState();
}

class _Test2PageState extends State<Test2Page> {
  @override
  Widget build(BuildContext context) {
    Object? args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args == null ? "" : (args as Test2ScreenArguments).text,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  child: const Text('navigate to page 1'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed(Test1Page.route);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Test1Screen()));
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('navigate back'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Test2ScreenArguments {
  final String text;
  Test2ScreenArguments(this.text);
}
