import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key? key}) : super(key: key);

  static String route = "controllers";

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  final SideBarController _controller = SideBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SideBar(
        controller: _controller,
        submenu: const Placeholder(
          color: Colors.red,
        ),
        menu: const Placeholder(
          color: Colors.green,
        ),
        menuWidth: 300,
        subMenuWidth: 300,
        body: Center(
          child: ElevatedButton(
            child: const Text("Test"),
            onPressed: () {
              _controller.isMenuOpen = true;
            },
          ),
        ),
      ),
    );
  }
}
