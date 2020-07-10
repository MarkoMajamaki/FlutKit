import 'package:flutkit/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class Test1Screen extends StatefulWidget {
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
                    SideBar.of(context).isMenuOpen(true);
                  });
                },
              ),RaisedButton(
                child: Text('close menu'),
                onPressed: () {
                  setState(() {
                    SideBar.of(context).isMenuOpen(false);
                  });
                },
              ),
              RaisedButton(
                child: Text('open submenu'),
                onPressed: () {
                  setState(() {
                    SideBar.of(context).isSubMenuOpen(true);
                  });
                },
              ),
              RaisedButton(
                child: Text('close submenu'),
                onPressed: () {
                  setState(() {
                    SideBar.of(context).isSubMenuOpen(false);
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
