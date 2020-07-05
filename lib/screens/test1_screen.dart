import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class Test1Screen extends StatefulWidget {

  @override
  _Test1ScreenState createState() => _Test1ScreenState();
}

class _Test1ScreenState extends State<Test1Screen> with SingleTickerProviderStateMixin {


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
                child: Text('open menu'),
                onPressed: () {
                  setState(() {
                    Provider.of<HomeModel>(context, listen: false).openMenu();
                  });
                },
              ),RaisedButton(
                child: Text('close menu'),
                onPressed: () {
                  setState(() {
                    Provider.of<HomeModel>(context, listen: false).closeMenu();
                  });
                },
              ),
              RaisedButton(
                child: Text('open submenu'),
                onPressed: () {
                  setState(() {
                    Provider.of<HomeModel>(context, listen: false).openSubMenu();
                  });
                },
              ),
              RaisedButton(
                child: Text('close submenu'),
                onPressed: () {
                  setState(() {
                    Provider.of<HomeModel>(context, listen: false).closeSubMenu();
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
