import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Menu')),
    );
  }
}

/*
Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                child: Text('Close menu', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  setState(() {
                    Provider.of<HomeModel>(context, listen: false).closeMenu();
                  });
                }),
            FlatButton(
                child: Text('Open submenu', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  setState(() {
                    Provider.of<HomeModel>(context, listen: false).openSubMenu();
                  });
                }),

          ],
        ),
      ),

*/
