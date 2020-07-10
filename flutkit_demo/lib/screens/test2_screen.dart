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
    final Test2ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.text,
          style: TextStyle(
              color: Colors.black
          ),
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
                RaisedButton(
                  child: Text('navigate to page 1'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed(Test1Screen.route);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Test1Screen()));
                    });
                  },
                ),
                RaisedButton(
                  child: Text('navigate back'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                RaisedButton(
                  child: Text('open menu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isMenuOpen = true;
                    });
                  },
                ),
                RaisedButton(
                  child: Text('close menu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isMenuOpen = false;
                    });
                  },
                ),
                RaisedButton(
                  child: Text('open submenu'),
                  onPressed: () {
                    setState(() {
                      SideBar.of(context).isSubMenuOpen = true;
                    });
                  },
                ),
                RaisedButton(
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