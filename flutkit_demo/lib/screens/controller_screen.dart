import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

class ControllerScreen extends StatefulWidget {
  static String route = "ControllerScreen";
  ControllerScreen({Key? key}) : super(key: key);

  @override
  _ControllerScreenState createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  SideBarController _controller = SideBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SideBar(
        controller: _controller,
        submenu: Placeholder(
          color: Colors.red,
        ),
        menu: Placeholder(
          color: Colors.green,
        ),
        menuWidth: 300,
        subMenuWidth: 300,
        content: Container(
          child: Center(
            child: ElevatedButton(
              child: Text("Test"),
              onPressed: () {
                _controller.isMenuOpen = true;
              },
            ),
          ),
        ),
      ),
    );
  }
}
