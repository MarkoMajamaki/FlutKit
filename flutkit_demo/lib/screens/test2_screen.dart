import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

import 'test1_screen.dart';

class Test2Screen extends StatefulWidget {
  static String route = "test2screen";

  @override
  _Test2ScreenState createState() => _Test2ScreenState();
}

class _Test2ScreenState extends State<Test2Screen> {
  @override
  Widget build(BuildContext context) {
    Object? args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args == null ? "" : (args as Test2ScreenArguments).text,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
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
                  child: Text('navigate to page 1'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed(Test1Screen.route);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Test1Screen()));
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('navigate back'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('open menu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isMenuOpen = true;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('close menu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isMenuOpen = false;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('open submenu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isSubMenuOpen = true;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('close submenu'),
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
