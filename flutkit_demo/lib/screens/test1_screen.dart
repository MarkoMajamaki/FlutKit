import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

import 'test2_screen.dart';

class Test1Screen extends StatefulWidget {
  static String route = "test1screen";

  @override
  _Test1ScreenState createState() => _Test1ScreenState();
}

class _Test1ScreenState extends State<Test1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppBar content',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,

      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                child: Text('navigate'),
                onPressed: () {
                  setState(() {
                    // Navigator.pushNamed(context, Test2Screen.route);
                    Navigator.of(context).pushNamed(Test2Screen.route, arguments: Test2ScreenArguments("Navigated from test1 page!"));
                    // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Test2Screen()));
                    // widget.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => Test2Screen()));
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
    );
  }
}
